import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'common/link/data/datasources/base_uri_local_datasource.dart';
import 'common/link/data/datasources/base_uri_remote_endpoint_verification.dart';
import 'common/link/data/repositories/base_uri_repository_impl.dart';
import 'common/link/domain/repositories/base_uri_repository.dart';
import 'common/link/domain/usecases/verify_and_store_base_uri.dart';
import 'core/network/network_info.dart';
import 'core/util/uri_input_converter.dart';
import 'features/link/presentation/bloc/base_uri_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Link
  // Bloc
  sl.registerFactory<BaseUriBloc>(() => BaseUriBloc(
        inputConverter: sl(),
        verifyAndStore: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton<VerifyAndStoreBaseUri>(
      () => VerifyAndStoreBaseUri(sl()));

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

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<UriInputConverter>(() => UriInputConverter());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
