import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/data/datasources/local_app_settings_data_source.dart';
import 'backend/data/datasources/local_authentication_data_source.dart';
import 'backend/data/datasources/local_missions_data_source.dart';
import 'backend/data/datasources/local_user_roles_data_source.dart';
import 'backend/data/datasources/local_user_states_data_source.dart';
import 'backend/data/datasources/remote_app_connection_endpoint_verification.dart';
import 'backend/data/datasources/remote_initialization_data_source.dart';
import 'backend/data/datasources/remote_login_data_source.dart';
import 'backend/data/repositories/app_connection_repository_impl.dart';
import 'backend/data/repositories/authentication_repository_impl.dart';
import 'backend/data/repositories/initialization_repository_impl.dart';
import 'backend/domain/repositories/app_connection_repository.dart';
import 'backend/domain/repositories/authentication_repository.dart';
import 'backend/domain/repositories/initialization_repository.dart';
import 'backend/domain/usecases/delete_authentication_data.dart';
import 'backend/domain/usecases/fetch_initialization_data.dart';
import 'backend/domain/usecases/get_app_connection.dart';
import 'backend/domain/usecases/get_app_connection_marked_for_update.dart';
import 'backend/domain/usecases/get_authentication_data.dart';
import 'backend/domain/usecases/get_organizations.dart';
import 'backend/domain/usecases/login.dart';
import 'backend/domain/usecases/mark_app_connection_for_update.dart';
import 'backend/domain/usecases/verify_and_store_app_connection.dart';
import 'core/network/network_info.dart';
import 'frontend/app_connection/bloc/app_connection_bloc.dart';
import 'frontend/authentication/bloc/login_bloc.dart';
import 'frontend/initialization/bloc/initialization_bloc.dart';
import 'frontend/util/uri_input_converter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - App Connection
  // BLoC
  sl.registerFactory<AppConnectionBloc>(() => AppConnectionBloc(
        markedForUpdate: sl(),
        inputConverter: sl(),
        verifyAndStore: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<GetAppConnectionMarkedForUpdate>(
      () => GetAppConnectionMarkedForUpdate(sl()));

  sl.registerLazySingleton<MarkAppConnectionForUpdate>(
      () => MarkAppConnectionForUpdate(sl()));

  sl.registerLazySingleton<VerifyAndStoreAppConnection>(
      () => VerifyAndStoreAppConnection(sl()));

  sl.registerLazySingleton<GetAppConnection>(() => GetAppConnection(sl()));

  // Repository
  sl.registerLazySingleton<AppConnectionRepository>(() =>
      AppConnectionRepositoryImpl(
          remoteEndpointVerification: sl(),
          localDataSource: sl(),
          networkInfo: sl()));

  // Data Sources
  sl.registerLazySingleton<RemoteAppConnectionEndpointVerification>(
      () => RemoteAppConnectionEndpointVerificationImpl(sl()));
  //sl.registerLazySingleton<LocalAppConnectionDataSource>(
  //    () => LocalAppConnectionDataSourceImpl(sl()));

  //! Features - Authentication
  // BLoC
  sl.registerFactory<LoginBloc>(() => LoginBloc(
        login: sl(),
        getAppConnection: sl(),
        getOrganizations: sl(),
        markAppConnectionForUpdate: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<Login>(() => Login(sl()));

  sl.registerLazySingleton<GetAuthenticationData>(
      () => GetAuthenticationData(sl()));

  sl.registerLazySingleton<DeleteAuthenticationData>(
      () => DeleteAuthenticationData(sl()));

  sl.registerLazySingleton<GetOrganizations>(() => GetOrganizations(sl()));

  // Repository
  sl.registerLazySingleton<AuthenticationRepository>(() =>
      AuthenticationRepositoryImpl(
          remoteLoginDataSource: sl(),
          localAuthenticationDataSource: sl(),
          networkInfo: sl()));

  // Data Sources
  sl.registerLazySingleton<RemoteLoginDataSource>(
      () => RemoteLoginDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalAuthenticationDataSource>(
      () => LocalAuthenticationDataSourceImpl(sl()));

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
          localAppSettingsDataSource: sl(),
          localMissionsDataSource: sl(),
          localUserRolesDataSource: sl(),
          localUserStatesDataSource: sl(),
          networkInfo: sl()));

  // Data Sources
  sl.registerLazySingleton<RemoteInitializationDataSource>(
      () => RemoteInitializationDataSourceImpl(sl()));
  sl.registerLazySingleton<LocalAppSettingsDataSource>(
      () => LocalAppSettingsDataSourceImpl(sl()));
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
