import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import '../database/database.dart';
import '../models/sync_result.dart';

/// Cliente HTTP para sincronización P2P
/// Se ejecuta en la app móvil Android
class LocalSyncClient {
  final AppDatabase db;
  String? serverIp;
  int serverPort;
  String? authToken;

  LocalSyncClient(
    this.db, {
    this.serverIp,
    this.serverPort = 8080,
    this.authToken,
  });

  /// Verificar conexión con el servidor
  Future<bool> checkConnection() async {
    if (serverIp == null) return false;

    try {
      final response = await http
          .get(Uri.parse('http://$serverIp:$serverPort/ping'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'ok';
      }

      return false;
    } catch (e) {
      debugPrint('❌ [SYNC CLIENT] Error al verificar conexión: $e');
      return false;
    }
  }

  /// Obtener información del servidor
  Future<Map<String, dynamic>?> getServerInfo() async {
    if (serverIp == null || authToken == null) return null;

    try {
      final response = await http
          .get(
            Uri.parse('http://$serverIp:$serverPort/info'),
            headers: {'Authorization': 'Bearer $authToken'},
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      debugPrint('❌ [SYNC CLIENT] Error al obtener info del servidor: $e');
      return null;
    }
  }

  /// Sincronizar todo: push y pull de todas las entidades
  Future<SyncResult> syncAll() async {
    final errors = <String>[];
    int actividadesPushed = 0;
    int actividadesPulled = 0;
    int clientesPushed = 0;
    int clientesPulled = 0;
    int serviciosPushed = 0;
    int serviciosPulled = 0;

    try {
      if (!await checkConnection()) {
        throw Exception('No hay conexión con el servidor');
      }

      debugPrint('🔄 [SYNC CLIENT] Iniciando sincronización...');

      // 1. PUSH: Enviar cambios locales al servidor
      try {
        actividadesPushed = await _pushActividades();
        debugPrint('📤 [SYNC CLIENT] Actividades enviadas: $actividadesPushed');
      } catch (e) {
        errors.add('Error push actividades: $e');
      }

      try {
        clientesPushed = await _pushClientes();
        debugPrint('📤 [SYNC CLIENT] Clientes enviados: $clientesPushed');
      } catch (e) {
        errors.add('Error push clientes: $e');
      }

      try {
        serviciosPushed = await _pushServicios();
        debugPrint('📤 [SYNC CLIENT] Servicios enviados: $serviciosPushed');
      } catch (e) {
        errors.add('Error push servicios: $e');
      }

      // 2. PULL: Obtener cambios del servidor
      try {
        actividadesPulled = await _pullActividades();
        debugPrint(
          '📥 [SYNC CLIENT] Actividades recibidas: $actividadesPulled',
        );
      } catch (e) {
        errors.add('Error pull actividades: $e');
      }

      try {
        clientesPulled = await _pullClientes();
        debugPrint('📥 [SYNC CLIENT] Clientes recibidos: $clientesPulled');
      } catch (e) {
        errors.add('Error pull clientes: $e');
      }

      try {
        serviciosPulled = await _pullServicios();
        debugPrint('📥 [SYNC CLIENT] Servicios recibidos: $serviciosPulled');
      } catch (e) {
        errors.add('Error pull servicios: $e');
      }

      // 3. Actualizar timestamp de última sincronización
      await db.updateLastSyncTimestamp(DateTime.now());
      await db.updateServerIp(serverIp);

      debugPrint('✅ [SYNC CLIENT] Sincronización completa');

      return SyncResult(
        actividadesPushed: actividadesPushed,
        actividadesPulled: actividadesPulled,
        clientesPushed: clientesPushed,
        clientesPulled: clientesPulled,
        serviciosPushed: serviciosPushed,
        serviciosPulled: serviciosPulled,
        errors: errors,
      );
    } catch (e) {
      errors.add('Error general: $e');
      return SyncResult(
        actividadesPushed: actividadesPushed,
        actividadesPulled: actividadesPulled,
        clientesPushed: clientesPushed,
        clientesPulled: clientesPulled,
        serviciosPushed: serviciosPushed,
        serviciosPulled: serviciosPulled,
        errors: errors,
      );
    }
  }

  // ===== PUSH METHODS =====

  Future<int> _pushActividades() async {
    final actividades = await db.getActividadesNotSynced();

    if (actividades.isEmpty) return 0;

    final actividadesJson = actividades
        .map((a) => _actividadToJson(a))
        .toList();

    final response = await http
        .post(
          Uri.parse('http://$serverIp:$serverPort/actividades'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode(actividadesJson),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      // Marcar como sincronizadas
      final ids = actividades.map((a) => a.id).toList();
      await db.markAllActividadesSynced(ids);
      return actividades.length;
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }

  Future<int> _pushClientes() async {
    final clientes = await db.getClientesNotSynced();

    if (clientes.isEmpty) return 0;

    final clientesJson = clientes.map((c) => _clienteToJson(c)).toList();

    final response = await http
        .post(
          Uri.parse('http://$serverIp:$serverPort/clientes'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode(clientesJson),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final ids = clientes.map((c) => c.id).toList();
      await db.markAllClientesSynced(ids);
      return clientes.length;
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }

  Future<int> _pushServicios() async {
    final servicios = await db.getServiciosNotSynced();

    if (servicios.isEmpty) return 0;

    final serviciosJson = servicios.map((s) => _servicioToJson(s)).toList();

    final response = await http
        .post(
          Uri.parse('http://$serverIp:$serverPort/servicios'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
          body: jsonEncode(serviciosJson),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final ids = servicios.map((s) => s.id).toList();
      await db.markAllServiciosSynced(ids);
      return servicios.length;
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }

  // ===== PULL METHODS =====

  Future<int> _pullActividades() async {
    final lastSync = await db.getLastSyncTimestamp();
    final url = lastSync != null
        ? 'http://$serverIp:$serverPort/actividades?since=${lastSync.toIso8601String()}'
        : 'http://$serverIp:$serverPort/actividades';

    final response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $authToken'})
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List<dynamic> actividadesJson = jsonDecode(response.body);

      for (final actividadJson in actividadesJson) {
        final companion = _jsonToActividadCompanion(actividadJson);
        await db.insertOrUpdateActividad(companion);
      }

      return actividadesJson.length;
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }

  Future<int> _pullClientes() async {
    final lastSync = await db.getLastSyncTimestamp();
    final url = lastSync != null
        ? 'http://$serverIp:$serverPort/clientes?since=${lastSync.toIso8601String()}'
        : 'http://$serverIp:$serverPort/clientes';

    final response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $authToken'})
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List<dynamic> clientesJson = jsonDecode(response.body);

      for (final clienteJson in clientesJson) {
        final companion = _jsonToClienteCompanion(clienteJson);
        await db.insertOrUpdateCliente(companion);
      }

      return clientesJson.length;
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }

  Future<int> _pullServicios() async {
    final lastSync = await db.getLastSyncTimestamp();
    final url = lastSync != null
        ? 'http://$serverIp:$serverPort/servicios?since=${lastSync.toIso8601String()}'
        : 'http://$serverIp:$serverPort/servicios';

    final response = await http
        .get(Uri.parse(url), headers: {'Authorization': 'Bearer $authToken'})
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List<dynamic> serviciosJson = jsonDecode(response.body);

      for (final servicioJson in serviciosJson) {
        final companion = _jsonToServicioCompanion(servicioJson);
        await db.insertOrUpdateServicio(companion);
      }

      return serviciosJson.length;
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }

  // ===== CONVERSIÓN JSON (idéntica al servidor) =====

  Map<String, dynamic> _actividadToJson(Actividade a) {
    return {
      'id': a.id,
      'nombreActividad': a.nombreActividad,
      'descripcion': a.descripcion,
      'tipo': a.tipo,
      'estado': a.estado,
      'plataforma': a.plataforma,
      'fechaInicio': a.fechaInicio.toIso8601String(),
      'fechaPublicado': a.fechaPublicado?.toIso8601String(),
      'clienteId': a.clienteId,
      'nombreClienteManual': a.nombreClienteManual,
      'notas': a.notas,
      'precio': a.precio,
      'completada': a.completada,
      'synced': a.synced,
      'updatedAt': a.updatedAt.toIso8601String(),
      'version': a.version,
    };
  }

  ActividadesCompanion _jsonToActividadCompanion(Map<String, dynamic> json) {
    return ActividadesCompanion.insert(
      id: json['id'] != null ? Value(json['id'] as int) : const Value.absent(),
      nombreActividad: json['nombreActividad'] as String,
      descripcion: json['descripcion'] as String,
      tipo: json['tipo'] as String,
      estado: json['estado'] as String,
      plataforma: json['plataforma'] as String,
      fechaInicio: DateTime.parse(json['fechaInicio'] as String),
      fechaPublicado: json['fechaPublicado'] != null
          ? Value(DateTime.parse(json['fechaPublicado'] as String))
          : const Value.absent(),
      clienteId: json['clienteId'] != null
          ? Value(json['clienteId'] as int)
          : const Value.absent(),
      nombreClienteManual: json['nombreClienteManual'] != null
          ? Value(json['nombreClienteManual'] as String)
          : const Value.absent(),
      notas: json['notas'] != null
          ? Value(json['notas'] as String)
          : const Value.absent(),
      precio: json['precio'] != null
          ? Value(json['precio'] as double)
          : const Value.absent(),
      completada: Value(json['completada'] as bool? ?? false),
      synced: Value(
        json['synced'] as bool? ?? true,
      ), // Vienen del servidor sincronizadas
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
      version: Value(json['version'] as int? ?? 1),
    );
  }

  Map<String, dynamic> _clienteToJson(Cliente c) {
    return {
      'id': c.id,
      'empresa': c.empresa,
      'nombreGerente': c.nombreGerente,
      'numeroContacto': c.numeroContacto,
      'servicio': c.servicio,
      'fechaRegistro': c.fechaRegistro.toIso8601String(),
      'fechaEntrega': c.fechaEntrega.toIso8601String(),
      'synced': c.synced,
      'updatedAt': c.updatedAt.toIso8601String(),
      'version': c.version,
    };
  }

  ClientesCompanion _jsonToClienteCompanion(Map<String, dynamic> json) {
    return ClientesCompanion.insert(
      id: json['id'] != null ? Value(json['id'] as int) : const Value.absent(),
      empresa: json['empresa'] as String,
      nombreGerente: json['nombreGerente'] as String,
      numeroContacto: json['numeroContacto'] as String,
      servicio: json['servicio'] as String,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
      fechaEntrega: DateTime.parse(json['fechaEntrega'] as String),
      synced: Value(json['synced'] as bool? ?? true),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
      version: Value(json['version'] as int? ?? 1),
    );
  }

  Map<String, dynamic> _servicioToJson(Servicio s) {
    return {
      'id': s.id,
      'nombre': s.nombre,
      'descripcion': s.descripcion,
      'precio': s.precio,
      'esServicio': s.esServicio,
      'synced': s.synced,
      'updatedAt': s.updatedAt.toIso8601String(),
      'version': s.version,
    };
  }

  ServiciosCompanion _jsonToServicioCompanion(Map<String, dynamic> json) {
    return ServiciosCompanion.insert(
      id: json['id'] != null ? Value(json['id'] as int) : const Value.absent(),
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: json['precio'] as double,
      esServicio: json['esServicio'] as bool,
      synced: Value(json['synced'] as bool? ?? true),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
      version: Value(json['version'] as int? ?? 1),
    );
  }
}
