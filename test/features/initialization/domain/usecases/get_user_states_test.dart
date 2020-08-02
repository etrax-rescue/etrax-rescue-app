import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/types/usecase.dart';
import 'package:etrax_rescue_app/features/initialization/domain/entities/user_states.dart';
import 'package:etrax_rescue_app/features/initialization/domain/repositories/initialization_repository.dart';
import 'package:etrax_rescue_app/features/initialization/domain/usecases/get_user_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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
  final tState = UserState(id: tID, name: tName, description: tDescription);
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
