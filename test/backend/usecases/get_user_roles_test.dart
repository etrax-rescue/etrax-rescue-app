import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/types/usecase.dart';
import 'package:etrax_rescue_app/backend/types/user_roles.dart';
import 'package:etrax_rescue_app/backend/repositories/initialization_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/get_user_roles.dart';

import '../../reference_types.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  GetUserRoles usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = GetUserRoles(mockInitializationRepository);
  });

  test(
    'should return UserRoleCollection',
    () async {
      // arrange
      when(mockInitializationRepository.getUserRoles())
          .thenAnswer((_) async => Right(tUserRoleCollection));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tUserRoleCollection));
      verify(mockInitializationRepository.getUserRoles());
      verifyNoMoreInteractions(mockInitializationRepository);
    },
  );
}
