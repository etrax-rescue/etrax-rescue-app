// @dart=2.9
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  const ImageView({Key key, @required this.image}) : super(key: key);
  final FileImage image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return FullScreenImagePreview(image: image);
                },
              ),
            );
          },
          child: Hero(
            tag: 'preview',
            child: Image(image: image),
          ),
        ),
      ],
    );
  }
}

class FullScreenImagePreview extends StatelessWidget {
  final FileImage image;
  const FullScreenImagePreview({Key key, @required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: PhotoView(
            imageProvider: image,
            heroAttributes: PhotoViewHeroAttributes(tag: 'preview'),
          ),
        ),
      ),
    );
  }
}
