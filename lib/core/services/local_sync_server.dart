import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import '../database/database.dart';

/// Servidor HTTP local para sincronización P2P
/// Solo se ejecuta en Windows Desktop
class LocalSyncServer {
  HttpServer? _server;
  final AppDatabase db;
  final String authToken;
  int _port;

  LocalSyncServer(this.db, {String? authToken, int port = 8080})
    : authToken =
          authToken ?? 'portex-sync-${DateTime.now().millisecondsSinceEpoch}',
      _port = port;

  /// Iniciar servidor HTTP
  Future<void> start({int? port}) async {
    if (port != null) _port = port;

    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(_corsHeaders())
        .addMiddleware(_authMiddleware())
        .addHandler(_router);

    _server = await shelf_io.serve(handler, '0.0.0.0', _port);
    debugPrint(
      '🚀 [SYNC SERVER] Corriendo en http://${_server!.address.host}:${_server!.port}',
    );
    debugPrint('🔑 [SYNC SERVER] Auth Token: $authToken');
  }

  /// Detener servidor HTTP
  Future<void> stop() async {
    await _server?.close();
    _server = null;
    debugPrint('⛔ [SYNC SERVER] Servidor detenido');
  }

  /// Estado del servidor
  bool get isRunning => _server != null;

  /// Obtener IP local
  String? get serverAddress => _server?.address.host;

  /// Router de endpoints
  Handler get _router {
    return (Request request) async {
      try {
        final path = request.url.path;
        final method = request.method;

        debugPrint('📥 [SYNC SERVER] $method /$path');

        // GET /ping - Verificar conexión
        if (path == 'ping') {
          return Response.ok(
            jsonEncode({
              'status': 'ok',
              'timestamp': DateTime.now().toIso8601String(),
              'server': 'PORTEX Sync Server',
            }),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // GET /info - Información del servidor
        if (path == 'info' && method == 'GET') {
          final config = await db.obtenerConfiguracionEmpresa();
          return Response.ok(
            jsonEncode({
              'empresa': config?.nombreEmpresa ?? 'PORTEX',
              'lastSync': (await db.getLastSyncTimestamp())?.toIso8601String(),
              'timestamp': DateTime.now().toIso8601String(),
            }),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // GET /actividades - Obtener tareas (con filtro opcional 'since')
        if (path == 'actividades' && method == 'GET') {
          final sinceParam = request.url.queryParameters['since'];
          final List<Actividade> actividades;

          if (sinceParam != null) {
            final since = DateTime.parse(sinceParam);
            actividades = await db.getActividadesSince(since);
          } else {
            actividades = await db.obtenerTodasLasActividades();
          }

          final actividadesJson = actividades
              .map((a) => _actividadToJson(a))
              .toList();

          return Response.ok(
            jsonEncode(actividadesJson),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // POST /actividades - Recibir tareas del móvil
        if (path == 'actividades' && method == 'POST') {
          final body = await request.readAsString();
          final List<dynamic> actividadesJson = jsonDecode(body);

          int inserted = 0;
          int updated = 0;

          for (final actividadJson in actividadesJson) {
            final companion = _jsonToActividadCompanion(actividadJson);
            await db.insertOrUpdateActividad(companion);

            if (companion.id.present) {
              updated++;
            } else {
              inserted++;
            }
          }

          return Response.ok(
            jsonEncode({
              'status': 'synced',
              'inserted': inserted,
              'updated': updated,
              'total': actividadesJson.length,
            }),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // GET /clientes - Obtener clientes
        if (path == 'clientes' && method == 'GET') {
          final sinceParam = request.url.queryParameters['since'];
          final List<Cliente> clientes;

          if (sinceParam != null) {
            final since = DateTime.parse(sinceParam);
            clientes = await db.getClientesSince(since);
          } else {
            clientes = await db.obtenerTodosLosClientes();
          }

          final clientesJson = clientes.map((c) => _clienteToJson(c)).toList();

          return Response.ok(
            jsonEncode(clientesJson),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // POST /clientes - Recibir clientes del móvil
        if (path == 'clientes' && method == 'POST') {
          final body = await request.readAsString();
          final List<dynamic> clientesJson = jsonDecode(body);

          int count = 0;
          for (final clienteJson in clientesJson) {
            final companion = _jsonToClienteCompanion(clienteJson);
            await db.insertOrUpdateCliente(companion);
            count++;
          }

          return Response.ok(
            jsonEncode({'status': 'synced', 'count': count}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // GET /servicios - Obtener servicios
        if (path == 'servicios' && method == 'GET') {
          final sinceParam = request.url.queryParameters['since'];
          final List<Servicio> servicios;

          if (sinceParam != null) {
            final since = DateTime.parse(sinceParam);
            servicios = await db.getServiciosSince(since);
          } else {
            servicios = await db.obtenerTodosLosServicios();
          }

          final serviciosJson = servicios
              .map((s) => _servicioToJson(s))
              .toList();

          return Response.ok(
            jsonEncode(serviciosJson),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // POST /servicios - Recibir servicios del móvil
        if (path == 'servicios' && method == 'POST') {
          final body = await request.readAsString();
          final List<dynamic> serviciosJson = jsonDecode(body);

          int count = 0;
          for (final servicioJson in serviciosJson) {
            final companion = _jsonToServicioCompanion(servicioJson);
            await db.insertOrUpdateServicio(companion);
            count++;
          }

          return Response.ok(
            jsonEncode({'status': 'synced', 'count': count}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        // Ruta no encontrada
        return Response.notFound(
          jsonEncode({'error': 'Ruta no encontrada: $path'}),
          headers: {'Content-Type': 'application/json'},
        );
      } catch (e, stack) {
        debugPrint('❌ [SYNC SERVER] Error: $e');
        debugPrint(stack.toString());
        return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  }

  /// Middleware de CORS
  Middleware _corsHeaders() {
    return (Handler handler) {
      return (Request request) async {
        final response = await handler(request);
        return response.change(
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers':
                'Origin, Content-Type, Authorization',
          },
        );
      };
    };
  }

  /// Middleware de autenticación
  Middleware _authMiddleware() {
    return (Handler handler) {
      return (Request request) async {
        // Permitir ping sin autenticación
        if (request.url.path == 'ping') {
          return handler(request);
        }

        final authHeader = request.headers['authorization'];

        if (authHeader == null || authHeader != 'Bearer $authToken') {
          return Response.forbidden(
            jsonEncode({'error': 'No autorizado'}),
            headers: {'Content-Type': 'application/json'},
          );
        }

        return handler(request);
      };
    };
  }

  // ===== CONVERSIÓN JSON =====

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
      synced: Value(json['synced'] as bool? ?? false),
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
      synced: Value(json['synced'] as bool? ?? false),
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
      synced: Value(json['synced'] as bool? ?? false),
      updatedAt: Value(DateTime.parse(json['updatedAt'] as String)),
      version: Value(json['version'] as int? ?? 1),
    );
  }
}
