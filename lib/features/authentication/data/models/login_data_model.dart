import 'package:etrax_rescue_app/features/authentication/domain/entities/login_data.dart';
import 'package:flutter/material.dart';

class LoginDataModel extends LoginData {
  LoginDataModel({@required String username, @required String password})
      : super(username: username, password: password);
}
