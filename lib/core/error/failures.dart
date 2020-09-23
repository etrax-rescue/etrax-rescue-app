import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class NetworkFailure extends Failure {}

class ServerConnectionFailure extends Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class InvalidInputFailure extends Failure {}

class LoginFailure extends Failure {}

class AuthenticationFailure extends Failure {}

class PlatformFailure extends Failure {}

class UnknownFailure extends Failure {}
