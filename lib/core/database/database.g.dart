// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _empresaMeta = const VerificationMeta(
    'empresa',
  );
  @override
  late final GeneratedColumn<String> empresa = GeneratedColumn<String>(
    'empresa',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreGerenteMeta = const VerificationMeta(
    'nombreGerente',
  );
  @override
  late final GeneratedColumn<String> nombreGerente = GeneratedColumn<String>(
    'nombre_gerente',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroContactoMeta = const VerificationMeta(
    'numeroContacto',
  );
  @override
  late final GeneratedColumn<String> numeroContacto = GeneratedColumn<String>(
    'numero_contacto',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servicioMeta = const VerificationMeta(
    'servicio',
  );
  @override
  late final GeneratedColumn<String> servicio = GeneratedColumn<String>(
    'servicio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaRegistroMeta = const VerificationMeta(
    'fechaRegistro',
  );
  @override
  late final GeneratedColumn<DateTime> fechaRegistro =
      GeneratedColumn<DateTime>(
        'fecha_registro',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _fechaEntregaMeta = const VerificationMeta(
    'fechaEntrega',
  );
  @override
  late final GeneratedColumn<DateTime> fechaEntrega = GeneratedColumn<DateTime>(
    'fecha_entrega',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    empresa,
    nombreGerente,
    numeroContacto,
    servicio,
    fechaRegistro,
    fechaEntrega,
    synced,
    updatedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('empresa')) {
      context.handle(
        _empresaMeta,
        empresa.isAcceptableOrUnknown(data['empresa']!, _empresaMeta),
      );
    } else if (isInserting) {
      context.missing(_empresaMeta);
    }
    if (data.containsKey('nombre_gerente')) {
      context.handle(
        _nombreGerenteMeta,
        nombreGerente.isAcceptableOrUnknown(
          data['nombre_gerente']!,
          _nombreGerenteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreGerenteMeta);
    }
    if (data.containsKey('numero_contacto')) {
      context.handle(
        _numeroContactoMeta,
        numeroContacto.isAcceptableOrUnknown(
          data['numero_contacto']!,
          _numeroContactoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroContactoMeta);
    }
    if (data.containsKey('servicio')) {
      context.handle(
        _servicioMeta,
        servicio.isAcceptableOrUnknown(data['servicio']!, _servicioMeta),
      );
    } else if (isInserting) {
      context.missing(_servicioMeta);
    }
    if (data.containsKey('fecha_registro')) {
      context.handle(
        _fechaRegistroMeta,
        fechaRegistro.isAcceptableOrUnknown(
          data['fecha_registro']!,
          _fechaRegistroMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaRegistroMeta);
    }
    if (data.containsKey('fecha_entrega')) {
      context.handle(
        _fechaEntregaMeta,
        fechaEntrega.isAcceptableOrUnknown(
          data['fecha_entrega']!,
          _fechaEntregaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaEntregaMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      empresa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa'],
      )!,
      nombreGerente: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_gerente'],
      )!,
      numeroContacto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_contacto'],
      )!,
      servicio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}servicio'],
      )!,
      fechaRegistro: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_registro'],
      )!,
      fechaEntrega: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_entrega'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final int id;
  final String empresa;
  final String nombreGerente;
  final String numeroContacto;
  final String servicio;
  final DateTime fechaRegistro;
  final DateTime fechaEntrega;
  final bool synced;
  final DateTime updatedAt;
  final int version;
  const Cliente({
    required this.id,
    required this.empresa,
    required this.nombreGerente,
    required this.numeroContacto,
    required this.servicio,
    required this.fechaRegistro,
    required this.fechaEntrega,
    required this.synced,
    required this.updatedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['empresa'] = Variable<String>(empresa);
    map['nombre_gerente'] = Variable<String>(nombreGerente);
    map['numero_contacto'] = Variable<String>(numeroContacto);
    map['servicio'] = Variable<String>(servicio);
    map['fecha_registro'] = Variable<DateTime>(fechaRegistro);
    map['fecha_entrega'] = Variable<DateTime>(fechaEntrega);
    map['synced'] = Variable<bool>(synced);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      empresa: Value(empresa),
      nombreGerente: Value(nombreGerente),
      numeroContacto: Value(numeroContacto),
      servicio: Value(servicio),
      fechaRegistro: Value(fechaRegistro),
      fechaEntrega: Value(fechaEntrega),
      synced: Value(synced),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<int>(json['id']),
      empresa: serializer.fromJson<String>(json['empresa']),
      nombreGerente: serializer.fromJson<String>(json['nombreGerente']),
      numeroContacto: serializer.fromJson<String>(json['numeroContacto']),
      servicio: serializer.fromJson<String>(json['servicio']),
      fechaRegistro: serializer.fromJson<DateTime>(json['fechaRegistro']),
      fechaEntrega: serializer.fromJson<DateTime>(json['fechaEntrega']),
      synced: serializer.fromJson<bool>(json['synced']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'empresa': serializer.toJson<String>(empresa),
      'nombreGerente': serializer.toJson<String>(nombreGerente),
      'numeroContacto': serializer.toJson<String>(numeroContacto),
      'servicio': serializer.toJson<String>(servicio),
      'fechaRegistro': serializer.toJson<DateTime>(fechaRegistro),
      'fechaEntrega': serializer.toJson<DateTime>(fechaEntrega),
      'synced': serializer.toJson<bool>(synced),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  Cliente copyWith({
    int? id,
    String? empresa,
    String? nombreGerente,
    String? numeroContacto,
    String? servicio,
    DateTime? fechaRegistro,
    DateTime? fechaEntrega,
    bool? synced,
    DateTime? updatedAt,
    int? version,
  }) => Cliente(
    id: id ?? this.id,
    empresa: empresa ?? this.empresa,
    nombreGerente: nombreGerente ?? this.nombreGerente,
    numeroContacto: numeroContacto ?? this.numeroContacto,
    servicio: servicio ?? this.servicio,
    fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    fechaEntrega: fechaEntrega ?? this.fechaEntrega,
    synced: synced ?? this.synced,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      empresa: data.empresa.present ? data.empresa.value : this.empresa,
      nombreGerente: data.nombreGerente.present
          ? data.nombreGerente.value
          : this.nombreGerente,
      numeroContacto: data.numeroContacto.present
          ? data.numeroContacto.value
          : this.numeroContacto,
      servicio: data.servicio.present ? data.servicio.value : this.servicio,
      fechaRegistro: data.fechaRegistro.present
          ? data.fechaRegistro.value
          : this.fechaRegistro,
      fechaEntrega: data.fechaEntrega.present
          ? data.fechaEntrega.value
          : this.fechaEntrega,
      synced: data.synced.present ? data.synced.value : this.synced,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('empresa: $empresa, ')
          ..write('nombreGerente: $nombreGerente, ')
          ..write('numeroContacto: $numeroContacto, ')
          ..write('servicio: $servicio, ')
          ..write('fechaRegistro: $fechaRegistro, ')
          ..write('fechaEntrega: $fechaEntrega, ')
          ..write('synced: $synced, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    empresa,
    nombreGerente,
    numeroContacto,
    servicio,
    fechaRegistro,
    fechaEntrega,
    synced,
    updatedAt,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.empresa == this.empresa &&
          other.nombreGerente == this.nombreGerente &&
          other.numeroContacto == this.numeroContacto &&
          other.servicio == this.servicio &&
          other.fechaRegistro == this.fechaRegistro &&
          other.fechaEntrega == this.fechaEntrega &&
          other.synced == this.synced &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<int> id;
  final Value<String> empresa;
  final Value<String> nombreGerente;
  final Value<String> numeroContacto;
  final Value<String> servicio;
  final Value<DateTime> fechaRegistro;
  final Value<DateTime> fechaEntrega;
  final Value<bool> synced;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.empresa = const Value.absent(),
    this.nombreGerente = const Value.absent(),
    this.numeroContacto = const Value.absent(),
    this.servicio = const Value.absent(),
    this.fechaRegistro = const Value.absent(),
    this.fechaEntrega = const Value.absent(),
    this.synced = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
  });
  ClientesCompanion.insert({
    this.id = const Value.absent(),
    required String empresa,
    required String nombreGerente,
    required String numeroContacto,
    required String servicio,
    required DateTime fechaRegistro,
    required DateTime fechaEntrega,
    this.synced = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
  }) : empresa = Value(empresa),
       nombreGerente = Value(nombreGerente),
       numeroContacto = Value(numeroContacto),
       servicio = Value(servicio),
       fechaRegistro = Value(fechaRegistro),
       fechaEntrega = Value(fechaEntrega);
  static Insertable<Cliente> custom({
    Expression<int>? id,
    Expression<String>? empresa,
    Expression<String>? nombreGerente,
    Expression<String>? numeroContacto,
    Expression<String>? servicio,
    Expression<DateTime>? fechaRegistro,
    Expression<DateTime>? fechaEntrega,
    Expression<bool>? synced,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (empresa != null) 'empresa': empresa,
      if (nombreGerente != null) 'nombre_gerente': nombreGerente,
      if (numeroContacto != null) 'numero_contacto': numeroContacto,
      if (servicio != null) 'servicio': servicio,
      if (fechaRegistro != null) 'fecha_registro': fechaRegistro,
      if (fechaEntrega != null) 'fecha_entrega': fechaEntrega,
      if (synced != null) 'synced': synced,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
    });
  }

  ClientesCompanion copyWith({
    Value<int>? id,
    Value<String>? empresa,
    Value<String>? nombreGerente,
    Value<String>? numeroContacto,
    Value<String>? servicio,
    Value<DateTime>? fechaRegistro,
    Value<DateTime>? fechaEntrega,
    Value<bool>? synced,
    Value<DateTime>? updatedAt,
    Value<int>? version,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      empresa: empresa ?? this.empresa,
      nombreGerente: nombreGerente ?? this.nombreGerente,
      numeroContacto: numeroContacto ?? this.numeroContacto,
      servicio: servicio ?? this.servicio,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      synced: synced ?? this.synced,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (empresa.present) {
      map['empresa'] = Variable<String>(empresa.value);
    }
    if (nombreGerente.present) {
      map['nombre_gerente'] = Variable<String>(nombreGerente.value);
    }
    if (numeroContacto.present) {
      map['numero_contacto'] = Variable<String>(numeroContacto.value);
    }
    if (servicio.present) {
      map['servicio'] = Variable<String>(servicio.value);
    }
    if (fechaRegistro.present) {
      map['fecha_registro'] = Variable<DateTime>(fechaRegistro.value);
    }
    if (fechaEntrega.present) {
      map['fecha_entrega'] = Variable<DateTime>(fechaEntrega.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('empresa: $empresa, ')
          ..write('nombreGerente: $nombreGerente, ')
          ..write('numeroContacto: $numeroContacto, ')
          ..write('servicio: $servicio, ')
          ..write('fechaRegistro: $fechaRegistro, ')
          ..write('fechaEntrega: $fechaEntrega, ')
          ..write('synced: $synced, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }
}

class $ActividadesTable extends Actividades
    with TableInfo<$ActividadesTable, Actividade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActividadesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreActividadMeta = const VerificationMeta(
    'nombreActividad',
  );
  @override
  late final GeneratedColumn<String> nombreActividad = GeneratedColumn<String>(
    'nombre_actividad',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plataformaMeta = const VerificationMeta(
    'plataforma',
  );
  @override
  late final GeneratedColumn<String> plataforma = GeneratedColumn<String>(
    'plataforma',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
    'fecha_inicio',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaPublicadoMeta = const VerificationMeta(
    'fechaPublicado',
  );
  @override
  late final GeneratedColumn<DateTime> fechaPublicado =
      GeneratedColumn<DateTime>(
        'fecha_publicado',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clientes (id)',
    ),
  );
  static const VerificationMeta _nombreClienteManualMeta =
      const VerificationMeta('nombreClienteManual');
  @override
  late final GeneratedColumn<String> nombreClienteManual =
      GeneratedColumn<String>(
        'nombre_cliente_manual',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
    'precio',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completadaMeta = const VerificationMeta(
    'completada',
  );
  @override
  late final GeneratedColumn<bool> completada = GeneratedColumn<bool>(
    'completada',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completada" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombreActividad,
    descripcion,
    tipo,
    estado,
    plataforma,
    fechaInicio,
    fechaPublicado,
    clienteId,
    nombreClienteManual,
    notas,
    precio,
    completada,
    synced,
    updatedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'actividades';
  @override
  VerificationContext validateIntegrity(
    Insertable<Actividade> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre_actividad')) {
      context.handle(
        _nombreActividadMeta,
        nombreActividad.isAcceptableOrUnknown(
          data['nombre_actividad']!,
          _nombreActividadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreActividadMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('plataforma')) {
      context.handle(
        _plataformaMeta,
        plataforma.isAcceptableOrUnknown(data['plataforma']!, _plataformaMeta),
      );
    } else if (isInserting) {
      context.missing(_plataformaMeta);
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('fecha_publicado')) {
      context.handle(
        _fechaPublicadoMeta,
        fechaPublicado.isAcceptableOrUnknown(
          data['fecha_publicado']!,
          _fechaPublicadoMeta,
        ),
      );
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    }
    if (data.containsKey('nombre_cliente_manual')) {
      context.handle(
        _nombreClienteManualMeta,
        nombreClienteManual.isAcceptableOrUnknown(
          data['nombre_cliente_manual']!,
          _nombreClienteManualMeta,
        ),
      );
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    if (data.containsKey('precio')) {
      context.handle(
        _precioMeta,
        precio.isAcceptableOrUnknown(data['precio']!, _precioMeta),
      );
    }
    if (data.containsKey('completada')) {
      context.handle(
        _completadaMeta,
        completada.isAcceptableOrUnknown(data['completada']!, _completadaMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Actividade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Actividade(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombreActividad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_actividad'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      plataforma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plataforma'],
      )!,
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio'],
      )!,
      fechaPublicado: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_publicado'],
      ),
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      ),
      nombreClienteManual: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_cliente_manual'],
      ),
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
      precio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio'],
      ),
      completada: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completada'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $ActividadesTable createAlias(String alias) {
    return $ActividadesTable(attachedDatabase, alias);
  }
}

class Actividade extends DataClass implements Insertable<Actividade> {
  final int id;
  final String nombreActividad;
  final String descripcion;
  final String tipo;
  final String estado;
  final String plataforma;
  final DateTime fechaInicio;
  final DateTime? fechaPublicado;
  final int? clienteId;
  final String? nombreClienteManual;
  final String? notas;
  final double? precio;
  final bool completada;
  final bool synced;
  final DateTime updatedAt;
  final int version;
  const Actividade({
    required this.id,
    required this.nombreActividad,
    required this.descripcion,
    required this.tipo,
    required this.estado,
    required this.plataforma,
    required this.fechaInicio,
    this.fechaPublicado,
    this.clienteId,
    this.nombreClienteManual,
    this.notas,
    this.precio,
    required this.completada,
    required this.synced,
    required this.updatedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre_actividad'] = Variable<String>(nombreActividad);
    map['descripcion'] = Variable<String>(descripcion);
    map['tipo'] = Variable<String>(tipo);
    map['estado'] = Variable<String>(estado);
    map['plataforma'] = Variable<String>(plataforma);
    map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    if (!nullToAbsent || fechaPublicado != null) {
      map['fecha_publicado'] = Variable<DateTime>(fechaPublicado);
    }
    if (!nullToAbsent || clienteId != null) {
      map['cliente_id'] = Variable<int>(clienteId);
    }
    if (!nullToAbsent || nombreClienteManual != null) {
      map['nombre_cliente_manual'] = Variable<String>(nombreClienteManual);
    }
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    if (!nullToAbsent || precio != null) {
      map['precio'] = Variable<double>(precio);
    }
    map['completada'] = Variable<bool>(completada);
    map['synced'] = Variable<bool>(synced);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  ActividadesCompanion toCompanion(bool nullToAbsent) {
    return ActividadesCompanion(
      id: Value(id),
      nombreActividad: Value(nombreActividad),
      descripcion: Value(descripcion),
      tipo: Value(tipo),
      estado: Value(estado),
      plataforma: Value(plataforma),
      fechaInicio: Value(fechaInicio),
      fechaPublicado: fechaPublicado == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaPublicado),
      clienteId: clienteId == null && nullToAbsent
          ? const Value.absent()
          : Value(clienteId),
      nombreClienteManual: nombreClienteManual == null && nullToAbsent
          ? const Value.absent()
          : Value(nombreClienteManual),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
      precio: precio == null && nullToAbsent
          ? const Value.absent()
          : Value(precio),
      completada: Value(completada),
      synced: Value(synced),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory Actividade.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Actividade(
      id: serializer.fromJson<int>(json['id']),
      nombreActividad: serializer.fromJson<String>(json['nombreActividad']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      tipo: serializer.fromJson<String>(json['tipo']),
      estado: serializer.fromJson<String>(json['estado']),
      plataforma: serializer.fromJson<String>(json['plataforma']),
      fechaInicio: serializer.fromJson<DateTime>(json['fechaInicio']),
      fechaPublicado: serializer.fromJson<DateTime?>(json['fechaPublicado']),
      clienteId: serializer.fromJson<int?>(json['clienteId']),
      nombreClienteManual: serializer.fromJson<String?>(
        json['nombreClienteManual'],
      ),
      notas: serializer.fromJson<String?>(json['notas']),
      precio: serializer.fromJson<double?>(json['precio']),
      completada: serializer.fromJson<bool>(json['completada']),
      synced: serializer.fromJson<bool>(json['synced']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombreActividad': serializer.toJson<String>(nombreActividad),
      'descripcion': serializer.toJson<String>(descripcion),
      'tipo': serializer.toJson<String>(tipo),
      'estado': serializer.toJson<String>(estado),
      'plataforma': serializer.toJson<String>(plataforma),
      'fechaInicio': serializer.toJson<DateTime>(fechaInicio),
      'fechaPublicado': serializer.toJson<DateTime?>(fechaPublicado),
      'clienteId': serializer.toJson<int?>(clienteId),
      'nombreClienteManual': serializer.toJson<String?>(nombreClienteManual),
      'notas': serializer.toJson<String?>(notas),
      'precio': serializer.toJson<double?>(precio),
      'completada': serializer.toJson<bool>(completada),
      'synced': serializer.toJson<bool>(synced),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  Actividade copyWith({
    int? id,
    String? nombreActividad,
    String? descripcion,
    String? tipo,
    String? estado,
    String? plataforma,
    DateTime? fechaInicio,
    Value<DateTime?> fechaPublicado = const Value.absent(),
    Value<int?> clienteId = const Value.absent(),
    Value<String?> nombreClienteManual = const Value.absent(),
    Value<String?> notas = const Value.absent(),
    Value<double?> precio = const Value.absent(),
    bool? completada,
    bool? synced,
    DateTime? updatedAt,
    int? version,
  }) => Actividade(
    id: id ?? this.id,
    nombreActividad: nombreActividad ?? this.nombreActividad,
    descripcion: descripcion ?? this.descripcion,
    tipo: tipo ?? this.tipo,
    estado: estado ?? this.estado,
    plataforma: plataforma ?? this.plataforma,
    fechaInicio: fechaInicio ?? this.fechaInicio,
    fechaPublicado: fechaPublicado.present
        ? fechaPublicado.value
        : this.fechaPublicado,
    clienteId: clienteId.present ? clienteId.value : this.clienteId,
    nombreClienteManual: nombreClienteManual.present
        ? nombreClienteManual.value
        : this.nombreClienteManual,
    notas: notas.present ? notas.value : this.notas,
    precio: precio.present ? precio.value : this.precio,
    completada: completada ?? this.completada,
    synced: synced ?? this.synced,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
  );
  Actividade copyWithCompanion(ActividadesCompanion data) {
    return Actividade(
      id: data.id.present ? data.id.value : this.id,
      nombreActividad: data.nombreActividad.present
          ? data.nombreActividad.value
          : this.nombreActividad,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      estado: data.estado.present ? data.estado.value : this.estado,
      plataforma: data.plataforma.present
          ? data.plataforma.value
          : this.plataforma,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      fechaPublicado: data.fechaPublicado.present
          ? data.fechaPublicado.value
          : this.fechaPublicado,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      nombreClienteManual: data.nombreClienteManual.present
          ? data.nombreClienteManual.value
          : this.nombreClienteManual,
      notas: data.notas.present ? data.notas.value : this.notas,
      precio: data.precio.present ? data.precio.value : this.precio,
      completada: data.completada.present
          ? data.completada.value
          : this.completada,
      synced: data.synced.present ? data.synced.value : this.synced,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Actividade(')
          ..write('id: $id, ')
          ..write('nombreActividad: $nombreActividad, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipo: $tipo, ')
          ..write('estado: $estado, ')
          ..write('plataforma: $plataforma, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaPublicado: $fechaPublicado, ')
          ..write('clienteId: $clienteId, ')
          ..write('nombreClienteManual: $nombreClienteManual, ')
          ..write('notas: $notas, ')
          ..write('precio: $precio, ')
          ..write('completada: $completada, ')
          ..write('synced: $synced, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombreActividad,
    descripcion,
    tipo,
    estado,
    plataforma,
    fechaInicio,
    fechaPublicado,
    clienteId,
    nombreClienteManual,
    notas,
    precio,
    completada,
    synced,
    updatedAt,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Actividade &&
          other.id == this.id &&
          other.nombreActividad == this.nombreActividad &&
          other.descripcion == this.descripcion &&
          other.tipo == this.tipo &&
          other.estado == this.estado &&
          other.plataforma == this.plataforma &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaPublicado == this.fechaPublicado &&
          other.clienteId == this.clienteId &&
          other.nombreClienteManual == this.nombreClienteManual &&
          other.notas == this.notas &&
          other.precio == this.precio &&
          other.completada == this.completada &&
          other.synced == this.synced &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class ActividadesCompanion extends UpdateCompanion<Actividade> {
  final Value<int> id;
  final Value<String> nombreActividad;
  final Value<String> descripcion;
  final Value<String> tipo;
  final Value<String> estado;
  final Value<String> plataforma;
  final Value<DateTime> fechaInicio;
  final Value<DateTime?> fechaPublicado;
  final Value<int?> clienteId;
  final Value<String?> nombreClienteManual;
  final Value<String?> notas;
  final Value<double?> precio;
  final Value<bool> completada;
  final Value<bool> synced;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  const ActividadesCompanion({
    this.id = const Value.absent(),
    this.nombreActividad = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.tipo = const Value.absent(),
    this.estado = const Value.absent(),
    this.plataforma = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaPublicado = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.nombreClienteManual = const Value.absent(),
    this.notas = const Value.absent(),
    this.precio = const Value.absent(),
    this.completada = const Value.absent(),
    this.synced = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
  });
  ActividadesCompanion.insert({
    this.id = const Value.absent(),
    required String nombreActividad,
    required String descripcion,
    required String tipo,
    required String estado,
    required String plataforma,
    required DateTime fechaInicio,
    this.fechaPublicado = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.nombreClienteManual = const Value.absent(),
    this.notas = const Value.absent(),
    this.precio = const Value.absent(),
    this.completada = const Value.absent(),
    this.synced = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
  }) : nombreActividad = Value(nombreActividad),
       descripcion = Value(descripcion),
       tipo = Value(tipo),
       estado = Value(estado),
       plataforma = Value(plataforma),
       fechaInicio = Value(fechaInicio);
  static Insertable<Actividade> custom({
    Expression<int>? id,
    Expression<String>? nombreActividad,
    Expression<String>? descripcion,
    Expression<String>? tipo,
    Expression<String>? estado,
    Expression<String>? plataforma,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaPublicado,
    Expression<int>? clienteId,
    Expression<String>? nombreClienteManual,
    Expression<String>? notas,
    Expression<double>? precio,
    Expression<bool>? completada,
    Expression<bool>? synced,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombreActividad != null) 'nombre_actividad': nombreActividad,
      if (descripcion != null) 'descripcion': descripcion,
      if (tipo != null) 'tipo': tipo,
      if (estado != null) 'estado': estado,
      if (plataforma != null) 'plataforma': plataforma,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaPublicado != null) 'fecha_publicado': fechaPublicado,
      if (clienteId != null) 'cliente_id': clienteId,
      if (nombreClienteManual != null)
        'nombre_cliente_manual': nombreClienteManual,
      if (notas != null) 'notas': notas,
      if (precio != null) 'precio': precio,
      if (completada != null) 'completada': completada,
      if (synced != null) 'synced': synced,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
    });
  }

  ActividadesCompanion copyWith({
    Value<int>? id,
    Value<String>? nombreActividad,
    Value<String>? descripcion,
    Value<String>? tipo,
    Value<String>? estado,
    Value<String>? plataforma,
    Value<DateTime>? fechaInicio,
    Value<DateTime?>? fechaPublicado,
    Value<int?>? clienteId,
    Value<String?>? nombreClienteManual,
    Value<String?>? notas,
    Value<double?>? precio,
    Value<bool>? completada,
    Value<bool>? synced,
    Value<DateTime>? updatedAt,
    Value<int>? version,
  }) {
    return ActividadesCompanion(
      id: id ?? this.id,
      nombreActividad: nombreActividad ?? this.nombreActividad,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      estado: estado ?? this.estado,
      plataforma: plataforma ?? this.plataforma,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaPublicado: fechaPublicado ?? this.fechaPublicado,
      clienteId: clienteId ?? this.clienteId,
      nombreClienteManual: nombreClienteManual ?? this.nombreClienteManual,
      notas: notas ?? this.notas,
      precio: precio ?? this.precio,
      completada: completada ?? this.completada,
      synced: synced ?? this.synced,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombreActividad.present) {
      map['nombre_actividad'] = Variable<String>(nombreActividad.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (plataforma.present) {
      map['plataforma'] = Variable<String>(plataforma.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaPublicado.present) {
      map['fecha_publicado'] = Variable<DateTime>(fechaPublicado.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (nombreClienteManual.present) {
      map['nombre_cliente_manual'] = Variable<String>(
        nombreClienteManual.value,
      );
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (completada.present) {
      map['completada'] = Variable<bool>(completada.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActividadesCompanion(')
          ..write('id: $id, ')
          ..write('nombreActividad: $nombreActividad, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipo: $tipo, ')
          ..write('estado: $estado, ')
          ..write('plataforma: $plataforma, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaPublicado: $fechaPublicado, ')
          ..write('clienteId: $clienteId, ')
          ..write('nombreClienteManual: $nombreClienteManual, ')
          ..write('notas: $notas, ')
          ..write('precio: $precio, ')
          ..write('completada: $completada, ')
          ..write('synced: $synced, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }
}

class $ServiciosTable extends Servicios
    with TableInfo<$ServiciosTable, Servicio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiciosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
    'precio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _esServicioMeta = const VerificationMeta(
    'esServicio',
  );
  @override
  late final GeneratedColumn<bool> esServicio = GeneratedColumn<bool>(
    'es_servicio',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_servicio" IN (0, 1))',
    ),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    descripcion,
    precio,
    esServicio,
    synced,
    updatedAt,
    version,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servicios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Servicio> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('precio')) {
      context.handle(
        _precioMeta,
        precio.isAcceptableOrUnknown(data['precio']!, _precioMeta),
      );
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('es_servicio')) {
      context.handle(
        _esServicioMeta,
        esServicio.isAcceptableOrUnknown(data['es_servicio']!, _esServicioMeta),
      );
    } else if (isInserting) {
      context.missing(_esServicioMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Servicio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Servicio(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      precio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio'],
      )!,
      esServicio: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_servicio'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  $ServiciosTable createAlias(String alias) {
    return $ServiciosTable(attachedDatabase, alias);
  }
}

class Servicio extends DataClass implements Insertable<Servicio> {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final bool esServicio;
  final bool synced;
  final DateTime updatedAt;
  final int version;
  const Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.esServicio,
    required this.synced,
    required this.updatedAt,
    required this.version,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['descripcion'] = Variable<String>(descripcion);
    map['precio'] = Variable<double>(precio);
    map['es_servicio'] = Variable<bool>(esServicio);
    map['synced'] = Variable<bool>(synced);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['version'] = Variable<int>(version);
    return map;
  }

  ServiciosCompanion toCompanion(bool nullToAbsent) {
    return ServiciosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion: Value(descripcion),
      precio: Value(precio),
      esServicio: Value(esServicio),
      synced: Value(synced),
      updatedAt: Value(updatedAt),
      version: Value(version),
    );
  }

  factory Servicio.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Servicio(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      precio: serializer.fromJson<double>(json['precio']),
      esServicio: serializer.fromJson<bool>(json['esServicio']),
      synced: serializer.fromJson<bool>(json['synced']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String>(descripcion),
      'precio': serializer.toJson<double>(precio),
      'esServicio': serializer.toJson<bool>(esServicio),
      'synced': serializer.toJson<bool>(synced),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  Servicio copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    double? precio,
    bool? esServicio,
    bool? synced,
    DateTime? updatedAt,
    int? version,
  }) => Servicio(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion ?? this.descripcion,
    precio: precio ?? this.precio,
    esServicio: esServicio ?? this.esServicio,
    synced: synced ?? this.synced,
    updatedAt: updatedAt ?? this.updatedAt,
    version: version ?? this.version,
  );
  Servicio copyWithCompanion(ServiciosCompanion data) {
    return Servicio(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      precio: data.precio.present ? data.precio.value : this.precio,
      esServicio: data.esServicio.present
          ? data.esServicio.value
          : this.esServicio,
      synced: data.synced.present ? data.synced.value : this.synced,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Servicio(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('precio: $precio, ')
          ..write('esServicio: $esServicio, ')
          ..write('synced: $synced, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    descripcion,
    precio,
    esServicio,
    synced,
    updatedAt,
    version,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Servicio &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.precio == this.precio &&
          other.esServicio == this.esServicio &&
          other.synced == this.synced &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class ServiciosCompanion extends UpdateCompanion<Servicio> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> descripcion;
  final Value<double> precio;
  final Value<bool> esServicio;
  final Value<bool> synced;
  final Value<DateTime> updatedAt;
  final Value<int> version;
  const ServiciosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.precio = const Value.absent(),
    this.esServicio = const Value.absent(),
    this.synced = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
  });
  ServiciosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String descripcion,
    required double precio,
    required bool esServicio,
    this.synced = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
  }) : nombre = Value(nombre),
       descripcion = Value(descripcion),
       precio = Value(precio),
       esServicio = Value(esServicio);
  static Insertable<Servicio> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<double>? precio,
    Expression<bool>? esServicio,
    Expression<bool>? synced,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (precio != null) 'precio': precio,
      if (esServicio != null) 'es_servicio': esServicio,
      if (synced != null) 'synced': synced,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
    });
  }

  ServiciosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? descripcion,
    Value<double>? precio,
    Value<bool>? esServicio,
    Value<bool>? synced,
    Value<DateTime>? updatedAt,
    Value<int>? version,
  }) {
    return ServiciosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      esServicio: esServicio ?? this.esServicio,
      synced: synced ?? this.synced,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (esServicio.present) {
      map['es_servicio'] = Variable<bool>(esServicio.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiciosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('precio: $precio, ')
          ..write('esServicio: $esServicio, ')
          ..write('synced: $synced, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracionEmpresaTable extends ConfiguracionEmpresa
    with TableInfo<$ConfiguracionEmpresaTable, ConfiguracionEmpresaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracionEmpresaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreEmpresaMeta = const VerificationMeta(
    'nombreEmpresa',
  );
  @override
  late final GeneratedColumn<String> nombreEmpresa = GeneratedColumn<String>(
    'nombre_empresa',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responsableMeta = const VerificationMeta(
    'responsable',
  );
  @override
  late final GeneratedColumn<String> responsable = GeneratedColumn<String>(
    'responsable',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactoMeta = const VerificationMeta(
    'contacto',
  );
  @override
  late final GeneratedColumn<String> contacto = GeneratedColumn<String>(
    'contacto',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutaLogoMeta = const VerificationMeta(
    'rutaLogo',
  );
  @override
  late final GeneratedColumn<String> rutaLogo = GeneratedColumn<String>(
    'ruta_logo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombreEmpresa,
    responsable,
    contacto,
    direccion,
    rutaLogo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracion_empresa';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfiguracionEmpresaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre_empresa')) {
      context.handle(
        _nombreEmpresaMeta,
        nombreEmpresa.isAcceptableOrUnknown(
          data['nombre_empresa']!,
          _nombreEmpresaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreEmpresaMeta);
    }
    if (data.containsKey('responsable')) {
      context.handle(
        _responsableMeta,
        responsable.isAcceptableOrUnknown(
          data['responsable']!,
          _responsableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_responsableMeta);
    }
    if (data.containsKey('contacto')) {
      context.handle(
        _contactoMeta,
        contacto.isAcceptableOrUnknown(data['contacto']!, _contactoMeta),
      );
    } else if (isInserting) {
      context.missing(_contactoMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    } else if (isInserting) {
      context.missing(_direccionMeta);
    }
    if (data.containsKey('ruta_logo')) {
      context.handle(
        _rutaLogoMeta,
        rutaLogo.isAcceptableOrUnknown(data['ruta_logo']!, _rutaLogoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfiguracionEmpresaData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracionEmpresaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombreEmpresa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_empresa'],
      )!,
      responsable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}responsable'],
      )!,
      contacto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contacto'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      rutaLogo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruta_logo'],
      ),
    );
  }

  @override
  $ConfiguracionEmpresaTable createAlias(String alias) {
    return $ConfiguracionEmpresaTable(attachedDatabase, alias);
  }
}

class ConfiguracionEmpresaData extends DataClass
    implements Insertable<ConfiguracionEmpresaData> {
  final int id;
  final String nombreEmpresa;
  final String responsable;
  final String contacto;
  final String direccion;
  final String? rutaLogo;
  const ConfiguracionEmpresaData({
    required this.id,
    required this.nombreEmpresa,
    required this.responsable,
    required this.contacto,
    required this.direccion,
    this.rutaLogo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre_empresa'] = Variable<String>(nombreEmpresa);
    map['responsable'] = Variable<String>(responsable);
    map['contacto'] = Variable<String>(contacto);
    map['direccion'] = Variable<String>(direccion);
    if (!nullToAbsent || rutaLogo != null) {
      map['ruta_logo'] = Variable<String>(rutaLogo);
    }
    return map;
  }

  ConfiguracionEmpresaCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracionEmpresaCompanion(
      id: Value(id),
      nombreEmpresa: Value(nombreEmpresa),
      responsable: Value(responsable),
      contacto: Value(contacto),
      direccion: Value(direccion),
      rutaLogo: rutaLogo == null && nullToAbsent
          ? const Value.absent()
          : Value(rutaLogo),
    );
  }

  factory ConfiguracionEmpresaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracionEmpresaData(
      id: serializer.fromJson<int>(json['id']),
      nombreEmpresa: serializer.fromJson<String>(json['nombreEmpresa']),
      responsable: serializer.fromJson<String>(json['responsable']),
      contacto: serializer.fromJson<String>(json['contacto']),
      direccion: serializer.fromJson<String>(json['direccion']),
      rutaLogo: serializer.fromJson<String?>(json['rutaLogo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombreEmpresa': serializer.toJson<String>(nombreEmpresa),
      'responsable': serializer.toJson<String>(responsable),
      'contacto': serializer.toJson<String>(contacto),
      'direccion': serializer.toJson<String>(direccion),
      'rutaLogo': serializer.toJson<String?>(rutaLogo),
    };
  }

  ConfiguracionEmpresaData copyWith({
    int? id,
    String? nombreEmpresa,
    String? responsable,
    String? contacto,
    String? direccion,
    Value<String?> rutaLogo = const Value.absent(),
  }) => ConfiguracionEmpresaData(
    id: id ?? this.id,
    nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
    responsable: responsable ?? this.responsable,
    contacto: contacto ?? this.contacto,
    direccion: direccion ?? this.direccion,
    rutaLogo: rutaLogo.present ? rutaLogo.value : this.rutaLogo,
  );
  ConfiguracionEmpresaData copyWithCompanion(
    ConfiguracionEmpresaCompanion data,
  ) {
    return ConfiguracionEmpresaData(
      id: data.id.present ? data.id.value : this.id,
      nombreEmpresa: data.nombreEmpresa.present
          ? data.nombreEmpresa.value
          : this.nombreEmpresa,
      responsable: data.responsable.present
          ? data.responsable.value
          : this.responsable,
      contacto: data.contacto.present ? data.contacto.value : this.contacto,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      rutaLogo: data.rutaLogo.present ? data.rutaLogo.value : this.rutaLogo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionEmpresaData(')
          ..write('id: $id, ')
          ..write('nombreEmpresa: $nombreEmpresa, ')
          ..write('responsable: $responsable, ')
          ..write('contacto: $contacto, ')
          ..write('direccion: $direccion, ')
          ..write('rutaLogo: $rutaLogo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombreEmpresa,
    responsable,
    contacto,
    direccion,
    rutaLogo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracionEmpresaData &&
          other.id == this.id &&
          other.nombreEmpresa == this.nombreEmpresa &&
          other.responsable == this.responsable &&
          other.contacto == this.contacto &&
          other.direccion == this.direccion &&
          other.rutaLogo == this.rutaLogo);
}

class ConfiguracionEmpresaCompanion
    extends UpdateCompanion<ConfiguracionEmpresaData> {
  final Value<int> id;
  final Value<String> nombreEmpresa;
  final Value<String> responsable;
  final Value<String> contacto;
  final Value<String> direccion;
  final Value<String?> rutaLogo;
  const ConfiguracionEmpresaCompanion({
    this.id = const Value.absent(),
    this.nombreEmpresa = const Value.absent(),
    this.responsable = const Value.absent(),
    this.contacto = const Value.absent(),
    this.direccion = const Value.absent(),
    this.rutaLogo = const Value.absent(),
  });
  ConfiguracionEmpresaCompanion.insert({
    this.id = const Value.absent(),
    required String nombreEmpresa,
    required String responsable,
    required String contacto,
    required String direccion,
    this.rutaLogo = const Value.absent(),
  }) : nombreEmpresa = Value(nombreEmpresa),
       responsable = Value(responsable),
       contacto = Value(contacto),
       direccion = Value(direccion);
  static Insertable<ConfiguracionEmpresaData> custom({
    Expression<int>? id,
    Expression<String>? nombreEmpresa,
    Expression<String>? responsable,
    Expression<String>? contacto,
    Expression<String>? direccion,
    Expression<String>? rutaLogo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombreEmpresa != null) 'nombre_empresa': nombreEmpresa,
      if (responsable != null) 'responsable': responsable,
      if (contacto != null) 'contacto': contacto,
      if (direccion != null) 'direccion': direccion,
      if (rutaLogo != null) 'ruta_logo': rutaLogo,
    });
  }

  ConfiguracionEmpresaCompanion copyWith({
    Value<int>? id,
    Value<String>? nombreEmpresa,
    Value<String>? responsable,
    Value<String>? contacto,
    Value<String>? direccion,
    Value<String?>? rutaLogo,
  }) {
    return ConfiguracionEmpresaCompanion(
      id: id ?? this.id,
      nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
      responsable: responsable ?? this.responsable,
      contacto: contacto ?? this.contacto,
      direccion: direccion ?? this.direccion,
      rutaLogo: rutaLogo ?? this.rutaLogo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombreEmpresa.present) {
      map['nombre_empresa'] = Variable<String>(nombreEmpresa.value);
    }
    if (responsable.present) {
      map['responsable'] = Variable<String>(responsable.value);
    }
    if (contacto.present) {
      map['contacto'] = Variable<String>(contacto.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (rutaLogo.present) {
      map['ruta_logo'] = Variable<String>(rutaLogo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracionEmpresaCompanion(')
          ..write('id: $id, ')
          ..write('nombreEmpresa: $nombreEmpresa, ')
          ..write('responsable: $responsable, ')
          ..write('contacto: $contacto, ')
          ..write('direccion: $direccion, ')
          ..write('rutaLogo: $rutaLogo')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadatum> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceNameMeta = const VerificationMeta(
    'deviceName',
  );
  @override
  late final GeneratedColumn<String> deviceName = GeneratedColumn<String>(
    'device_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIpMeta = const VerificationMeta(
    'serverIp',
  );
  @override
  late final GeneratedColumn<String> serverIp = GeneratedColumn<String>(
    'server_ip',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastSyncAt,
    deviceId,
    deviceName,
    serverIp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadatum> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('device_name')) {
      context.handle(
        _deviceNameMeta,
        deviceName.isAcceptableOrUnknown(data['device_name']!, _deviceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceNameMeta);
    }
    if (data.containsKey('server_ip')) {
      context.handle(
        _serverIpMeta,
        serverIp.isAcceptableOrUnknown(data['server_ip']!, _serverIpMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncMetadatum map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadatum(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      deviceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_name'],
      )!,
      serverIp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_ip'],
      ),
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadatum extends DataClass implements Insertable<SyncMetadatum> {
  final int id;
  final DateTime? lastSyncAt;
  final String deviceId;
  final String deviceName;
  final String? serverIp;
  const SyncMetadatum({
    required this.id,
    this.lastSyncAt,
    required this.deviceId,
    required this.deviceName,
    this.serverIp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['device_name'] = Variable<String>(deviceName);
    if (!nullToAbsent || serverIp != null) {
      map['server_ip'] = Variable<String>(serverIp);
    }
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      id: Value(id),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      deviceId: Value(deviceId),
      deviceName: Value(deviceName),
      serverIp: serverIp == null && nullToAbsent
          ? const Value.absent()
          : Value(serverIp),
    );
  }

  factory SyncMetadatum.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadatum(
      id: serializer.fromJson<int>(json['id']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      deviceName: serializer.fromJson<String>(json['deviceName']),
      serverIp: serializer.fromJson<String?>(json['serverIp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'deviceName': serializer.toJson<String>(deviceName),
      'serverIp': serializer.toJson<String?>(serverIp),
    };
  }

  SyncMetadatum copyWith({
    int? id,
    Value<DateTime?> lastSyncAt = const Value.absent(),
    String? deviceId,
    String? deviceName,
    Value<String?> serverIp = const Value.absent(),
  }) => SyncMetadatum(
    id: id ?? this.id,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    deviceId: deviceId ?? this.deviceId,
    deviceName: deviceName ?? this.deviceName,
    serverIp: serverIp.present ? serverIp.value : this.serverIp,
  );
  SyncMetadatum copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadatum(
      id: data.id.present ? data.id.value : this.id,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      deviceName: data.deviceName.present
          ? data.deviceName.value
          : this.deviceName,
      serverIp: data.serverIp.present ? data.serverIp.value : this.serverIp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadatum(')
          ..write('id: $id, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceName: $deviceName, ')
          ..write('serverIp: $serverIp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lastSyncAt, deviceId, deviceName, serverIp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadatum &&
          other.id == this.id &&
          other.lastSyncAt == this.lastSyncAt &&
          other.deviceId == this.deviceId &&
          other.deviceName == this.deviceName &&
          other.serverIp == this.serverIp);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadatum> {
  final Value<int> id;
  final Value<DateTime?> lastSyncAt;
  final Value<String> deviceId;
  final Value<String> deviceName;
  final Value<String?> serverIp;
  const SyncMetadataCompanion({
    this.id = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.deviceName = const Value.absent(),
    this.serverIp = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    this.id = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    required String deviceId,
    required String deviceName,
    this.serverIp = const Value.absent(),
  }) : deviceId = Value(deviceId),
       deviceName = Value(deviceName);
  static Insertable<SyncMetadatum> custom({
    Expression<int>? id,
    Expression<DateTime>? lastSyncAt,
    Expression<String>? deviceId,
    Expression<String>? deviceName,
    Expression<String>? serverIp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (deviceId != null) 'device_id': deviceId,
      if (deviceName != null) 'device_name': deviceName,
      if (serverIp != null) 'server_ip': serverIp,
    });
  }

  SyncMetadataCompanion copyWith({
    Value<int>? id,
    Value<DateTime?>? lastSyncAt,
    Value<String>? deviceId,
    Value<String>? deviceName,
    Value<String?>? serverIp,
  }) {
    return SyncMetadataCompanion(
      id: id ?? this.id,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      serverIp: serverIp ?? this.serverIp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (deviceName.present) {
      map['device_name'] = Variable<String>(deviceName.value);
    }
    if (serverIp.present) {
      map['server_ip'] = Variable<String>(serverIp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('id: $id, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('deviceName: $deviceName, ')
          ..write('serverIp: $serverIp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $ActividadesTable actividades = $ActividadesTable(this);
  late final $ServiciosTable servicios = $ServiciosTable(this);
  late final $ConfiguracionEmpresaTable configuracionEmpresa =
      $ConfiguracionEmpresaTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clientes,
    actividades,
    servicios,
    configuracionEmpresa,
    syncMetadata,
  ];
}

typedef $$ClientesTableCreateCompanionBuilder =
    ClientesCompanion Function({
      Value<int> id,
      required String empresa,
      required String nombreGerente,
      required String numeroContacto,
      required String servicio,
      required DateTime fechaRegistro,
      required DateTime fechaEntrega,
      Value<bool> synced,
      Value<DateTime> updatedAt,
      Value<int> version,
    });
typedef $$ClientesTableUpdateCompanionBuilder =
    ClientesCompanion Function({
      Value<int> id,
      Value<String> empresa,
      Value<String> nombreGerente,
      Value<String> numeroContacto,
      Value<String> servicio,
      Value<DateTime> fechaRegistro,
      Value<DateTime> fechaEntrega,
      Value<bool> synced,
      Value<DateTime> updatedAt,
      Value<int> version,
    });

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ActividadesTable, List<Actividade>>
  _actividadesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.actividades,
    aliasName: $_aliasNameGenerator(db.clientes.id, db.actividades.clienteId),
  );

  $$ActividadesTableProcessedTableManager get actividadesRefs {
    final manager = $$ActividadesTableTableManager(
      $_db,
      $_db.actividades,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_actividadesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresa => $composableBuilder(
    column: $table.empresa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreGerente => $composableBuilder(
    column: $table.nombreGerente,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroContacto => $composableBuilder(
    column: $table.numeroContacto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get servicio => $composableBuilder(
    column: $table.servicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> actividadesRefs(
    Expression<bool> Function($$ActividadesTableFilterComposer f) f,
  ) {
    final $$ActividadesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.actividades,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActividadesTableFilterComposer(
            $db: $db,
            $table: $db.actividades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresa => $composableBuilder(
    column: $table.empresa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreGerente => $composableBuilder(
    column: $table.nombreGerente,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroContacto => $composableBuilder(
    column: $table.numeroContacto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get servicio => $composableBuilder(
    column: $table.servicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get empresa =>
      $composableBuilder(column: $table.empresa, builder: (column) => column);

  GeneratedColumn<String> get nombreGerente => $composableBuilder(
    column: $table.nombreGerente,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numeroContacto => $composableBuilder(
    column: $table.numeroContacto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get servicio =>
      $composableBuilder(column: $table.servicio, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaRegistro => $composableBuilder(
    column: $table.fechaRegistro,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaEntrega => $composableBuilder(
    column: $table.fechaEntrega,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  Expression<T> actividadesRefs<T extends Object>(
    Expression<T> Function($$ActividadesTableAnnotationComposer a) f,
  ) {
    final $$ActividadesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.actividades,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActividadesTableAnnotationComposer(
            $db: $db,
            $table: $db.actividades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, $$ClientesTableReferences),
          Cliente,
          PrefetchHooks Function({bool actividadesRefs})
        > {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> empresa = const Value.absent(),
                Value<String> nombreGerente = const Value.absent(),
                Value<String> numeroContacto = const Value.absent(),
                Value<String> servicio = const Value.absent(),
                Value<DateTime> fechaRegistro = const Value.absent(),
                Value<DateTime> fechaEntrega = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                empresa: empresa,
                nombreGerente: nombreGerente,
                numeroContacto: numeroContacto,
                servicio: servicio,
                fechaRegistro: fechaRegistro,
                fechaEntrega: fechaEntrega,
                synced: synced,
                updatedAt: updatedAt,
                version: version,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String empresa,
                required String nombreGerente,
                required String numeroContacto,
                required String servicio,
                required DateTime fechaRegistro,
                required DateTime fechaEntrega,
                Value<bool> synced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                empresa: empresa,
                nombreGerente: nombreGerente,
                numeroContacto: numeroContacto,
                servicio: servicio,
                fechaRegistro: fechaRegistro,
                fechaEntrega: fechaEntrega,
                synced: synced,
                updatedAt: updatedAt,
                version: version,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({actividadesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (actividadesRefs) db.actividades],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (actividadesRefs)
                    await $_getPrefetchedData<
                      Cliente,
                      $ClientesTable,
                      Actividade
                    >(
                      currentTable: table,
                      referencedTable: $$ClientesTableReferences
                          ._actividadesRefsTable(db),
                      managerFromTypedResult: (p0) => $$ClientesTableReferences(
                        db,
                        table,
                        p0,
                      ).actividadesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.clienteId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, $$ClientesTableReferences),
      Cliente,
      PrefetchHooks Function({bool actividadesRefs})
    >;
typedef $$ActividadesTableCreateCompanionBuilder =
    ActividadesCompanion Function({
      Value<int> id,
      required String nombreActividad,
      required String descripcion,
      required String tipo,
      required String estado,
      required String plataforma,
      required DateTime fechaInicio,
      Value<DateTime?> fechaPublicado,
      Value<int?> clienteId,
      Value<String?> nombreClienteManual,
      Value<String?> notas,
      Value<double?> precio,
      Value<bool> completada,
      Value<bool> synced,
      Value<DateTime> updatedAt,
      Value<int> version,
    });
typedef $$ActividadesTableUpdateCompanionBuilder =
    ActividadesCompanion Function({
      Value<int> id,
      Value<String> nombreActividad,
      Value<String> descripcion,
      Value<String> tipo,
      Value<String> estado,
      Value<String> plataforma,
      Value<DateTime> fechaInicio,
      Value<DateTime?> fechaPublicado,
      Value<int?> clienteId,
      Value<String?> nombreClienteManual,
      Value<String?> notas,
      Value<double?> precio,
      Value<bool> completada,
      Value<bool> synced,
      Value<DateTime> updatedAt,
      Value<int> version,
    });

final class $$ActividadesTableReferences
    extends BaseReferences<_$AppDatabase, $ActividadesTable, Actividade> {
  $$ActividadesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias(
        $_aliasNameGenerator(db.actividades.clienteId, db.clientes.id),
      );

  $$ClientesTableProcessedTableManager? get clienteId {
    final $_column = $_itemColumn<int>('cliente_id');
    if ($_column == null) return null;
    final manager = $$ClientesTableTableManager(
      $_db,
      $_db.clientes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActividadesTableFilterComposer
    extends Composer<_$AppDatabase, $ActividadesTable> {
  $$ActividadesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreActividad => $composableBuilder(
    column: $table.nombreActividad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plataforma => $composableBuilder(
    column: $table.plataforma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaPublicado => $composableBuilder(
    column: $table.fechaPublicado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreClienteManual => $composableBuilder(
    column: $table.nombreClienteManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableFilterComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActividadesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActividadesTable> {
  $$ActividadesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreActividad => $composableBuilder(
    column: $table.nombreActividad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plataforma => $composableBuilder(
    column: $table.plataforma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaPublicado => $composableBuilder(
    column: $table.fechaPublicado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreClienteManual => $composableBuilder(
    column: $table.nombreClienteManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableOrderingComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActividadesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActividadesTable> {
  $$ActividadesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreActividad => $composableBuilder(
    column: $table.nombreActividad,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<String> get plataforma => $composableBuilder(
    column: $table.plataforma,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaPublicado => $composableBuilder(
    column: $table.fechaPublicado,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreClienteManual => $composableBuilder(
    column: $table.nombreClienteManual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.clientes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientesTableAnnotationComposer(
            $db: $db,
            $table: $db.clientes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActividadesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActividadesTable,
          Actividade,
          $$ActividadesTableFilterComposer,
          $$ActividadesTableOrderingComposer,
          $$ActividadesTableAnnotationComposer,
          $$ActividadesTableCreateCompanionBuilder,
          $$ActividadesTableUpdateCompanionBuilder,
          (Actividade, $$ActividadesTableReferences),
          Actividade,
          PrefetchHooks Function({bool clienteId})
        > {
  $$ActividadesTableTableManager(_$AppDatabase db, $ActividadesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActividadesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActividadesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActividadesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombreActividad = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<String> plataforma = const Value.absent(),
                Value<DateTime> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaPublicado = const Value.absent(),
                Value<int?> clienteId = const Value.absent(),
                Value<String?> nombreClienteManual = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<double?> precio = const Value.absent(),
                Value<bool> completada = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
              }) => ActividadesCompanion(
                id: id,
                nombreActividad: nombreActividad,
                descripcion: descripcion,
                tipo: tipo,
                estado: estado,
                plataforma: plataforma,
                fechaInicio: fechaInicio,
                fechaPublicado: fechaPublicado,
                clienteId: clienteId,
                nombreClienteManual: nombreClienteManual,
                notas: notas,
                precio: precio,
                completada: completada,
                synced: synced,
                updatedAt: updatedAt,
                version: version,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombreActividad,
                required String descripcion,
                required String tipo,
                required String estado,
                required String plataforma,
                required DateTime fechaInicio,
                Value<DateTime?> fechaPublicado = const Value.absent(),
                Value<int?> clienteId = const Value.absent(),
                Value<String?> nombreClienteManual = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<double?> precio = const Value.absent(),
                Value<bool> completada = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
              }) => ActividadesCompanion.insert(
                id: id,
                nombreActividad: nombreActividad,
                descripcion: descripcion,
                tipo: tipo,
                estado: estado,
                plataforma: plataforma,
                fechaInicio: fechaInicio,
                fechaPublicado: fechaPublicado,
                clienteId: clienteId,
                nombreClienteManual: nombreClienteManual,
                notas: notas,
                precio: precio,
                completada: completada,
                synced: synced,
                updatedAt: updatedAt,
                version: version,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActividadesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clienteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clienteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clienteId,
                                referencedTable: $$ActividadesTableReferences
                                    ._clienteIdTable(db),
                                referencedColumn: $$ActividadesTableReferences
                                    ._clienteIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActividadesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActividadesTable,
      Actividade,
      $$ActividadesTableFilterComposer,
      $$ActividadesTableOrderingComposer,
      $$ActividadesTableAnnotationComposer,
      $$ActividadesTableCreateCompanionBuilder,
      $$ActividadesTableUpdateCompanionBuilder,
      (Actividade, $$ActividadesTableReferences),
      Actividade,
      PrefetchHooks Function({bool clienteId})
    >;
typedef $$ServiciosTableCreateCompanionBuilder =
    ServiciosCompanion Function({
      Value<int> id,
      required String nombre,
      required String descripcion,
      required double precio,
      required bool esServicio,
      Value<bool> synced,
      Value<DateTime> updatedAt,
      Value<int> version,
    });
typedef $$ServiciosTableUpdateCompanionBuilder =
    ServiciosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> descripcion,
      Value<double> precio,
      Value<bool> esServicio,
      Value<bool> synced,
      Value<DateTime> updatedAt,
      Value<int> version,
    });

class $$ServiciosTableFilterComposer
    extends Composer<_$AppDatabase, $ServiciosTable> {
  $$ServiciosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esServicio => $composableBuilder(
    column: $table.esServicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServiciosTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiciosTable> {
  $$ServiciosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esServicio => $composableBuilder(
    column: $table.esServicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiciosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiciosTable> {
  $$ServiciosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<bool> get esServicio => $composableBuilder(
    column: $table.esServicio,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$ServiciosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiciosTable,
          Servicio,
          $$ServiciosTableFilterComposer,
          $$ServiciosTableOrderingComposer,
          $$ServiciosTableAnnotationComposer,
          $$ServiciosTableCreateCompanionBuilder,
          $$ServiciosTableUpdateCompanionBuilder,
          (Servicio, BaseReferences<_$AppDatabase, $ServiciosTable, Servicio>),
          Servicio,
          PrefetchHooks Function()
        > {
  $$ServiciosTableTableManager(_$AppDatabase db, $ServiciosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiciosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiciosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiciosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<double> precio = const Value.absent(),
                Value<bool> esServicio = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
              }) => ServiciosCompanion(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                precio: precio,
                esServicio: esServicio,
                synced: synced,
                updatedAt: updatedAt,
                version: version,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String descripcion,
                required double precio,
                required bool esServicio,
                Value<bool> synced = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
              }) => ServiciosCompanion.insert(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                precio: precio,
                esServicio: esServicio,
                synced: synced,
                updatedAt: updatedAt,
                version: version,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServiciosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiciosTable,
      Servicio,
      $$ServiciosTableFilterComposer,
      $$ServiciosTableOrderingComposer,
      $$ServiciosTableAnnotationComposer,
      $$ServiciosTableCreateCompanionBuilder,
      $$ServiciosTableUpdateCompanionBuilder,
      (Servicio, BaseReferences<_$AppDatabase, $ServiciosTable, Servicio>),
      Servicio,
      PrefetchHooks Function()
    >;
typedef $$ConfiguracionEmpresaTableCreateCompanionBuilder =
    ConfiguracionEmpresaCompanion Function({
      Value<int> id,
      required String nombreEmpresa,
      required String responsable,
      required String contacto,
      required String direccion,
      Value<String?> rutaLogo,
    });
typedef $$ConfiguracionEmpresaTableUpdateCompanionBuilder =
    ConfiguracionEmpresaCompanion Function({
      Value<int> id,
      Value<String> nombreEmpresa,
      Value<String> responsable,
      Value<String> contacto,
      Value<String> direccion,
      Value<String?> rutaLogo,
    });

class $$ConfiguracionEmpresaTableFilterComposer
    extends Composer<_$AppDatabase, $ConfiguracionEmpresaTable> {
  $$ConfiguracionEmpresaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreEmpresa => $composableBuilder(
    column: $table.nombreEmpresa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get responsable => $composableBuilder(
    column: $table.responsable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contacto => $composableBuilder(
    column: $table.contacto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rutaLogo => $composableBuilder(
    column: $table.rutaLogo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfiguracionEmpresaTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfiguracionEmpresaTable> {
  $$ConfiguracionEmpresaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreEmpresa => $composableBuilder(
    column: $table.nombreEmpresa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get responsable => $composableBuilder(
    column: $table.responsable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contacto => $composableBuilder(
    column: $table.contacto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rutaLogo => $composableBuilder(
    column: $table.rutaLogo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfiguracionEmpresaTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfiguracionEmpresaTable> {
  $$ConfiguracionEmpresaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombreEmpresa => $composableBuilder(
    column: $table.nombreEmpresa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get responsable => $composableBuilder(
    column: $table.responsable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contacto =>
      $composableBuilder(column: $table.contacto, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get rutaLogo =>
      $composableBuilder(column: $table.rutaLogo, builder: (column) => column);
}

class $$ConfiguracionEmpresaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfiguracionEmpresaTable,
          ConfiguracionEmpresaData,
          $$ConfiguracionEmpresaTableFilterComposer,
          $$ConfiguracionEmpresaTableOrderingComposer,
          $$ConfiguracionEmpresaTableAnnotationComposer,
          $$ConfiguracionEmpresaTableCreateCompanionBuilder,
          $$ConfiguracionEmpresaTableUpdateCompanionBuilder,
          (
            ConfiguracionEmpresaData,
            BaseReferences<
              _$AppDatabase,
              $ConfiguracionEmpresaTable,
              ConfiguracionEmpresaData
            >,
          ),
          ConfiguracionEmpresaData,
          PrefetchHooks Function()
        > {
  $$ConfiguracionEmpresaTableTableManager(
    _$AppDatabase db,
    $ConfiguracionEmpresaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracionEmpresaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfiguracionEmpresaTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ConfiguracionEmpresaTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombreEmpresa = const Value.absent(),
                Value<String> responsable = const Value.absent(),
                Value<String> contacto = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String?> rutaLogo = const Value.absent(),
              }) => ConfiguracionEmpresaCompanion(
                id: id,
                nombreEmpresa: nombreEmpresa,
                responsable: responsable,
                contacto: contacto,
                direccion: direccion,
                rutaLogo: rutaLogo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombreEmpresa,
                required String responsable,
                required String contacto,
                required String direccion,
                Value<String?> rutaLogo = const Value.absent(),
              }) => ConfiguracionEmpresaCompanion.insert(
                id: id,
                nombreEmpresa: nombreEmpresa,
                responsable: responsable,
                contacto: contacto,
                direccion: direccion,
                rutaLogo: rutaLogo,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfiguracionEmpresaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfiguracionEmpresaTable,
      ConfiguracionEmpresaData,
      $$ConfiguracionEmpresaTableFilterComposer,
      $$ConfiguracionEmpresaTableOrderingComposer,
      $$ConfiguracionEmpresaTableAnnotationComposer,
      $$ConfiguracionEmpresaTableCreateCompanionBuilder,
      $$ConfiguracionEmpresaTableUpdateCompanionBuilder,
      (
        ConfiguracionEmpresaData,
        BaseReferences<
          _$AppDatabase,
          $ConfiguracionEmpresaTable,
          ConfiguracionEmpresaData
        >,
      ),
      ConfiguracionEmpresaData,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataTableCreateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<int> id,
      Value<DateTime?> lastSyncAt,
      required String deviceId,
      required String deviceName,
      Value<String?> serverIp,
    });
typedef $$SyncMetadataTableUpdateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<int> id,
      Value<DateTime?> lastSyncAt,
      Value<String> deviceId,
      Value<String> deviceName,
      Value<String?> serverIp,
    });

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverIp => $composableBuilder(
    column: $table.serverIp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverIp => $composableBuilder(
    column: $table.serverIp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get deviceName => $composableBuilder(
    column: $table.deviceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverIp =>
      $composableBuilder(column: $table.serverIp, builder: (column) => column);
}

class $$SyncMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetadataTable,
          SyncMetadatum,
          $$SyncMetadataTableFilterComposer,
          $$SyncMetadataTableOrderingComposer,
          $$SyncMetadataTableAnnotationComposer,
          $$SyncMetadataTableCreateCompanionBuilder,
          $$SyncMetadataTableUpdateCompanionBuilder,
          (
            SyncMetadatum,
            BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadatum>,
          ),
          SyncMetadatum,
          PrefetchHooks Function()
        > {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> deviceName = const Value.absent(),
                Value<String?> serverIp = const Value.absent(),
              }) => SyncMetadataCompanion(
                id: id,
                lastSyncAt: lastSyncAt,
                deviceId: deviceId,
                deviceName: deviceName,
                serverIp: serverIp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                required String deviceId,
                required String deviceName,
                Value<String?> serverIp = const Value.absent(),
              }) => SyncMetadataCompanion.insert(
                id: id,
                lastSyncAt: lastSyncAt,
                deviceId: deviceId,
                deviceName: deviceName,
                serverIp: serverIp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetadataTable,
      SyncMetadatum,
      $$SyncMetadataTableFilterComposer,
      $$SyncMetadataTableOrderingComposer,
      $$SyncMetadataTableAnnotationComposer,
      $$SyncMetadataTableCreateCompanionBuilder,
      $$SyncMetadataTableUpdateCompanionBuilder,
      (
        SyncMetadatum,
        BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadatum>,
      ),
      SyncMetadatum,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$ActividadesTableTableManager get actividades =>
      $$ActividadesTableTableManager(_db, _db.actividades);
  $$ServiciosTableTableManager get servicios =>
      $$ServiciosTableTableManager(_db, _db.servicios);
  $$ConfiguracionEmpresaTableTableManager get configuracionEmpresa =>
      $$ConfiguracionEmpresaTableTableManager(_db, _db.configuracionEmpresa);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
}
