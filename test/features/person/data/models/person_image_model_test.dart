import 'dart:convert';
import 'dart:typed_data';

import 'package:etrax_rescue_app/features/person/data/models/person_image_model.dart';
import 'package:etrax_rescue_app/features/person/domain/entities/person_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  Image tImage;
  Map<String, dynamic> tJson = json.decode(fixture('person_image.json'));
  Uint8List bytes = base64.decode(tJson['image']);
  tImage = new Image.memory(bytes);
  final tPersonImageModel = PersonImageModel(image: tImage);

  test(
    'should be a subclass of PersonImage entity',
    () async {
      // assert
      expect(tPersonImageModel, isA<PersonImage>());
    },
  );

  // TODO: Find a way to properly compare two PersonImageModel instances
  /*
  group('fromJson', () {
    test(
      'should return a valid model when the JSON is a valid base64 encoded jpeg image',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('person_image.json'));
        // act
        final result = PersonImageModel.fromJson(jsonMap);
        // assert
        expect(result, tPersonImageModel);
      },
    );
  });
  */
}
