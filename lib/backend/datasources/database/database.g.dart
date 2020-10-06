// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class GeoPolygonModel extends DataClass implements Insertable<GeoPolygonModel> {
  final int id;
  final String name;
  GeoPolygonModel({@required this.id, @required this.name});
  factory GeoPolygonModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return GeoPolygonModel(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  GeoPolygonModelsCompanion toCompanion(bool nullToAbsent) {
    return GeoPolygonModelsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory GeoPolygonModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return GeoPolygonModel(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  GeoPolygonModel copyWith({int id, String name}) => GeoPolygonModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('GeoPolygonModel(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, name.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is GeoPolygonModel &&
          other.id == this.id &&
          other.name == this.name);
}

class GeoPolygonModelsCompanion extends UpdateCompanion<GeoPolygonModel> {
  final Value<int> id;
  final Value<String> name;
  const GeoPolygonModelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  GeoPolygonModelsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
  }) : name = Value(name);
  static Insertable<GeoPolygonModel> custom({
    Expression<int> id,
    Expression<String> name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  GeoPolygonModelsCompanion copyWith({Value<int> id, Value<String> name}) {
    return GeoPolygonModelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeoPolygonModelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $GeoPolygonModelsTable extends GeoPolygonModels
    with TableInfo<$GeoPolygonModelsTable, GeoPolygonModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $GeoPolygonModelsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  $GeoPolygonModelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'geo_polygon_models';
  @override
  final String actualTableName = 'geo_polygon_models';
  @override
  VerificationContext validateIntegrity(Insertable<GeoPolygonModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GeoPolygonModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return GeoPolygonModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $GeoPolygonModelsTable createAlias(String alias) {
    return $GeoPolygonModelsTable(_db, alias);
  }
}

class GeoVertexModel extends DataClass implements Insertable<GeoVertexModel> {
  final int id;
  final double latitude;
  final double longitude;
  final int polygon_id;
  GeoVertexModel(
      {@required this.id,
      @required this.latitude,
      @required this.longitude,
      @required this.polygon_id});
  factory GeoVertexModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    return GeoVertexModel(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      latitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude']),
      longitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude']),
      polygon_id:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}polygon_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || polygon_id != null) {
      map['polygon_id'] = Variable<int>(polygon_id);
    }
    return map;
  }

  GeoVertexModelsCompanion toCompanion(bool nullToAbsent) {
    return GeoVertexModelsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      polygon_id: polygon_id == null && nullToAbsent
          ? const Value.absent()
          : Value(polygon_id),
    );
  }

  factory GeoVertexModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return GeoVertexModel(
      id: serializer.fromJson<int>(json['id']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      polygon_id: serializer.fromJson<int>(json['polygon_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'polygon_id': serializer.toJson<int>(polygon_id),
    };
  }

  GeoVertexModel copyWith(
          {int id, double latitude, double longitude, int polygon_id}) =>
      GeoVertexModel(
        id: id ?? this.id,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        polygon_id: polygon_id ?? this.polygon_id,
      );
  @override
  String toString() {
    return (StringBuffer('GeoVertexModel(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('polygon_id: $polygon_id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          latitude.hashCode, $mrjc(longitude.hashCode, polygon_id.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is GeoVertexModel &&
          other.id == this.id &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.polygon_id == this.polygon_id);
}

class GeoVertexModelsCompanion extends UpdateCompanion<GeoVertexModel> {
  final Value<int> id;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<int> polygon_id;
  const GeoVertexModelsCompanion({
    this.id = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.polygon_id = const Value.absent(),
  });
  GeoVertexModelsCompanion.insert({
    this.id = const Value.absent(),
    @required double latitude,
    @required double longitude,
    @required int polygon_id,
  })  : latitude = Value(latitude),
        longitude = Value(longitude),
        polygon_id = Value(polygon_id);
  static Insertable<GeoVertexModel> custom({
    Expression<int> id,
    Expression<double> latitude,
    Expression<double> longitude,
    Expression<int> polygon_id,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (polygon_id != null) 'polygon_id': polygon_id,
    });
  }

  GeoVertexModelsCompanion copyWith(
      {Value<int> id,
      Value<double> latitude,
      Value<double> longitude,
      Value<int> polygon_id}) {
    return GeoVertexModelsCompanion(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      polygon_id: polygon_id ?? this.polygon_id,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (polygon_id.present) {
      map['polygon_id'] = Variable<int>(polygon_id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeoVertexModelsCompanion(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('polygon_id: $polygon_id')
          ..write(')'))
        .toString();
  }
}

class $GeoVertexModelsTable extends GeoVertexModels
    with TableInfo<$GeoVertexModelsTable, GeoVertexModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $GeoVertexModelsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  GeneratedRealColumn _latitude;
  @override
  GeneratedRealColumn get latitude => _latitude ??= _constructLatitude();
  GeneratedRealColumn _constructLatitude() {
    return GeneratedRealColumn(
      'latitude',
      $tableName,
      false,
    );
  }

  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  GeneratedRealColumn _longitude;
  @override
  GeneratedRealColumn get longitude => _longitude ??= _constructLongitude();
  GeneratedRealColumn _constructLongitude() {
    return GeneratedRealColumn(
      'longitude',
      $tableName,
      false,
    );
  }

  final VerificationMeta _polygon_idMeta = const VerificationMeta('polygon_id');
  GeneratedIntColumn _polygon_id;
  @override
  GeneratedIntColumn get polygon_id => _polygon_id ??= _constructPolygonId();
  GeneratedIntColumn _constructPolygonId() {
    return GeneratedIntColumn('polygon_id', $tableName, false,
        $customConstraints: 'REFERENCES geo_polygon_models(id)');
  }

  @override
  List<GeneratedColumn> get $columns => [id, latitude, longitude, polygon_id];
  @override
  $GeoVertexModelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'geo_vertex_models';
  @override
  final String actualTableName = 'geo_vertex_models';
  @override
  VerificationContext validateIntegrity(Insertable<GeoVertexModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude'], _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude'], _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('polygon_id')) {
      context.handle(
          _polygon_idMeta,
          polygon_id.isAcceptableOrUnknown(
              data['polygon_id'], _polygon_idMeta));
    } else if (isInserting) {
      context.missing(_polygon_idMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GeoVertexModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return GeoVertexModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $GeoVertexModelsTable createAlias(String alias) {
    return $GeoVertexModelsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $GeoPolygonModelsTable _geoPolygonModels;
  $GeoPolygonModelsTable get geoPolygonModels =>
      _geoPolygonModels ??= $GeoPolygonModelsTable(this);
  $GeoVertexModelsTable _geoVertexModels;
  $GeoVertexModelsTable get geoVertexModels =>
      _geoVertexModels ??= $GeoVertexModelsTable(this);
  GeoPolygonDaoImpl _geoPolygonDaoImpl;
  GeoPolygonDaoImpl get geoPolygonDaoImpl =>
      _geoPolygonDaoImpl ??= GeoPolygonDaoImpl(this as AppDatabase);
  GeoVertexDaoImpl _geoVertexDaoImpl;
  GeoVertexDaoImpl get geoVertexDaoImpl =>
      _geoVertexDaoImpl ??= GeoVertexDaoImpl(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [geoPolygonModels, geoVertexModels];
}
