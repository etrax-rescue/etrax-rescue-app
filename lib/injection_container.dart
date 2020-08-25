import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/datasources/local/local_app_configuration_data_source.dart';
import 'backend/datasources/local/local_app_connection_data_source.dart';
import 'backend/datasources/local/local_login_data_source.dart';
import 'backend/datasources/local/local_mission_state_data_source.dart';
import 'backend/datasources/local/local_missions_data_source.dart';
import 'backend/datasources/local/local_organizations_data_source.dart';
import 'backend/datasources/local/local_user_roles_data_source.dart';
import 'backend/datasources/local/local_user_states_data_source.dart';
import 'backend/datasources/remote/remote_app_connection_data_source.dart';
import 'backend/datasources/remote/remote_initialization_data_source.dart';
import 'backend/datasources/remote/remote_login_data_source.dart';
import 'backend/datasources/remote/remote_organizations_data_source.dart';
import 'backend/repositories/app_state_repository.dart';
import 'backend/repositories/initialization_repository.dart';
import 'backend/usecases/delete_app_connection.dart';
import 'backend/usecases/fetch_initialization_data.dart';
import 'backend/usecases/get_app_connection.dart';
import 'backend/usecases/get_authentication_data.dart';
import 'backend/usecases/get_organizations.dart';
import 'backend/usecases/login.dart';
import 'backend/usecases/set_app_connection.dart';
import 'core/network/network_info.dart';
import 'frontend/app_connection/bloc/app_connection_bloc.dart';
import 'frontend/login/bloc/login_bloc.dart';
import 'frontend/missions/bloc/missions_bloc.dart';
import 'frontend/util/uri_input_converter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - App Connection
  // BLoC
  sl.registerFactory<AppConnectionBloc>(() => AppConnectionBloc(
        inputConverter: sl(),
        setAppConnection: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<SetAppConnection>(() => SetAppConnection(sl()));

  sl.registerLazySingleton<GetAppConnection>(() => GetAppConnection(sl()));

  // Repository
  sl.registerLazySingleton<AppStateRepository>(() => AppStateRepositoryImpl(
        remoteAppConnectionDataSource: sl(),
        localAppConnectionDataSource: sl(),
        remoteOrganizationsDataSource: sl(),
        localOrganizationsDataSource: sl(),
        remoteLoginDataSource: sl(),
        localLoginDataSource: sl(),
        localMissionStateDataSource: sl(),
        networkInfo: sl(),
      ));

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
      () => LocalLoginDataSourceImpl(sl()));

  sl.registerLazySingleton<LocalMissionStateDataSource>(
      () => LocalMissionStateDataSourceImpl(sl()));

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

  sl.registerLazySingleton<GetAuthenticationData>(
      () => GetAuthenticationData(sl()));

  sl.registerLazySingleton<GetOrganizations>(() => GetOrganizations(sl()));

  sl.registerLazySingleton<DeleteAppConnection>(
      () => DeleteAppConnection(sl()));

  //! Features - Initialization
  // BLoC
  sl.registerFactory<InitializationBloc>(() => InitializationBloc(
        getAppConnection: sl(),
        getAuthenticationData: sl(),
        fetchInitializationData: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<FetchInitializationData>(
      () => FetchInitializationData(sl()));

  // Repository
  sl.registerLazySingleton<InitializationRepository>(() =>
      InitializationRepositoryImpl(
          remoteInitializationDataSource: sl(),
          localMissionsDataSource: sl(),
          localUserRolesDataSource: sl(),
          localUserStatesDataSource: sl(),
          networkInfo: sl(),
          localAppConfigurationDataSource: sl()));

  // Data Sources
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

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<UriInputConverter>(() => UriInputConverter());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
