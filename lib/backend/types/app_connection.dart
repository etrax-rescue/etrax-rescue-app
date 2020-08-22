import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

class AppConnection extends Equatable {
  final String authority;
  final String basePath;
  AppConnection({@required this.authority, @required this.basePath});

  Uri generateUri({String subPath, Map<String, String> paramMap}) {
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

  factory AppConnection.fromJson(Map<String, dynamic> json) {
    return AppConnection(
        authority: json['authority'], basePath: json['basePath']);
  }

  Map<String, dynamic> toJson() {
    return {
      'authority': authority,
      'basePath': basePath,
    };
  }

  @override
  List<Object> get props => [authority, basePath];
}
