import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/database/database.dart';
import '../../../core/services/pdf_generator_service.dart';
import 'package:intl/intl.dart';

/// Pantalla para generar reportes PDF de actividades
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Cliente> _clientes = [];
  Cliente? _selectedCliente;
  DateTime _fechaInicio = DateTime.now().subtract(Duration(days: 30));
  DateTime _fechaFin = DateTime.now();
  bool _isGenerating = false;
  int _actividadesEncontradas = 0;

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final clientes = await db.obtenerTodosLosClientes();
    setState(() {
      _clientes = clientes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          isMobile ? DesignTokens.space12 : DesignTokens.space24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(isDark).animate().fadeIn(duration: 200.ms),

            const SizedBox(height: DesignTokens.space32),

            // Formulario de filtros
            _buildFilterForm(isDark).animate().fadeIn(delay: 50.ms),

            const SizedBox(height: DesignTokens.space32),

            // Botón de generar
            _buildGenerateButton(isDark).animate().fadeIn(delay: 100.ms),

            if (_actividadesEncontradas > 0) ...[
              const SizedBox(height: DesignTokens.space24),
              _buildResultsCard(isDark).animate().fadeIn(delay: 150.ms),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.picture_as_pdf_rounded,
              color: DesignTokens.urgentRed,
              size: isMobile ? 24 : 32,
            ),
            SizedBox(
              width: isMobile ? DesignTokens.space8 : DesignTokens.space16,
            ),
            Flexible(
              child: Text(
                'Generador de Reportes PDF',
                style: TextStyle(
                  fontSize: isMobile
                      ? DesignTokens.fontSize20
                      : DesignTokens.fontSize32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Color(0xFF111827),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignTokens.space12),
        Text(
          'Genera reportes de actividades filtrados por cliente y rango de fechas',
          style: TextStyle(
            fontSize: DesignTokens.fontSize16,
            color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterForm(bool isDark) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtros de Reporte',
            style: TextStyle(
              fontSize: DesignTokens.fontSize20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
            ),
          ),
          const SizedBox(height: DesignTokens.space24),

          // Selector de cliente
          DropdownButtonFormField<Cliente>(
            initialValue: _selectedCliente,
            decoration: InputDecoration(
              labelText: 'Cliente *',
              prefixIcon: Icon(Icons.person_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              ),
            ),
            items: _clientes.map((cliente) {
              return DropdownMenuItem(
                value: cliente,
                child: Text(cliente.empresa),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCliente = value;
                _actividadesEncontradas = 0;
              });
            },
          ),

          const SizedBox(height: DesignTokens.space16),

          // Fecha inicio
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.calendar_today_rounded),
            title: Text('Fecha Inicio'),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(_fechaInicio)),
            trailing: Icon(Icons.edit_rounded, size: 20),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _fechaInicio,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => _fechaInicio = picked);
              }
            },
          ),

          const Divider(),

          // Fecha fin
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.event_rounded),
            title: Text('Fecha Fin'),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(_fechaFin)),
            trailing: Icon(Icons.edit_rounded, size: 20),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _fechaFin,
                firstDate: _fechaInicio,
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _fechaFin = picked);
              }
            },
          ),

          const SizedBox(height: DesignTokens.space16),

          // Rangos rápidos
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickRangeChip('Este mes', _setThisMonth, isDark),
              _buildQuickRangeChip('Mes pasado', _setLastMonth, isDark),
              _buildQuickRangeChip('Últimos 7 días', _setLast7Days, isDark),
              _buildQuickRangeChip('Últimos 30 días', _setLast30Days, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickRangeChip(String label, VoidCallback onTap, bool isDark) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: isDark ? DesignTokens.darkGray : Color(0xFFE5E7EB),
      labelStyle: TextStyle(
        fontSize: DesignTokens.fontSize12,
        color: isDark ? Colors.white : Color(0xFF1F2937),
      ),
    );
  }

  void _setThisMonth() {
    final now = DateTime.now();
    setState(() {
      _fechaInicio = DateTime(now.year, now.month, 1);
      _fechaFin = DateTime(now.year, now.month + 1, 0);
    });
  }

  void _setLastMonth() {
    final now = DateTime.now();
    setState(() {
      _fechaInicio = DateTime(now.year, now.month - 1, 1);
      _fechaFin = DateTime(now.year, now.month, 0);
    });
  }

  void _setLast7Days() {
    final now = DateTime.now();
    setState(() {
      _fechaInicio = now.subtract(Duration(days: 7));
      _fechaFin = now;
    });
  }

  void _setLast30Days() {
    final now = DateTime.now();
    setState(() {
      _fechaInicio = now.subtract(Duration(days: 30));
      _fechaFin = now;
    });
  }

  Widget _buildGenerateButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _isGenerating ? null : _generarReporte,
        icon: _isGenerating
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(Icons.picture_as_pdf_rounded),
        label: Text(
          _isGenerating ? 'Generando PDF...' : 'Generar Reporte PDF',
          style: TextStyle(
            fontSize: DesignTokens.fontSize16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: DesignTokens.urgentRed,
          padding: const EdgeInsets.symmetric(vertical: DesignTokens.space16),
        ),
      ),
    );
  }

  Widget _buildResultsCard(bool isDark) {
    return GlassCard(
      child: Column(
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 64,
            color: DesignTokens.safeGreen,
          ),
          const SizedBox(height: DesignTokens.space16),
          Text(
            'Reporte Generado',
            style: TextStyle(
              fontSize: DesignTokens.fontSize20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Color(0xFF111827),
            ),
          ),
          const SizedBox(height: DesignTokens.space8),
          Text(
            'Se encontraron $_actividadesEncontradas actividades',
            style: TextStyle(
              fontSize: DesignTokens.fontSize14,
              color: isDark ? DesignTokens.meteorGray : Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generarReporte() async {
    if (_selectedCliente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor selecciona un cliente'),
          backgroundColor: DesignTokens.warningYellow,
        ),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final db = Provider.of<AppDatabase>(context, listen: false);

      // Obtener actividades del cliente en el rango de fechas
      final todasActividades = await db.obtenerActividadesPorCliente(
        _selectedCliente!.id,
      );
      final actividadesFiltradas = todasActividades.where((a) {
        return a.fechaInicio.isAfter(
              _fechaInicio.subtract(Duration(days: 1)),
            ) &&
            a.fechaInicio.isBefore(_fechaFin.add(Duration(days: 1)));
      }).toList();

      setState(() {
        _actividadesEncontradas = actividadesFiltradas.length;
      });

      if (actividadesFiltradas.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No se encontraron actividades en el rango seleccionado',
              ),
              backgroundColor: DesignTokens.warningYellow,
            ),
          );
        }
        return;
      }

      // Cargar datos de la empresa
      final prefs = await SharedPreferences.getInstance();
      final nombreEmpresa = prefs.getString('company_name') ?? 'MeLA Node';
      final direccionEmpresa = prefs.getString('company_address');
      final telefonoEmpresa = prefs.getString('company_phone');

      // Cargar logo
      Uint8List? logoBytes;
      try {
        final byteData = await rootBundle.load('assets/images/logo.png');
        logoBytes = byteData.buffer.asUint8List();
      } catch (e) {
        debugPrint('Error cargando logo para PDF: $e');
      }

      // Generar PDF con el servicio
      await PdfGeneratorService.generateActivityReport(
        actividades: actividadesFiltradas,
        clienteNombre: _selectedCliente!.empresa,
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin,
        nombreEmpresa: nombreEmpresa,
        direccionEmpresa: direccionEmpresa,
        telefonoEmpresa: telefonoEmpresa,
        logoBytes: logoBytes,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reporte PDF generado exitosamente'),
            backgroundColor: DesignTokens.safeGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar reporte: $e'),
            backgroundColor: DesignTokens.urgentRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }
}
