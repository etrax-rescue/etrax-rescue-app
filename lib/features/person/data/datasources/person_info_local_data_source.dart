import '../models/person_info_model.dart';

abstract class PersonInfoLocalDataSource {
  Future<PersonInfoModel> getCachedPersonInfo();

  Future<void> cachePersonInfo(PersonInfoModel personInfoToCache);
}
