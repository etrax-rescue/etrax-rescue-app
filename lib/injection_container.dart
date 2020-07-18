import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/get_app_connection_marked_for_update.dart';
import 'package:etrax_rescue_app/features/app_connection/domain/usecases/mark_app_connection_for_update.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_app_settings_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_missions_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_user_roles_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/local_user_states_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/datasources/remote_initialization_data_source.dart';
import 'package:etrax_rescue_app/features/initialization/data/repositories/initialization_repository_impl.dart';
import 'package:etrax_rescue_app/features/initialization/domain/repositories/initialization_repository.dart';
import 'package:etrax_rescue_app/features/initialization/domain/usecases/fetch_initialization_data.dart';
import 'package:etrax_rescue_app/features/initialization/presentation/bloc/initialization_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/uri_input_converter.dart';
import 'features/app_connection/data/datasources/app_connection_local_datasource.dart';
import 'features/app_connection/data/datasources/app_connection_remote_endpoint_verification.dart';
import 'features/app_connection/data/repositories/app_connection_repository_impl.dart';
import 'features/app_connection/domain/repositories/app_connection_repository.dart';
import 'features/app_connection/domain/usecases/get_app_connection.dart';
import 'features/app_connection/domain/usecases/verify_and_store_app_connection.dart';
import 'features/app_connection/presentation/bloc/app_connection_bloc.dart';
import 'features/authentication/data/datasources/local_authentication_data_source.dart';
import 'features/authentication/data/datasources/remote_login_data_source.dart';
import 'features/authentication/data/repositories/authentication_repository_impl.dart';
import 'features/authentication/domain/repositories/authentication_repository.dart';
import 'features/authentication/domain/usecases/delete_authentication_data.dart';
import 'features/authentication/domain/usecases/get_authentication_data.dart';
import 'features/authentication/domain/usecases/login.dart';
import 'features/authentication/presentation/bloc/authentication_bloc.dart';

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
  sl.registerLazySingleton<AppConnectionRemoteEndpointVerification>(
      () => AppConnectionRemoteEndpointVerificationImpl(sl()));
  sl.registerLazySingleton<AppConnectionLocalDataSource>(
      () => AppConnectionLocalDataSourceImpl(sl()));

  //! Features - Authentication
  // BLoC
  sl.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(
        login: sl(),
        getAppConnection: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<Login>(() => Login(sl()));

  sl.registerLazySingleton<GetAuthenticationData>(
      () => GetAuthenticationData(sl()));

  sl.registerLazySingleton<DeleteAuthenticationData>(
      () => DeleteAuthenticationData(sl()));

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
