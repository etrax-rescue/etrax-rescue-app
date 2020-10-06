import '../../../core/qr_scanner/qr_scanner.dart';

abstract class LocalBarcodeDataSource {
  Future<String> scanQRCode(
      String cancelText, String flashOnText, String flashOffText);
}

class LocalBarcodeDataSourceImpl implements LocalBarcodeDataSource {
  LocalBarcodeDataSourceImpl(this.scanner);

  final QRScanner scanner;

  @override
  Future<String> scanQRCode(
      String cancelText, String flashOnText, String flashOffText) async {
    return await scanner.scan(cancelText, flashOnText, flashOffText);
  }
}
