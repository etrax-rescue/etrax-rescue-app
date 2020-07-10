import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:etrax_rescue_app/common/appconnect/domain/usecases/get_base_uri.dart';
import 'package:etrax_rescue_app/features/authentication/data/datasources/local_authentication_data_source.dart';
import 'package:etrax_rescue_app/features/authentication/data/datasources/remote_login_data_source.dart';
import 'package:etrax_rescue_app/features/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:etrax_rescue_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/delete_authentication_data.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/get_authentication_data.dart';
import 'package:etrax_rescue_app/features/authentication/domain/usecases/login.dart';
import 'package:etrax_rescue_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'common/appconnect/data/datasources/base_uri_local_datasource.dart';
import 'common/appconnect/data/datasources/base_uri_remote_endpoint_verification.dart';
import 'common/appconnect/data/repositories/base_uri_repository_impl.dart';
import 'common/appconnect/domain/repositories/base_uri_repository.dart';
import 'common/appconnect/domain/usecases/verify_and_store_base_uri.dart';
import 'core/network/network_info.dart';
import 'core/util/uri_input_converter.dart';
import 'features/appconnect/presentation/bloc/base_uri_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Link
  // BLoC
  sl.registerFactory<BaseUriBloc>(() => BaseUriBloc(
        inputConverter: sl(),
        verifyAndStore: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<VerifyAndStoreBaseUri>(
      () => VerifyAndStoreBaseUri(sl()));

  sl.registerLazySingleton<GetBaseUri>(() => GetBaseUri(sl()));

  // Repository
  sl.registerLazySingleton<BaseUriRepository>(() => BaseUriRepositoryImpl(
      remoteEndpointVerification: sl(),
      localDataSource: sl(),
      networkInfo: sl()));

  // Data Sources
  sl.registerLazySingleton<BaseUriRemoteEndpointVerification>(
      () => BaseUriRemoteEndpointVerificationImpl(sl()));
  sl.registerLazySingleton<BaseUriLocalDataSource>(
      () => BaseUriLocalDataSourceImpl(sl()));

  //! Features - Authentication
  // BLoC
  sl.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(
        login: sl(),
        getBaseUri: sl(),
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
