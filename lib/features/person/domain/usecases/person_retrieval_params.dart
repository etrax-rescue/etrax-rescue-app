import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PersonRetrievalParams extends Equatable {
  final Uri uri;
  final String token;
  final String eid;

  PersonRetrievalParams(
      {@required this.uri, @required this.token, @required this.eid});

  @override
  List<Object> get props => [uri, token];
}
