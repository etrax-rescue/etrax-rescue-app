import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class UrlTokenParams extends Equatable {
  final String url;
  final String token;

  UrlTokenParams({@required this.url, @required this.token});

  @override
  List<Object> get props => [url, token];
}
