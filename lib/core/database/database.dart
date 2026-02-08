import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'database.g.dart';

// ============ TABLA DE CLIENTES ============
class Clientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get empresa => text().withLength(min: 1, max: 200)();
  TextColumn get nombreGerente => text().withLength(min: 1, max: 100)();
  TextColumn get numeroContacto => text().withLength(min: 1, max: 50)();
  TextColumn get servicio => text()(); // Tipo de servicio contratado
  DateTimeColumn get fechaRegistro => dateTime()();
  DateTimeColumn get fechaEntrega => dateTime()(); // Fecha de fin del servicio

  // Campos de sincronización
  BoolColumn get synced => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
}

// ============ TABLA DE ACTIVIDADES/TAREAS ============
class Actividades extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombreActividad => text().withLength(min: 1, max: 200)();
  TextColumn get descripcion => text()();
  TextColumn get tipo => text()(); // video, imagen, campaña, post, etc.
  TextColumn get estado =>
      text()(); // pendiente, en proceso, listo, entregado, publicado, retrasado
  TextColumn get plataforma =>
      text()(); // TikTok, Facebook, Instagram, Google, etc.
  DateTimeColumn get fechaInicio => dateTime()();
  DateTimeColumn get fechaPublicado => dateTime().nullable()();
  IntColumn get clienteId => integer().nullable().references(Clientes, #id)();
  TextColumn get nombreClienteManual =>
      text().nullable()(); // Para clientes no registrados
  TextColumn get notas => text().nullable()();
  RealColumn get precio =>
      real().nullable()(); // Precio negociado o del servicio
  BoolColumn get completada => boolean().withDefault(const Constant(false))();

  // Campos de sincronización
  BoolColumn get synced => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
}

// ============ TABLA DE SERVICIOS ============
class Servicios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  TextColumn get descripcion => text()();
  RealColumn get precio => real()();
  BoolColumn get esServicio => boolean()(); // true: servicio, false: paquete

  // Campos de sincronización
  BoolColumn get synced => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get version => integer().withDefault(const Constant(1))();
}

// ============ TABLA DE CONFIGURACIÓN DE EMPRESA ============
class ConfiguracionEmpresa extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombreEmpresa => text().withLength(min: 1, max: 200)();
  TextColumn get responsable => text().withLength(min: 1, max: 100)();
  TextColumn get contacto => text().withLength(min: 1, max: 50)();
  TextColumn get direccion => text()();
  TextColumn get rutaLogo => text().nullable()();
}

// ============ TABLA DE METADATOS DE SINCRONIZACIÓN ============
@DataClassName('SyncMetadatum')
class SyncMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  TextColumn get deviceId => text()();
  TextColumn get deviceName => text()();
  TextColumn get serverIp => text().nullable()(); // IP del servidor conectado
}

