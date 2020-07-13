import 'package:data_connection_checker/data_connection_checker.dart';
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
        inputConverter: sl(),
        verifyAndStore: sl(),
      ));

  // Use Cases
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

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<UriInputConverter>(() => UriInputConverter());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
