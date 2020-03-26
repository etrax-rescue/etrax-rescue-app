import 'dart:io';

import 'package:etrax_rescue_app/features/person/data/models/person_image_model.dart';
import 'package:etrax_rescue_app/features/person/domain/entities/person_image.dart';
import 'package:etrax_rescue_app/features/person/domain/entities/person_info.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final imageFile = File('test/fixtures/person.png');
  final tPersonInfoModel = PersonImageModel(
      image: new Image.file(
    imageFile,
    width: 300,
    height: 300,
  ));
  test(
    'should be a subclass of PersonImage entity',
    () async {
      // assert
      expect(tPersonInfoModel, isA<PersonImage>());
    },
  );
}
