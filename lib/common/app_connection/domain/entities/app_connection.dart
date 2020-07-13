import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

class AppConnection extends Equatable {
  final String authority;
  final String basePath;
  AppConnection({@required this.authority, @required this.basePath});

  @override
  List<Object> get props => [authority, basePath];
}
