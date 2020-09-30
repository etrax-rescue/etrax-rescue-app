import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/types/usecase.dart';
import 'package:etrax_rescue_app/backend/types/user_states.dart';
import 'package:etrax_rescue_app/backend/repositories/initialization_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/get_user_states.dart';

import '../../reference_types.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

void main() {
  GetUserStates usecase;
  MockInitializationRepository mockInitializationRepository;

  setUp(() {
    mockInitializationRepository = MockInitializationRepository();
    usecase = GetUserStates(mockInitializationRepository);
  });

  test(
    'should return UserStateCollection',
    () async {
      // arrange
      when(mockInitializationRepository.getUserStates())
          .thenAnswer((_) async => Right(tUserStateCollection));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, Right(tUserStateCollection));
      verify(mockInitializationRepository.getUserStates());
      verifyNoMoreInteractions(mockInitializationRepository);
    },
  );
}
