import 'package:flutter/material.dart';

import '../../../core/types/app_connection.dart';

class AppConnectionModel extends AppConnection {
  AppConnectionModel({@required String authority, @required String basePath})
      : super(authority: authority, basePath: basePath);

  factory AppConnectionModel.fromJson(Map<String, dynamic> json) {
    return AppConnectionModel(
        authority: json['authority'], basePath: json['basePath']);
  }

  Map<String, dynamic> toJson() {
    return {
      'authority': authority,
      'basePath': basePath,
    };
  }
}
