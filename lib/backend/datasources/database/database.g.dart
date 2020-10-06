// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class SearchAreaModelData extends DataClass
    implements Insertable<SearchAreaModelData> {
  final int id;
  final double latitude;
  final double longitude;
  final int area_id;
  SearchAreaModelData(
      {@required this.id,
      @required this.latitude,
      @required this.longitude,
      @required this.area_id});
  factory SearchAreaModelData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    return SearchAreaModelData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      latitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude']),
      longitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude']),
      area_id:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}area_id']),
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
    if (!nullToAbsent || area_id != null) {
      map['area_id'] = Variable<int>(area_id);
    }
    return map;
  }

  SearchAreaModelCompanion toCompanion(bool nullToAbsent) {
    return SearchAreaModelCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      area_id: area_id == null && nullToAbsent
          ? const Value.absent()
          : Value(area_id),
    );
  }

  factory SearchAreaModelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return SearchAreaModelData(
      id: serializer.fromJson<int>(json['id']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      area_id: serializer.fromJson<int>(json['area_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'area_id': serializer.toJson<int>(area_id),
    };
  }

  SearchAreaModelData copyWith(
          {int id, double latitude, double longitude, int area_id}) =>
      SearchAreaModelData(
        id: id ?? this.id,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        area_id: area_id ?? this.area_id,
      );
  @override
  String toString() {
    return (StringBuffer('SearchAreaModelData(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('area_id: $area_id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(latitude.hashCode, $mrjc(longitude.hashCode, area_id.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is SearchAreaModelData &&
          other.id == this.id &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.area_id == this.area_id);
}

class SearchAreaModelCompanion extends UpdateCompanion<SearchAreaModelData> {
  final Value<int> id;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<int> area_id;
  const SearchAreaModelCompanion({
    this.id = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.area_id = const Value.absent(),
  });
  SearchAreaModelCompanion.insert({
    this.id = const Value.absent(),
    @required double latitude,
    @required double longitude,
    @required int area_id,
  })  : latitude = Value(latitude),
        longitude = Value(longitude),
        area_id = Value(area_id);
  static Insertable<SearchAreaModelData> custom({
    Expression<int> id,
    Expression<double> latitude,
    Expression<double> longitude,
    Expression<int> area_id,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (area_id != null) 'area_id': area_id,
    });
  }

  SearchAreaModelCompanion copyWith(
      {Value<int> id,
      Value<double> latitude,
      Value<double> longitude,
      Value<int> area_id}) {
    return SearchAreaModelCompanion(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      area_id: area_id ?? this.area_id,
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
    if (area_id.present) {
      map['area_id'] = Variable<int>(area_id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchAreaModelCompanion(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('area_id: $area_id')
          ..write(')'))
        .toString();
  }
}

class $SearchAreaModelTable extends SearchAreaModel
    with TableInfo<$SearchAreaModelTable, SearchAreaModelData> {
  final GeneratedDatabase _db;
  final String _alias;
  $SearchAreaModelTable(this._db, [this._alias]);
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

  final VerificationMeta _area_idMeta = const VerificationMeta('area_id');
  GeneratedIntColumn _area_id;
  @override
  GeneratedIntColumn get area_id => _area_id ??= _constructAreaId();
  GeneratedIntColumn _constructAreaId() {
    return GeneratedIntColumn(
      'area_id',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, latitude, longitude, area_id];
  @override
  $SearchAreaModelTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'search_area_model';
  @override
  final String actualTableName = 'search_area_model';
  @override
  VerificationContext validateIntegrity(
      Insertable<SearchAreaModelData> instance,
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
    if (data.containsKey('area_id')) {
      context.handle(_area_idMeta,
          area_id.isAcceptableOrUnknown(data['area_id'], _area_idMeta));
    } else if (isInserting) {
      context.missing(_area_idMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchAreaModelData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return SearchAreaModelData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $SearchAreaModelTable createAlias(String alias) {
    return $SearchAreaModelTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $SearchAreaModelTable _searchAreaModel;
  $SearchAreaModelTable get searchAreaModel =>
      _searchAreaModel ??= $SearchAreaModelTable(this);
  SearchAreaDaoImpl _searchAreaDaoImpl;
  SearchAreaDaoImpl get searchAreaDaoImpl =>
      _searchAreaDaoImpl ??= SearchAreaDaoImpl(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [searchAreaModel];
}
