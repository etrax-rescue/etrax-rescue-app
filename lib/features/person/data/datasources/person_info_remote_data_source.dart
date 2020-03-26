import '../models/person_info_model.dart';

abstract class PersonInfoRemoteDataSource {
  Future<PersonInfoModel> getPersonInfo(String url, String token);
}
