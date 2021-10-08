// @dart=2.9
import 'package:flutter/widgets.dart';

@immutable
class CustomMaterialIconsData extends IconData {
  const CustomMaterialIconsData(int codePoint)
      : super(
          codePoint,
          fontFamily: 'CustomMaterialIcons',
        );
}

@immutable
class CustomMaterialIcons {
  CustomMaterialIcons._();

  // Generated code: do not hand-edit.
  static const IconData logout = CustomMaterialIconsData(0xe000);

  static const IconData noList = CustomMaterialIconsData(0xe001);

  static const IconData qrCodeScanner = CustomMaterialIconsData(0xe002);
}