// ============ DATABASE ============
@DriftDatabase(
  tables: [
    Clientes,
    Actividades,
    Servicios,
    ConfiguracionEmpresa,
    SyncMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3; // Incrementado para sincronización

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(actividades, actividades.precio);
        }
        if (from < 3) {
          // NOTA: SQLite no permite DEFAULT con CURRENT_TIMESTAMP en ALTER TABLE
          // Solución: Agregar columnas manualmente con valor estático
          // Helper para verificar si una columna existe
          Future<bool> columnExists(String table, String column) async {
            final result = await customSelect(
              'PRAGMA table_info($table)',
              readsFrom: {},
            ).get();
            return result.any((row) => row.data['name'] == column);
          }

          final timestamp = DateTime.now().millisecondsSinceEpoch;

          // Clientes - verificar existencia antes de agregar
          if (!await columnExists('clientes', 'synced')) {
            await customStatement(
              'ALTER TABLE clientes ADD COLUMN synced INTEGER NOT NULL DEFAULT 1',
            );
          }
          if (!await columnExists('clientes', 'updated_at')) {
            await customStatement(
              'ALTER TABLE clientes ADD COLUMN updated_at INTEGER NOT NULL DEFAULT $timestamp',
            );
          }
          if (!await columnExists('clientes', 'version')) {
            await customStatement(
              'ALTER TABLE clientes ADD COLUMN version INTEGER NOT NULL DEFAULT 1',
            );
          }

          // Actividades - verificar existencia antes de agregar
          if (!await columnExists('actividades', 'synced')) {
            await customStatement(
              'ALTER TABLE actividades ADD COLUMN synced INTEGER NOT NULL DEFAULT 1',
            );
          }
          if (!await columnExists('actividades', 'updated_at')) {
            await customStatement(
              'ALTER TABLE actividades ADD COLUMN updated_at INTEGER NOT NULL DEFAULT $timestamp',
            );
          }
          if (!await columnExists('actividades', 'version')) {
            await customStatement(
              'ALTER TABLE actividades ADD COLUMN version INTEGER NOT NULL DEFAULT 1',
            );
          }

          // Servicios - verificar existencia antes de agregar
          if (!await columnExists('servicios', 'synced')) {
            await customStatement(
              'ALTER TABLE servicios ADD COLUMN synced INTEGER NOT NULL DEFAULT 1',
            );
          }
          if (!await columnExists('servicios', 'updated_at')) {
            await customStatement(
              'ALTER TABLE servicios ADD COLUMN updated_at INTEGER NOT NULL DEFAULT $timestamp',
            );
          }
          if (!await columnExists('servicios', 'version')) {
            await customStatement(
              'ALTER TABLE servicios ADD COLUMN version INTEGER NOT NULL DEFAULT 1',
            );
          }

          // Crear tabla de metadatos de sincronización si no existe
          // (createTable maneja esto internamente)
          await m.createTable(syncMetadata);
        }
      },
    );
  }

  // ===== QUERIES PARA CLIENTES =====

  Future<List<Cliente>> obtenerTodosLosClientes() => select(clientes).get();

  Future<Cliente> obtenerClientePorId(int id) =>
      (select(clientes)..where((c) => c.id.equals(id))).getSingle();

  Future<int> insertarCliente(ClientesCompanion cliente) =>
      into(clientes).insert(cliente);

  Future<bool> actualizarCliente(Cliente cliente) =>
      update(clientes).replace(cliente);

  Future<int> eliminarCliente(int id) =>
      (delete(clientes)..where((c) => c.id.equals(id))).go();

  Stream<List<Cliente>> watchClientes() => select(clientes).watch();

  // ===== QUERIES PARA ACTIVIDADES =====

  Future<List<Actividade>> obtenerTodasLasActividades() =>
      select(actividades).get();

  Future<List<Actividade>> obtenerActividadesNoCompletadas() =>
      (select(actividades)..where((a) => a.completada.equals(false))).get();

  Future<List<Actividade>> obtenerActividadesCompletadas() =>
      (select(actividades)..where((a) => a.completada.equals(true))).get();

  Future<List<Actividade>> obtenerActividadesPorCliente(int clienteId) =>
      (select(actividades)..where((a) => a.clienteId.equals(clienteId))).get();

  Future<List<Actividade>> obtenerActividadesPorRangoFechas(
    DateTime inicio,
    DateTime fin,
  ) =>
      (select(actividades)
            ..where((a) => a.fechaInicio.isBiggerOrEqualValue(inicio))
            ..where((a) => a.fechaInicio.isSmallerOrEqualValue(fin)))
          .get();

  Future<int> insertarActividad(ActividadesCompanion actividad) =>
      into(actividades).insert(actividad);

  Future<bool> actualizarActividad(Actividade actividad) =>
      update(actividades).replace(actividad);

  Future<int> eliminarActividad(int id) =>
      (delete(actividades)..where((a) => a.id.equals(id))).go();

  Stream<List<Actividade>> watchActividadesNoCompletadas() =>
      (select(actividades)..where((a) => a.completada.equals(false))).watch();

  // ===== QUERIES PARA SERVICIOS =====

  Future<List<Servicio>> obtenerTodosLosServicios() => select(servicios).get();

  Future<List<Servicio>> obtenerServicios() =>
      (select(servicios)..where((s) => s.esServicio.equals(true))).get();

  Future<List<Servicio>> obtenerPaquetes() =>
      (select(servicios)..where((s) => s.esServicio.equals(false))).get();

  Future<int> insertarServicio(ServiciosCompanion servicio) =>
      into(servicios).insert(servicio);

  Future<bool> actualizarServicio(Servicio servicio) =>
      update(servicios).replace(servicio);

  Future<int> eliminarServicio(int id) =>
      (delete(servicios)..where((s) => s.id.equals(id))).go();

  Stream<List<Servicio>> watchServicios() => select(servicios).watch();

  // ===== QUERIES PARA CONFIGURACIÓN DE EMPRESA =====

  Future<ConfiguracionEmpresaData?> obtenerConfiguracionEmpresa() async {
    final result = await select(configuracionEmpresa).get();
    return result.isEmpty ? null : result.first;
  }

  Future<int> insertarConfiguracionEmpresa(
    ConfiguracionEmpresaCompanion config,
  ) => into(configuracionEmpresa).insert(config);

  Future<bool> actualizarConfiguracionEmpresa(
    ConfiguracionEmpresaData config,
  ) => update(configuracionEmpresa).replace(config);

  Stream<ConfiguracionEmpresaData?> watchConfiguracionEmpresa() =>
      select(configuracionEmpresa).watchSingleOrNull();

  // ===== QUERIES PARA SINCRONIZACIÓN =====

  // --- ACTIVIDADES ---
  Future<List<Actividade>> getActividadesNotSynced() =>
      (select(actividades)..where((a) => a.synced.equals(false))).get();

  Future<List<Actividade>> getActividadesSince(DateTime since) => (select(
    actividades,
  )..where((a) => a.updatedAt.isBiggerThanValue(since))).get();

  Future<void> markActividadAsSynced(int id) async {
    final actividad = await (select(
      actividades,
    )..where((a) => a.id.equals(id))).getSingle();
    await update(actividades).replace(actividad.copyWith(synced: true));
  }

  Future<void> markAllActividadesSynced(List<int> ids) async {
    await (update(actividades)..where((a) => a.id.isIn(ids))).write(
      const ActividadesCompanion(synced: Value(true)),
    );
  }

  // Insert o update con manejo de conflictos
  Future<int> insertOrUpdateActividad(ActividadesCompanion companion) async {
    // Si tiene ID, intentar actualizar
    if (companion.id.present) {
      final existing = await (select(
        actividades,
      )..where((a) => a.id.equals(companion.id.value))).getSingleOrNull();

      if (existing != null) {
        // Comparar versiones/timestamps para resolver conflictos
        final incomingVersion = companion.version.value;
        final incomingUpdatedAt = companion.updatedAt.value;

        if (incomingVersion > existing.version ||
            (incomingVersion == existing.version &&
                incomingUpdatedAt.isAfter(existing.updatedAt))) {
          // Incoming es más reciente
          final updated = existing.copyWith(
            nombreActividad: companion.nombreActividad.value,
            descripcion: companion.descripcion.value,
            tipo: companion.tipo.value,
            estado: companion.estado.value,
            plataforma: companion.plataforma.value,
            fechaInicio: companion.fechaInicio.value,
            fechaPublicado: companion.fechaPublicado,
            nombreClienteManual: companion.nombreClienteManual,
            notas: companion.notas,
            precio: companion.precio,
            completada: companion.completada.value,
            synced: companion.synced.value,
            updatedAt: companion.updatedAt.value,
            version: companion.version.value,
          );
          await update(actividades).replace(updated);
          return existing.id;
        } else {
          // Local es más reciente o igual, no actualizar
          return existing.id;
        }
      }
    }

    // Si no existe, insertar
    return await into(actividades).insert(companion);
  }

  // --- CLIENTES ---
  Future<List<Cliente>> getClientesNotSynced() =>
      (select(clientes)..where((c) => c.synced.equals(false))).get();

  Future<List<Cliente>> getClientesSince(DateTime since) => (select(
    clientes,
  )..where((c) => c.updatedAt.isBiggerThanValue(since))).get();

  Future<void> markAllClientesSynced(List<int> ids) async {
    await (update(clientes)..where((c) => c.id.isIn(ids))).write(
      const ClientesCompanion(synced: Value(true)),
    );
  }

  Future<int> insertOrUpdateCliente(ClientesCompanion companion) async {
    if (companion.id.present) {
      final existing = await (select(
        clientes,
      )..where((c) => c.id.equals(companion.id.value))).getSingleOrNull();

      if (existing != null) {
        final incomingVersion = companion.version.value;
        final incomingUpdatedAt = companion.updatedAt.value;

        if (incomingVersion > existing.version ||
            (incomingVersion == existing.version &&
                incomingUpdatedAt.isAfter(existing.updatedAt))) {
          final updated = existing.copyWith(
            empresa: companion.empresa.value,
            nombreGerente: companion.nombreGerente.value,
            numeroContacto: companion.numeroContacto.value,
            servicio: companion.servicio.value,
            fechaRegistro: companion.fechaRegistro.value,
            fechaEntrega: companion.fechaEntrega.value,
            synced: companion.synced.value,
            updatedAt: companion.updatedAt.value,
            version: companion.version.value,
          );
          await update(clientes).replace(updated);
          return existing.id;
        } else {
          return existing.id;
        }
      }
    }

    return await into(clientes).insert(companion);
  }

  // --- SERVICIOS ---
  Future<List<Servicio>> getServiciosNotSynced() =>
      (select(servicios)..where((s) => s.synced.equals(false))).get();

  Future<List<Servicio>> getServiciosSince(DateTime since) => (select(
    servicios,
  )..where((s) => s.updatedAt.isBiggerThanValue(since))).get();

  Future<void> markAllServiciosSynced(List<int> ids) async {
    await (update(servicios)..where((s) => s.id.isIn(ids))).write(
      const ServiciosCompanion(synced: Value(true)),
    );
  }

  Future<int> insertOrUpdateServicio(ServiciosCompanion companion) async {
    if (companion.id.present) {
      final existing = await (select(
        servicios,
      )..where((s) => s.id.equals(companion.id.value))).getSingleOrNull();

      if (existing != null) {
        final incomingVersion = companion.version.value;
        final incomingUpdatedAt = companion.updatedAt.value;

        if (incomingVersion > existing.version ||
            (incomingVersion == existing.version &&
                incomingUpdatedAt.isAfter(existing.updatedAt))) {
          final updated = existing.copyWith(
            nombre: companion.nombre.value,
            descripcion: companion.descripcion.value,
            precio: companion.precio.value,
            esServicio: companion.esServicio.value,
            synced: companion.synced.value,
            updatedAt: companion.updatedAt.value,
            version: companion.version.value,
          );
          await update(servicios).replace(updated);
          return existing.id;
        } else {
          return existing.id;
        }
      }
    }

    return await into(servicios).insert(companion);
  }

  // --- METADATOS DE SINCRONIZACIÓN ---
  Future<SyncMetadatum?> getSyncMetadata() async {
    final result = await select(syncMetadata).get();
    return result.isEmpty ? null : result.first;
  }

  Future<DateTime?> getLastSyncTimestamp() async {
    final metadata = await getSyncMetadata();
    return metadata?.lastSyncAt;
  }

  Future<void> updateLastSyncTimestamp(DateTime timestamp) async {
    final existing = await getSyncMetadata();

    if (existing != null) {
      await update(
        syncMetadata,
      ).replace(existing.copyWith(lastSyncAt: Value(timestamp)));
    } else {
      // Crear por primera vez
      await into(syncMetadata).insert(
        SyncMetadataCompanion.insert(
          deviceId: 'device-${DateTime.now().millisecondsSinceEpoch}',
          deviceName: 'PORTEX App',
          lastSyncAt: Value(timestamp),
        ),
      );
    }
  }

  Future<void> updateServerIp(String? ip) async {
    final existing = await getSyncMetadata();

    if (existing != null) {
      await update(
        syncMetadata,
      ).replace(existing.copyWith(serverIp: Value(ip)));
    } else {
      await into(syncMetadata).insert(
        SyncMetadataCompanion.insert(
          deviceId: 'device-${DateTime.now().millisecondsSinceEpoch}',
          deviceName: 'PORTEX App',
          serverIp: Value(ip),
        ),
      );
    }
  }

  // Obtener conteo de registros pendientes de sincronizar
  Future<int> getUnsyncedCount() async {
    final actividadesCount =
        await (selectOnly(actividades)
              ..addColumns([actividades.id.count()])
              ..where(actividades.synced.equals(false)))
            .getSingle();

    final clientesCount =
        await (selectOnly(clientes)
              ..addColumns([clientes.id.count()])
              ..where(clientes.synced.equals(false)))
            .getSingle();

    final serviciosCount =
        await (selectOnly(servicios)
              ..addColumns([servicios.id.count()])
              ..where(servicios.synced.equals(false)))
            .getSingle();

    return ((actividadesCount.read(actividades.id.count()) ?? 0) +
            (clientesCount.read(clientes.id.count()) ?? 0) +
            (serviciosCount.read(servicios.id.count()) ?? 0))
        .toInt();
  }
}

// ============ CONEXIÓN A BASE DE DATOS ============
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'portex.db'));
    return NativeDatabase(file);
  });
}
