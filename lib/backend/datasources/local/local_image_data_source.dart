import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

abstract class LocalImageDataSource {
  Future<String> takePhoto();
}

class LocalImageDataSourceImpl implements LocalImageDataSource {
  LocalImageDataSourceImpl(this.imagePicker);

  final ImagePicker imagePicker;

  @override
  Future<String> takePhoto() async {
    PickedFile pickedFile = await imagePicker.getImage(
        source: ImageSource.camera, maxWidth: 800, imageQuality: 100);
    if (pickedFile != null) {
      String imagePath = pickedFile.path;
      _fixRotation(imagePath);
      if (imagePath != null) {
        return imagePath;
      }
    }
    throw PlatformException(code: 'No camera photo returned');
  }

  /**
   * On some devices the rotation is only encoded in the exif data of the image,
   * which is properly displayed by the Image viewer plugin, but can cause
   * problems on the server. Also this step compresses the JPEG so that it takes
   * less data when it is being sent to the server.
   */
  void _fixRotation(String imagePath) async {
    final originalFile = File(imagePath);
    List<int> imageBytes = await originalFile.readAsBytes();
    List<int> compressedBytes =
        await FlutterImageCompress.compressWithList(imageBytes, quality: 85);
    await originalFile.writeAsBytes(compressedBytes);
  }
}
