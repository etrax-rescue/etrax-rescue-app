import 'package:etrax_rescue_app/features/person/domain/entities/person_image.dart';
import 'package:meta/meta.dart';

class PersonImageModel extends PersonImage {
  PersonImageModel({
    @required image,
  }) : super(image: image);
}
/*
        Image image;
    if (json.containsKey('image')) {
      try {
        Uint8List bytes = base64.decode(json['image']);
        image = new Image.memory(bytes);
      } on AssertionError {
        // TODO: Implement on assertion error
      }
    }
    */
