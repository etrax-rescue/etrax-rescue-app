import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:etrax_rescue_app/features/person/domain/entities/person_image.dart';
import 'package:etrax_rescue_app/features/person/domain/repositories/person_image_repository.dart';
import 'package:etrax_rescue_app/features/person/domain/usecases/get_person_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockPersonImageRepository extends Mock implements PersonImageRepository {}

void main() {
  GetPersonImage usecase;
  MockPersonImageRepository mockPersonImageRepository;
  setUp(() {
    mockPersonImageRepository = MockPersonImageRepository();
    usecase = GetPersonImage(mockPersonImageRepository);
  });

  final tPersonImage = PersonImage(
      image: Image.memory(base64.decode(fixture('person_image.base64'))));
  final String tUrl = "https://etrax.at/person";
  final String tToken = "0123456789ABCDEF";

  test(
    'should get PersonImage from the repository',
    () async {
      // arrange
      when(mockPersonImageRepository.getPersonImage(any, any))
          .thenAnswer((_) async => Right(tPersonImage));
      // act
      final result = await usecase(UrlTokenParams(url: tUrl, token: tToken));
      // assert
      expect(result, Right(tPersonImage));
      verify(mockPersonImageRepository.getPersonImage(tUrl, tToken));
      verifyNoMoreInteractions(mockPersonImageRepository);
    },
  );
}
