import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as p;
import 'package:meta/meta.dart';

class AppConnection extends Equatable {
  final String authority;
  final String basePath;
  AppConnection({@required this.authority, @required this.basePath});

  Uri createUri({String subPath, Map<String, dynamic> paramMap}) {
    if (subPath == null && paramMap == null) {
      return Uri.https(authority, basePath);
    } else if (subPath != null) {
      if (paramMap != null) {
        return Uri.https(authority, p.join(basePath, subPath), paramMap);
      } else {
        return Uri.https(authority, p.join(basePath, subPath));
      }
    }
    return Uri.https(authority, basePath, paramMap);
  }

  @override
  List<Object> get props => [authority, basePath];
}
