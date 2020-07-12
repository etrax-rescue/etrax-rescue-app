import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

class AppConnection extends Equatable {
  final String baseUri;
  AppConnection({@required this.baseUri});

  @override
  List<Object> get props => [this.baseUri];
}
