import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/person_info.dart';
import '../../domain/repositories/person_info_repository.dart';
import '../datasources/person_info_local_data_source.dart';
import '../datasources/person_info_remote_data_source.dart';

class PersonInfoRepositoryImpl implements PersonInfoRepository {
  final PersonInfoRemoteDataSource remoteDataSource;
  final PersonInfoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PersonInfoRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, PersonInfo>> getPersonInfo(
      Uri uri, String token, String eid) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePersonInfo =
            await remoteDataSource.getPersonInfo(uri, token, eid);
        localDataSource.cachePersonInfo(remotePersonInfo);
        return Right(remotePersonInfo);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPersonInfo = await localDataSource.getCachedPersonInfo();
        return Right(localPersonInfo);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
