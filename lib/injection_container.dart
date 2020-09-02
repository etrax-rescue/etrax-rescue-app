import 'package:background_location/background_location.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/datasources/local/local_app_configuration_data_source.dart';
import 'backend/datasources/local/local_app_connection_data_source.dart';
import 'backend/datasources/local/local_location_data_source.dart';
import 'backend/datasources/local/local_login_data_source.dart';
import 'backend/datasources/local/local_mission_state_data_source.dart';
import 'backend/datasources/local/local_missions_data_source.dart';
import 'backend/datasources/local/local_organizations_data_source.dart';
import 'backend/datasources/local/local_user_roles_data_source.dart';
import 'backend/datasources/local/local_user_states_data_source.dart';
import 'backend/datasources/remote/remote_app_connection_data_source.dart';
import 'backend/datasources/remote/remote_initialization_data_source.dart';
import 'backend/datasources/remote/remote_login_data_source.dart';
import 'backend/datasources/remote/remote_mission_details_data_source.dart';
import 'backend/datasources/remote/remote_mission_state_data_source.dart';
import 'backend/datasources/remote/remote_organizations_data_source.dart';
import 'backend/repositories/app_state_repository.dart';
import 'backend/repositories/initialization_repository.dart';
import 'backend/repositories/location_repository.dart';
import 'backend/repositories/mission_detail_repository.dart';
import 'backend/usecases/clear_location_cache.dart';
import 'backend/usecases/clear_mission_state.dart';
import 'backend/usecases/delete_app_connection.dart';
import 'backend/usecases/fetch_initialization_data.dart';
import 'backend/usecases/get_app_configuration.dart';
import 'backend/usecases/get_app_connection.dart';
import 'backend/usecases/get_authentication_data.dart';
import 'backend/usecases/get_location_history.dart';
import 'backend/usecases/get_location_update_stream.dart';
import 'backend/usecases/get_mission_details.dart';
import 'backend/usecases/get_mission_state.dart';
import 'backend/usecases/get_organizations.dart';
import 'backend/usecases/get_selected_mission.dart';
import 'backend/usecases/get_user_states.dart';
import 'backend/usecases/login.dart';
import 'backend/usecases/logout.dart';
import 'backend/usecases/request_location_permission.dart';
import 'backend/usecases/request_location_service.dart';
import 'backend/usecases/set_app_connection.dart';
import 'backend/usecases/set_selected_mission.dart';
import 'backend/usecases/set_selected_user_role.dart';
import 'backend/usecases/set_selected_user_state.dart';
import 'backend/usecases/start_location_updates.dart';
import 'backend/usecases/stop_location_updates.dart';
import 'core/network/network_info.dart';
import 'frontend/app_connection/bloc/app_connection_bloc.dart';
import 'frontend/check_requirements/cubit/check_requirements_cubit.dart';
import 'frontend/confirmation/bloc/confirmation_bloc.dart';
import 'frontend/home/bloc/home_bloc.dart';
import 'frontend/launch/bloc/launch_bloc.dart';
import 'frontend/login/bloc/login_bloc.dart';
import 'frontend/missions/bloc/missions_bloc.dart';
import 'frontend/state_update/bloc/state_update_bloc.dart';
import 'frontend/util/uri_input_converter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Launch
  // BLoC
  sl.registerFactory<LaunchBloc>(() => LaunchBloc(
        getAppConfiguration: sl(),
        getAppConnection: sl(),
        getAuthenticationData: sl(),
        getMissionState: sl(),
        getOrganizations: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<GetAppConnection>(() => GetAppConnection(sl()));
  sl.registerLazySingleton<GetAuthenticationData>(
      () => GetAuthenticationData(sl()));
  sl.registerLazySingleton<GetOrganizations>(() => GetOrganizations(sl()));
  sl.registerLazySingleton<GetAppConfiguration>(
      () => GetAppConfiguration(sl()));
  sl.registerLazySingleton<GetMissionState>(() => GetMissionState(sl()));

  // Repositories
  sl.registerLazySingleton<AppStateRepository>(() => AppStateRepositoryImpl(
        remoteAppConnectionDataSource: sl(),
        localAppConnectionDataSource: sl(),
        remoteOrganizationsDataSource: sl(),
        localOrganizationsDataSource: sl(),
        remoteLoginDataSource: sl(),
        localLoginDataSource: sl(),
        localMissionStateDataSource: sl(),
        networkInfo: sl(),
        remoteMissionStateDataSource: sl(),
      ));

  sl.registerLazySingleton<InitializationRepository>(() =>
      InitializationRepositoryImpl(
          remoteInitializationDataSource: sl(),
          localMissionsDataSource: sl(),
          localUserRolesDataSource: sl(),
          localUserStatesDataSource: sl(),
          networkInfo: sl(),
          localAppConfigurationDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<RemoteAppConnectionDataSource>(
      () => RemoteAppConnectionDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalAppConnectionDataSource>(
      () => LocalAppConnectionDataSourceImpl(sl()));

  sl.registerLazySingleton<RemoteOrganizationsDataSource>(
      () => RemoteOrganizationsDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalOrganizationsDataSource>(
      () => LocalOrganizationsDataSourceImpl(sl()));

  sl.registerLazySingleton<RemoteLoginDataSource>(
      () => RemoteLoginDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalLoginDataSource>(
      () => LocalLoginDataSourceImpl(sl(), sl()));

  sl.registerLazySingleton<LocalMissionStateDataSource>(
      () => LocalMissionStateDataSourceImpl(sl()));
  sl.registerLazySingleton<RemoteMissionStateDataSource>(
      () => RemoteMissionStateDataSourceImpl(sl()));

  sl.registerLazySingleton<RemoteInitializationDataSource>(
      () => RemoteInitializationDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalAppConfigurationDataSource>(
      () => LocalAppConfigurationDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalUserRolesDataSource>(
      () => LocalUserRolesDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalUserStatesDataSource>(
      () => LocalUserStatesDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalMissionsDataSource>(
      () => LocalMissionsDataSourceImpl(sl()));

  //! Features - App Connection
  // BLoC
  sl.registerFactory<AppConnectionBloc>(() => AppConnectionBloc(
        inputConverter: sl(),
        setAppConnection: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<SetAppConnection>(() => SetAppConnection(sl()));

  //! Features - Authentication
  // BLoC
  sl.registerFactory<LoginBloc>(() => LoginBloc(
        login: sl(),
        getAppConnection: sl(),
        getOrganizations: sl(),
        deleteAppConnection: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<Login>(() => Login(sl()));

  sl.registerLazySingleton<DeleteAppConnection>(
      () => DeleteAppConnection(sl()));

  //! Features - Initialization
  // BLoC
  sl.registerFactory<InitializationBloc>(() => InitializationBloc(
        getAppConnection: sl(),
        getAuthenticationData: sl(),
        fetchInitializationData: sl(),
        logout: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<FetchInitializationData>(
      () => FetchInitializationData(sl()));
  sl.registerLazySingleton<Logout>(() => Logout(sl()));

  //! Features - Confirmation
  // BLoC
  sl.registerFactory<ConfirmationBloc>(() => ConfirmationBloc(
        setSelectedMission: sl(),
        setSelectedUserRole: sl(),
        getAppConnection: sl(),
        getAuthenticationData: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<SetSelectedMission>(() => SetSelectedMission(sl()));
  sl.registerLazySingleton<SetSelectedUserRole>(
      () => SetSelectedUserRole(sl()));

  //! Features - Check Requirements
  // BLoC
  sl.registerFactory<CheckRequirementsCubit>(() => CheckRequirementsCubit(
        getAppConfiguration: sl(),
        getAppConnection: sl(),
        getAuthenticationData: sl(),
        setSelectedUserState: sl(),
        requestLocationPermission: sl(),
        requestLocationService: sl(),
        stopLocationUpdates: sl(),
        startLocationUpdates: sl(),
        getSelectedMission: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<SetSelectedUserState>(
      () => SetSelectedUserState(sl()));

  sl.registerLazySingleton<RequestLocationPermission>(
      () => RequestLocationPermission(sl()));

  sl.registerLazySingleton<GetSelectedMission>(() => GetSelectedMission(sl()));

  sl.registerLazySingleton<RequestLocationService>(
      () => RequestLocationService(sl()));

  sl.registerLazySingleton<StopLocationUpdates>(
      () => StopLocationUpdates(sl()));

  sl.registerLazySingleton<StartLocationUpdates>(
      () => StartLocationUpdates(sl()));

  // Repositories
  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl(
        localLocationDataSource: sl(),
      ));

  // Data Sources
  sl.registerLazySingleton<LocalLocationDataSource>(
      () => LocalLocationDataSourceImpl(sl()));

  //! Features - Update State
  // BLoC
  sl.registerFactory<StateUpdateBloc>(() => StateUpdateBloc(
        getUserStates: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<GetUserStates>(() => GetUserStates(sl()));

  //! Features - Home
  // BLoC
  sl.registerFactory<HomeBloc>(() => HomeBloc(
        clearMissionState: sl(),
        stopLocationUpdates: sl(),
        getLocationUpdateStream: sl(),
        clearLocationCache: sl(),
        getMissionState: sl(),
        getLocationHistory: sl(),
        getMissionDetails: sl(),
        getAppConnection: sl(),
        getAuthenticationData: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<ClearMissionState>(() => ClearMissionState(sl()));
  sl.registerLazySingleton<GetLocationUpdateStream>(
      () => GetLocationUpdateStream(sl()));
  sl.registerLazySingleton<GetLocationHistory>(() => GetLocationHistory(sl()));
  sl.registerLazySingleton<ClearLocationCache>(() => ClearLocationCache(sl()));

  sl.registerLazySingleton<GetMissionDetails>(() => GetMissionDetails(sl()));

  // Repositories
  sl.registerLazySingleton<MissionDetailRepository>(
      () => MissionDetailRepositoryImpl(
            networkInfo: sl(),
            remoteDetailsDataSource: sl(),
          ));

  // Data Sources
  sl.registerLazySingleton<RemoteMissionDetailsDataSource>(
      () => RemoteMissionDetailsDataSourceImpl(sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<UriInputConverter>(() => UriInputConverter());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());
  sl.registerLazySingleton<BackgroundLocation>(() => BackgroundLocation());
}
