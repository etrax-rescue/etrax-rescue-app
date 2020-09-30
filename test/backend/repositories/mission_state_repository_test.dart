import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/datasources/local/local_mission_state_data_source.dart';
import 'package:etrax_rescue_app/backend/datasources/remote/remote_mission_state_data_source.dart';
import 'package:etrax_rescue_app/backend/repositories/mission_state_repository.dart';
import 'package:etrax_rescue_app/core/network/network_info.dart';

class MockLocalMissionStateDataSource extends Mock
    implements LocalMissionStateDataSource {}

class MockRemoteMissionStateDataSource extends Mock
    implements RemoteMissionStateDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MissionStateRepository repository;
  MockLocalMissionStateDataSource mockLocalMissionStateDataSource;
  MockRemoteMissionStateDataSource mockRemoteMissionStateDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalMissionStateDataSource = MockLocalMissionStateDataSource();
    mockRemoteMissionStateDataSource = MockRemoteMissionStateDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = MissionStateRepositoryImpl(
      networkInfo: mockNetworkInfo,
      remoteMissionStateDataSource: mockRemoteMissionStateDataSource,
      localMissionStateDataSource: mockLocalMissionStateDataSource,
    );
  });

  void testOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void testOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }
}
