import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

abstract class LocalImageDataSource {
  Future<String> takePhoto();
}

class LocalImageDataSourceImpl implements LocalImageDataSource {
  LocalImageDataSourceImpl(this.imagePicker);

  final ImagePicker imagePicker;

  @override
  Future<String> takePhoto() async {
    PickedFile pickedFile = await imagePicker.getImage(
        source: ImageSource.camera, maxWidth: 1920, imageQuality: 92);
    if (pickedFile != null) {
      String imagePath = pickedFile.path;
      if (imagePath != null) {
        return imagePath;
      }
    }
    throw PlatformException(code: 'No camera photo returned');
  }
}
