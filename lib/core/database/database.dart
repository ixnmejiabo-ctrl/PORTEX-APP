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
}

// ============ TABLA DE SERVICIOS ============
class Servicios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100)();
  TextColumn get descripcion => text()();
  RealColumn get precio => real()();
  BoolColumn get esServicio => boolean()(); // true: servicio, false: paquete
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

// ============ DATABASE ============
@DriftDatabase(tables: [Clientes, Actividades, Servicios, ConfiguracionEmpresa])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

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
}

// ============ CONEXIÓN A BASE DE DATOS ============
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'portex.db'));
    return NativeDatabase(file);
  });
}
