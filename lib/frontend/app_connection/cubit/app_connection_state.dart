part of 'app_connection_cubit.dart';

enum AppConnectionStatus {
  initial,
  loading,
  ready,
  error,
  success,
}

class AppConnectionState extends Equatable {
  const AppConnectionState({
    @required this.status,
    @required this.connectionString,
    @required this.messageKey,
  });

  final AppConnectionStatus status;
  final String connectionString;
  final String messageKey;

  AppConnectionState.initial()
      : this(
            status: AppConnectionStatus.initial,
            connectionString: null,
            messageKey: '');

  AppConnectionState.success()
      : this(
            status: AppConnectionStatus.success,
            connectionString: null,
            messageKey: '');

  AppConnectionState copyWith({
    AppConnectionStatus status,
    String connectionString,
    String messageKey,
  }) {
    return AppConnectionState(
        status: status ?? this.status,
        connectionString: connectionString ?? this.connectionString,
        messageKey: messageKey);
  }

  @override
  List<Object> get props => [status, messageKey, connectionString];
}
