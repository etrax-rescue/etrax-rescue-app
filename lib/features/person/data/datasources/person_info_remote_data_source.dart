import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/person_info_model.dart';

abstract class PersonInfoRemoteDataSource {
  Future<PersonInfoModel> getPersonInfo(Uri uri, String token, String eid);
}

class PersonInfoRemoteDataSourceImpl implements PersonInfoRemoteDataSource {
  final http.Client client;

  PersonInfoRemoteDataSourceImpl({@required this.client});

  @override
  Future<PersonInfoModel> getPersonInfo(
      Uri uri, String token, String eid) async {
    final response =
        await client.post(uri.toString(), body: {'token': token, 'eid': eid});
    if (response.statusCode == 200) {
      PersonInfoModel personInfoModel;
      try {
        personInfoModel = PersonInfoModel.fromJson(json.decode(response.body));
      } on FormatException {
        throw ServerException();
      }
      return personInfoModel;
    } else {
      throw ServerException();
    }
  }
}
