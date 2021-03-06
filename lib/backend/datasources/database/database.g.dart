// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class LabeledCoordinateModel extends DataClass
    implements Insertable<LabeledCoordinateModel> {
  final int index;
  final String id;
  final String label;
  final String description;
  final int color;
  final double latitude;
  final double longitude;
  LabeledCoordinateModel(
      {@required this.index,
      @required this.id,
      @required this.label,
      @required this.description,
      this.color,
      @required this.latitude,
      @required this.longitude});
  factory LabeledCoordinateModel.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return LabeledCoordinateModel(
      index: intType.mapFromDatabaseResponse(data['${effectivePrefix}index']),
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      label:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}label']),
      description: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      color: intType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      latitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude']),
      longitude: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || index != null) {
      map['index'] = Variable<int>(index);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    return map;
  }

  LabeledCoordinateModelsCompanion toCompanion(bool nullToAbsent) {
    return LabeledCoordinateModelsCompanion(
      index:
          index == null && nullToAbsent ? const Value.absent() : Value(index),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
    );
  }

  factory LabeledCoordinateModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LabeledCoordinateModel(
      index: serializer.fromJson<int>(json['index']),
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      description: serializer.fromJson<String>(json['description']),
      color: serializer.fromJson<int>(json['color']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'index': serializer.toJson<int>(index),
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'description': serializer.toJson<String>(description),
      'color': serializer.toJson<int>(color),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
    };
  }

  LabeledCoordinateModel copyWith(
          {int index,
          String id,
          String label,
          String description,
          int color,
          double latitude,
          double longitude}) =>
      LabeledCoordinateModel(
        index: index ?? this.index,
        id: id ?? this.id,
        label: label ?? this.label,
        description: description ?? this.description,
        color: color ?? this.color,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
  @override
  String toString() {
    return (StringBuffer('LabeledCoordinateModel(')
          ..write('index: $index, ')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      index.hashCode,
      $mrjc(
          id.hashCode,
          $mrjc(
              label.hashCode,
              $mrjc(
                  description.hashCode,
                  $mrjc(color.hashCode,
                      $mrjc(latitude.hashCode, longitude.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is LabeledCoordinateModel &&
          other.index == this.index &&
          other.id == this.id &&
          other.label == this.label &&
          other.description == this.description &&
          other.color == this.color &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class LabeledCoordinateModelsCompanion
    extends UpdateCompanion<LabeledCoordinateModel> {
  final Value<int> index;
  final Value<String> id;
  final Value<String> label;
  final Value<String> description;
  final Value<int> color;
  final Value<double> latitude;
  final Value<double> longitude;
  const LabeledCoordinateModelsCompanion({
    this.index = const Value.absent(),
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.description = const Value.absent(),
    this.color = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  });
  LabeledCoordinateModelsCompanion.insert({
    this.index = const Value.absent(),
    @required String id,
    @required String label,
    @required String description,
    this.color = const Value.absent(),
    @required double latitude,
    @required double longitude,
  })  : id = Value(id),
        label = Value(label),
        description = Value(description),
        latitude = Value(latitude),
        longitude = Value(longitude);
  static Insertable<LabeledCoordinateModel> custom({
    Expression<int> index,
    Expression<String> id,
    Expression<String> label,
    Expression<String> description,
    Expression<int> color,
    Expression<double> latitude,
    Expression<double> longitude,
  }) {
    return RawValuesInsertable({
      if (index != null) 'index': index,
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }

  LabeledCoordinateModelsCompanion copyWith(
      {Value<int> index,
      Value<String> id,
      Value<String> label,
      Value<String> description,
      Value<int> color,
      Value<double> latitude,
      Value<double> longitude}) {
    return LabeledCoordinateModelsCompanion(
      index: index ?? this.index,
      id: id ?? this.id,
      label: label ?? this.label,
      description: description ?? this.description,
      color: color ?? this.color,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (index.present) {
      map['index'] = Variable<int>(index.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabeledCoordinateModelsCompanion(')
          ..write('index: $index, ')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('description: $description, ')
          ..write('color: $color, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }
}

class $LabeledCoordinateModelsTable extends LabeledCoordinateModels
    with TableInfo<$LabeledCoordinateModelsTable, LabeledCoordinateModel> {
  final GeneratedDatabase _db;
  final String _alias;
  $LabeledCoordinateModelsTable(this._db, [this._alias]);
  final VerificationMeta _indexMeta = const VerificationMeta('index');
  GeneratedIntColumn _index;
  @override
  GeneratedIntColumn get index => _index ??= _constructIndex();
  GeneratedIntColumn _constructIndex() {
    return GeneratedIntColumn('index', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _labelMeta = const VerificationMeta('label');
  GeneratedTextColumn _label;
  @override
  GeneratedTextColumn get label => _label ??= _constructLabel();
  GeneratedTextColumn _constructLabel() {
    return GeneratedTextColumn(
      'label',
      $tableName,
      false,
    );
  }

  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  GeneratedTextColumn _description;
  @override
  GeneratedTextColumn get description =>
      _description ??= _constructDescription();
  GeneratedTextColumn _constructDescription() {
    return GeneratedTextColumn(
      'description',
      $tableName,
      false,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedIntColumn _color;
  @override
  GeneratedIntColumn get color => _color ??= _constructColor();
  GeneratedIntColumn _constructColor() {
    return GeneratedIntColumn(
      'color',
      $tableName,
      true,
    );
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

  @override
  List<GeneratedColumn> get $columns =>
      [index, id, label, description, color, latitude, longitude];
  @override
  $LabeledCoordinateModelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'labeled_coordinate_models';
  @override
  final String actualTableName = 'labeled_coordinate_models';
  @override
  VerificationContext validateIntegrity(
      Insertable<LabeledCoordinateModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('index')) {
      context.handle(
          _indexMeta, index.isAcceptableOrUnknown(data['index'], _indexMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label'], _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description'], _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color'], _colorMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {index};
  @override
  LabeledCoordinateModel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LabeledCoordinateModel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $LabeledCoordinateModelsTable createAlias(String alias) {
    return $LabeledCoordinateModelsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $LabeledCoordinateModelsTable _labeledCoordinateModels;
  $LabeledCoordinateModelsTable get labeledCoordinateModels =>
      _labeledCoordinateModels ??= $LabeledCoordinateModelsTable(this);
  LabeledCoordinateDaoImpl _labeledCoordinateDaoImpl;
  LabeledCoordinateDaoImpl get labeledCoordinateDaoImpl =>
      _labeledCoordinateDaoImpl ??=
          LabeledCoordinateDaoImpl(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [labeledCoordinateModels];
}
