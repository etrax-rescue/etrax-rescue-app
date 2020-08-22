import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/core/types/usecase.dart';
import '../../../../lib/backend/domain/entities/user_roles.dart';
import '../../../../lib/backend/domain/repositories/initialization_repository.dart';
import '../../../../lib/backend/domain/usecases/get_user_roles.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  GetUserRoles usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = GetUserRoles(mockInitializationRepository);
  });

  final tID = 42;
  final tName = 'operator';
  final tDescription = 'the one who does stuff';
  final tRole = UserRole(id: tID, name: tName, description: tDescription);
  final tRoleCollection = UserRoleCollection(roles: <UserRole>[tRole]);

  test(
    'should return UserRoleCollection',
    () async {
      // arrange
      when(mockInitializationRepository.getUserRoles())
          .thenAnswer((_) async => Right(tRoleCollection));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tRoleCollection));
      verify(mockInitializationRepository.getUserRoles());
      verifyNoMoreInteractions(mockInitializationRepository);
    },
  );
}
