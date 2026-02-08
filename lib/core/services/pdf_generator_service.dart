import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'dart:typed_data';
import '../database/database.dart';
import 'package:intl/intl.dart';

/// Servicio para generar reportes PDF corporativos
class PdfGeneratorService {
  /// Genera un PDF de reporte de actividades
  static Future<void> generateActivityReport({
    required List<Actividade> actividades,
    required String clienteNombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    String? nombreEmpresa,
    String? direccionEmpresa,
    String? telefonoEmpresa,
    Uint8List? logoBytes,
  }) async {
    final pdf = pw.Document();

    // Usar fuente estándar (Helvetica) para evitar errores de carga de assets/manifiestos
    final ttf = pw.Font.helvetica();

    final totalPrecio = actividades.fold<double>(
      0,
      (sum, item) => sum + (item.precio ?? 0),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) => [
          // Header
          _buildHeader(
            nombreEmpresa ?? 'MeLA Node',
            direccionEmpresa,
            telefonoEmpresa,
            logoBytes,
            ttf,
          ),

          pw.SizedBox(height: 30),

          // Título del reporte
          _buildReportTitle(
            clienteNombre,
            fechaInicio,
            fechaFin,
            totalPrecio,
            ttf,
          ),

          pw.SizedBox(height: 20),

          // Resumen estadístico
          _buildSummary(actividades, ttf),

          pw.SizedBox(height: 30),

          // Tabla de actividades
          _buildActivitiesTable(actividades, ttf),

          pw.SizedBox(height: 40),

          // Footer
          _buildFooter(ttf),
        ],
        footer: (context) => _buildPageFooter(context, ttf),
      ),
    );

    // Mostrar diálogo de impresión/guardar
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name:
          'reporte_${clienteNombre.replaceAll(' ', '_')}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  static pw.Widget _buildHeader(
    String empresa,
    String? direccion,
    String? telefono,
    Uint8List? logoBytes,
    pw.Font font,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#1E3A8A'),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(15)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                empresa,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              if (direccion != null)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 4),
                  child: pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text: 'Dirección: ',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.TextSpan(
                          text: direccion,
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                            color: PdfColors.grey300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (telefono != null)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 2),
                  child: pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text: 'Contacto: ',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                        pw.TextSpan(
                          text: telefono,
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
                            color: PdfColors.grey300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          pw.Container(
            width: 60,
            height: 60,
            child: logoBytes != null
                ? pw.ClipRRect(
                    horizontalRadius: 10,
                    verticalRadius: 10,
                    child: pw.Image(
                      pw.MemoryImage(logoBytes),
                      fit: pw.BoxFit.cover,
                    ),
                  )
                : pw.Center(
                    child: pw.Text(
                      'LOGO',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildReportTitle(
    String cliente,
    DateTime inicio,
    DateTime fin,
    double totalPrecio,
    pw.Font font,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'Reporte de Actividades',
              style: pw.TextStyle(
                font: font,
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#111827'),
              ),
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Monto Total',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.Text(
                  'Bs ${totalPrecio.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#3B82F6'),
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            pw.Text(
              'Cliente: ',
              style: pw.TextStyle(
                font: font,
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(cliente, style: pw.TextStyle(font: font, fontSize: 14)),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text(
              'Período: ',
              style: pw.TextStyle(
                font: font,
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              '${DateFormat('dd/MM/yyyy').format(inicio)} - ${DateFormat('dd/MM/yyyy').format(fin)}',
              style: pw.TextStyle(font: font, fontSize: 14),
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: [
            pw.Text(
              'Fecha de generación: ',
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
              style: pw.TextStyle(font: font, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildSummary(List<Actividade> actividades, pw.Font font) {
    // Agrupar por tipo
    final Map<String, int> conteoPorTipo = {};
    for (var actividad in actividades) {
      conteoPorTipo[actividad.tipo] = (conteoPorTipo[actividad.tipo] ?? 0) + 1;
    }

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F3F4F6'),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Wrap(
        alignment: pw.WrapAlignment.spaceAround,
        spacing: 20,
        runSpacing: 10,
        children: conteoPorTipo.entries.map((entry) {
          return _buildStatItem(
            entry.key, // Nombre del tipo
            entry.value.toString(), // Cantidad
            PdfColor.fromHex('#10B981'), // Color verde para tipos
            font,
          );
        }).toList(),
      ),
    );
  }

  static pw.Widget _buildStatItem(
    String label,
    String value,
    PdfColor color,
    pw.Font font,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            font: font,
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          label,
          style: pw.TextStyle(
            font: font,
            fontSize: 12,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildActivitiesTable(
    List<Actividade> actividades,
    pw.Font font,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFF1E3A8A),
          ),
          children: [
            _buildTableHeader('#', font),
            _buildTableHeader('Actividad', font),
            _buildTableHeader('Tipo', font),
            _buildTableHeader('Estado', font),
            _buildTableHeader('Fecha', font),
            _buildTableHeader('Precio (Bs)', font),
          ],
        ),
        // Rows
        ...List.generate(actividades.length, (index) {
          final actividad = actividades[index];
          return pw.TableRow(
            decoration: pw.BoxDecoration(
              color: index % 2 == 0
                  ? PdfColors.white
                  : PdfColor.fromHex('#F3F4F6'),
            ),
            children: [
              _buildTableCell((index + 1).toString(), font),
              _buildTableCell(actividad.nombreActividad, font),
              _buildTableCell(actividad.tipo, font),
              _buildTableCell(actividad.estado, font),
              _buildTableCell(
                DateFormat('dd/MM/yyyy').format(actividad.fechaInicio),
                font,
              ),
              _buildTableCell(
                actividad.precio != null
                    ? 'Bs ${actividad.precio!.toStringAsFixed(2)}'
                    : 'Bs 0.00',
                font,
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildTableHeader(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 10),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Font font) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey400, width: 2),
        ),
      ),
      child: pw.Center(
        child: pw.Text(
          'Este reporte ha sido generado automáticamente por el sistema PORTEX by "Mela Node".\n'
          'Para más información, contacte con su proveedor de servicios.',
          style: pw.TextStyle(
            font: font,
            fontSize: 10,
            color: PdfColors.grey600,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ),
    );
  }

  static pw.Widget _buildPageFooter(pw.Context context, pw.Font font) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'Página ${context.pageNumber} de ${context.pagesCount}',
        style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey),
      ),
    );
  }
}
