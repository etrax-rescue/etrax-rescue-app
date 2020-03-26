import 'package:etrax_rescue_app/core/usecases/usecase.dart';
import 'package:etrax_rescue_app/features/person/domain/entities/person_info.dart';
import 'package:etrax_rescue_app/features/person/domain/repositories/person_info_repository.dart';
import 'package:etrax_rescue_app/features/person/domain/usecases/get_person_info.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockPersonInfoRepository extends Mock implements PersonInfoRepository {}

void main() {
  GetPersonInfo usecase;
  MockPersonInfoRepository mockPersonInfoRepository;

  setUp(() {
    mockPersonInfoRepository = MockPersonInfoRepository();
    usecase = GetPersonInfo(mockPersonInfoRepository);
  });

  final tPersonInfo = PersonInfo(
      name: "John Doe",
      lastSeen: DateTime.parse("2020-02-02"),
      description: "Very Average Person");

  final String tUrl = "https://etrax.at/person";
  final String tToken = "0123456789ABCDEF";

  test(
    'should get person info from the repository',
    () async {
      // arrange
      when(mockPersonInfoRepository.getPersonInfo(any, any))
          .thenAnswer((_) async => Right(tPersonInfo));
      // act
      final result = await usecase(UrlTokenParams(url: tUrl, token: tToken));
      // assert
      expect(result, Right(tPersonInfo));
      verify(mockPersonInfoRepository.getPersonInfo(tUrl, tToken));
      verifyNoMoreInteractions(mockPersonInfoRepository);
    },
  );
}
