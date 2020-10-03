import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

class AppConnection extends Equatable {
  AppConnection({@required this.host, @required this.basePath});

  final String basePath;
  final String host;

  Uri generateUri({String subPath, Map<String, String> paramMap}) {
    final uri = Uri.parse(p.join(host, basePath ?? '', subPath ?? ''));
    if (paramMap != null) {
      return Uri(
          scheme: uri.scheme,
          host: uri.host,
          path: uri.path,
          port: uri.port,
          queryParameters: paramMap);
    }
    return uri;
  }

  factory AppConnection.fromJson(Map<String, dynamic> json) {
    if (json['host'] == null || json['basePath'] == null)
      throw FormatException();
    return AppConnection(host: json['host'], basePath: json['basePath']);
  }

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'basePath': basePath,
    };
  }

  @override
  List<Object> get props => [host, basePath];
}
