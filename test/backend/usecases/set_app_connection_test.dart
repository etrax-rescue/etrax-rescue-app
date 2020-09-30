import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/repositories/app_connection_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/set_app_connection.dart';

import '../../reference_types.dart';

class MockAppConnectionRepository extends Mock
    implements AppConnectionRepository {}

void main() {
  SetAppConnection usecase;
  MockAppConnectionRepository mockAppConnectionRepository;

  setUp(() {
    mockAppConnectionRepository = MockAppConnectionRepository();
    usecase = SetAppConnection(mockAppConnectionRepository);
  });

  test(
    'should return None when a valid uri is given',
    () async {
      // arrange
      when(mockAppConnectionRepository.setAppConnection(any, any))
          .thenAnswer((_) async => Right(None()));
      // act
      final result = await usecase(
          AppConnectionParams(authority: tHost, basePath: tBasePath));
      // assert
      expect(result, Right(None()));
      verify(mockAppConnectionRepository.setAppConnection(tHost, tBasePath));
      verifyNoMoreInteractions(mockAppConnectionRepository);
    },
  );
}
