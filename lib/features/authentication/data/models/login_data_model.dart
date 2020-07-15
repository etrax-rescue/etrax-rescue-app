import 'package:flutter/material.dart';

import '../../domain/entities/login_data.dart';

class LoginDataModel extends LoginData {
  LoginDataModel({@required String username, @required String password})
      : super(username: username, password: password);
}
