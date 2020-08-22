import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/backend/types/usecase.dart';
import '../../../../lib/backend/types/user_states.dart';
import '../../../../lib/backend/domain/repositories/initialization_repository.dart';
import '../../../../lib/backend/domain/usecases/get_user_states.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  GetUserStates usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = GetUserStates(mockInitializationRepository);
  });

  final tID = 42;
  final tName = 'TestMission';
  final tDescription = 'asdf';
  final tLocationAccuracy = 2;
  final tState = UserState(
      id: tID,
      name: tName,
      description: tDescription,
      locationAccuracy: tLocationAccuracy);
  final tStateCollection = UserStateCollection(states: <UserState>[tState]);

  test(
    'should return UserStateCollection',
    () async {
      // arrange
      when(mockInitializationRepository.getUserStates())
          .thenAnswer((_) async => Right(tStateCollection));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tStateCollection));
      verify(mockInitializationRepository.getUserStates());
      verifyNoMoreInteractions(mockInitializationRepository);
    },
  );
}
