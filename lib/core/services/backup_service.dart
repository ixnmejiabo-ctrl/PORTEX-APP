import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Servicio para backup y restore de la base de datos
class BackupService {
  /// Realiza un backup de la base de datos
  /// Realiza un backup de la base de datos
  /// En Desktop: Permite al usuario elegir la ubicación
  /// En Android: Guarda automáticamente en /Downloads/PORTEX/
  static Future<String?> backupDatabase(String dbPath) async {
    try {
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        throw Exception('Base de datos no encontrada');
      }

      // Generar nombre sugerido con fecha
      final timestamp = DateTime.now().toIso8601String().split(
        'T',
      )[0]; // YYYY-MM-DD
      final fileName = 'portex_backup_$timestamp.db';

      // Lógica específica para Android
      if (Platform.isAndroid) {
        // Solicitar permisos de almacenamiento
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          status = await Permission.manageExternalStorage.request();
        }

        // Fallback para versiones antiguas de Android
        if (!status.isGranted) {
          status = await Permission.storage.status;
          if (!status.isGranted) {
            status = await Permission.storage.request();
          }
        }

        if (status.isGranted) {
          // Directorio de Descargas público
          final downloadsDir = Directory('/storage/emulated/0/Download');
          if (!await downloadsDir.exists()) {
            // Fallback a getExternalStorageDirectory si no existe (raro)
            final extDir = await getExternalStorageDirectory();
            if (extDir == null) {
              throw Exception('No se pudo acceder al almacenamiento');
            }
            // Esto nos daría ruta de app, pero el usuario quiere Descargas.
            // Asumimos que /storage/emulated/0/Download es estándar.
            throw Exception('No se encontró la carpeta de Descargas');
          }

          final portexDir = Directory('${downloadsDir.path}/PORTEX');
          if (!await portexDir.exists()) {
            await portexDir.create(recursive: true);
          }

          final backupPath = '${portexDir.path}/$fileName';
          await dbFile.copy(backupPath);
          return backupPath;
        } else {
          throw Exception('Permisos de almacenamiento denegados');
        }
      }
      // Lógica para Desktop (Windows/Linux/MacOS)
      else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Abrir diálogo para guardar archivo
        final result = await FilePicker.platform.saveFile(
          dialogTitle: 'Guardar Copia de Seguridad',
          fileName: fileName,
          allowedExtensions: ['db'],
          type: FileType.custom,
          lockParentWindow: true,
        );

        if (result != null) {
          // Copiar base de datos a la ubicación seleccionada
          await dbFile.copy(result);
          return result;
        }
      } else {
        // Fallback para otras plataformas (iOS/Web?)
        // Usar FilePicker como default
        final result = await FilePicker.platform.saveFile(
          dialogTitle: 'Guardar Copia de Seguridad',
          fileName: fileName,
          allowedExtensions: ['db'],
          type: FileType.custom,
        );

        if (result != null) {
          await dbFile.copy(result);
          return result;
        }
      }

      return null; // Usuario canceló
    } catch (e) {
      debugPrint('Error al crear backup: $e');
      rethrow; // Propagar error para manejarlo en UI
    }
  }

  /// Restaura la base de datos desde un archivo de backup
  static Future<bool> restoreDatabase(String dbPath, String backupPath) async {
    try {
      final backupFile = File(backupPath);
      final dbFile = File(dbPath);

      if (!await backupFile.exists()) {
        throw Exception('Archivo de backup no encontrado');
      }

      // Intentar eliminar la base de datos actual para evitar bloqueos de escritura/reemplazo
      if (await dbFile.exists()) {
        try {
          await dbFile.delete();
        } catch (e) {
          debugPrint(
            'No se pudo eliminar el archivo DB existente (podría estar bloqueado): $e',
          );
          // Si falla al eliminar, intentamos copiar encima de todos modos,
          // pero probablemente fallará si está bloqueado.
        }
      }

      // Copiar backup sobre la ruta de la BD
      await backupFile.copy(dbPath);

      return true;
    } catch (e) {
      debugPrint('Error al restaurar backup: $e');
      return false;
    }
  }

  /// Permite al usuario seleccionar un archivo de backup para restaurar
  static Future<String?> pickBackupFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
        dialogTitle: 'Seleccionar archivo de backup',
      );

      if (result != null && result.files.single.path != null) {
        return result.files.single.path;
      }

      return null;
    } catch (e) {
      debugPrint('Error al seleccionar archivo: $e');
      return null;
    }
  }

  /// Exporta el backup a una ubicación seleccionada por el usuario
  static Future<bool> exportBackup(String backupPath) async {
    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Guardar backup',
        fileName:
            'portex_backup_${DateTime.now().toIso8601String().split('T')[0]}.db',
      );

      if (result != null) {
        final backupFile = File(backupPath);
        await backupFile.copy(result);
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error al exportar backup: $e');
      return false;
    }
  }

  /// Lista todos los backups disponibles
  static Future<List<FileSystemEntity>> listBackups() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final backupDir = Directory('${directory.path}/backups');

      if (!await backupDir.exists()) {
        return [];
      }

      final backups = await backupDir.list().toList();
      backups.sort((a, b) => b.path.compareTo(a.path)); // Más recientes primero

      return backups;
    } catch (e) {
      debugPrint('Error al listar backups: $e');
      return [];
    }
  }

  /// Elimina un backup específico
  static Future<bool> deleteBackup(String backupPath) async {
    try {
      final backupFile = File(backupPath);

      if (await backupFile.exists()) {
        await backupFile.delete();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error al eliminar backup: $e');
      return false;
    }
  }
}
