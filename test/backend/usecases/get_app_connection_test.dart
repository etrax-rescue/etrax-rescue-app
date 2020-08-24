import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/backend/domain/repositories/app_connection_repository.dart';
import '../../../../lib/backend/domain/usecases/get_app_connection.dart';
import '../../../../lib/backend/types/app_connection.dart';
import '../../../../lib/backend/types/usecase.dart';

class MockAppConnectionRepository extends Mock
    implements AppConnectionRepository {}

void main() {
  GetAppConnection usecase;
  MockAppConnectionRepository mockAppConnectionRepository;

  setUp(() {
    mockAppConnectionRepository = MockAppConnectionRepository();
    usecase = GetAppConnection(mockAppConnectionRepository);
  });

  final tBaseUri = AppConnection(authority: 'etrax.at', basePath: 'appdata');

  test(
    'should return a valid base uri',
    () async {
      // arrange
      when(mockAppConnectionRepository.getAppConnection())
          .thenAnswer((_) async => Right(tBaseUri));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tBaseUri));
      verify(mockAppConnectionRepository.getAppConnection());
      verifyNoMoreInteractions(mockAppConnectionRepository);
    },
  );
}
