import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

class BaseUri extends Equatable {
  final String baseUri;
  BaseUri({@required this.baseUri});

  @override
  List<Object> get props => [this.baseUri];
}
