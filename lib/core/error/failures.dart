import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class NetworkFailure extends Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class PermissionsFailure extends Failure {}

class VersionFailure extends Failure {}

class InvalidInputFailure extends Failure {}
