import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/remote_initialization_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_user_states_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_missions_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_app_settings_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/user_states_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/app_settings_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/models/missions_model.dart';
import 'package:etrax_rescue_app/features/initialization/data/repositories/initialization_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteInitializationDataSource extends Mock
    implements RemoteInitializationDataSource {}

class MockLocalUserStatesDataSource extends Mock
    implements LocalUserStatesDataSource {}

class MockLocalMissionsDataSource extends Mock
    implements LocalMissionsDataSource {}

class MockLocalAppSettingsDataSource extends Mock
    implements LocalAppSettingsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteInitializationDataSource mockRemoteDataSource;
  MockLocalUserStatesDataSource mockLocalUserStatesDataSource;
  MockLocalMissionsDataSource mockLocalMissionsDataSource;
  MockLocalAppSettingsDataSource mockLocalAppSettingsDataSource;
  MockNetworkInfo mockNetworkInfo;
  InitializationRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteInitializationDataSource();
    mockLocalUserStatesDataSource = MockLocalUserStatesDataSource();
    mockLocalMissionsDataSource = MockLocalMissionsDataSource();
    mockLocalAppSettingsDataSource = MockLocalAppSettingsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = InitializationRepositoryImpl(
        remoteInitializationDataSource: mockRemoteDataSource,
        localUserStatesDataSource: mockLocalUserStatesDataSource,
        localAppSettingsDataSource: mockLocalAppSettingsDataSource,
        localMissionsDataSource: mockLocalMissionsDataSource,
        networkInfo: mockNetworkInfo);
  });
}
