import 'package:barcode_scan/barcode_scan.dart';
import 'package:etrax_rescue_app/core/error/exceptions.dart';

abstract class QRScanner {
  Future<String> scan(
      String cancelText, String flashOnText, String flashOffText);
}

class QRScannerImpl implements QRScanner {
  @override
  Future<String> scan(
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
    } else {
      throw BarcodeException();
    }
  }
}
