import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

abstract class LocalBarcodeDataSource {
  Future<String> scanQRCode(
      String cancelText, String flashOnText, String flashOffText);
}

class LocalBarcodeDataSourceImpl implements LocalBarcodeDataSource {
  @override
  Future<String> scanQRCode(
      String cancelText, String flashOnText, String flashOffText) async {
    final options = ScanOptions(restrictFormat: const [
      BarcodeFormat.qr
    ], strings: {
      'cancel': cancelText,
      'flash_on': flashOnText,
      'flash_off': flashOffText,
    });

    final result = await BarcodeScanner.scan(options: options);

    if (result.type == ResultType.Barcode) {
      return result.rawContent;
    } else if (result.type == ResultType.Cancelled) {
      return '';
    } else {
      throw PlatformException(code: result.rawContent);
    }
  }
}
