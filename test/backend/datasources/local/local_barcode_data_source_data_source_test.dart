import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/datasources/local/local_barcode_data_source.dart';
import 'package:etrax_rescue_app/core/qr_scanner/qr_scanner.dart';

import '../../../reference_types.dart';

class MockQrScanner extends Mock implements QRScanner {}

void main() {
  LocalBarcodeDataSource dataSource;
  MockQrScanner mockQrScanner;
  setUp(() {
    mockQrScanner = MockQrScanner();
    dataSource = LocalBarcodeDataSourceImpl(mockQrScanner);
  });

  final tCancelText = 'Cancel';
  final tFlashOnText = 'Flash On';
  final tFlashOffText = 'Flash Off';

  test(
    'should call the QRScanner',
    () async {
      // arrange
      when(mockQrScanner.scan(any, any, any)).thenAnswer((_) async => tHost);
      // act
      await dataSource.scanQRCode(tCancelText, tFlashOnText, tFlashOffText);
      // assert
      verify(mockQrScanner.scan(tCancelText, tFlashOnText, tFlashOffText));
    },
  );

  test(
    'should return the URL that is provided by the QR scanner',
    () async {
      // arrange
      when(mockQrScanner.scan(any, any, any)).thenAnswer((_) async => tHost);
      // act
      final result =
          await dataSource.scanQRCode(tCancelText, tFlashOnText, tFlashOffText);
      // assert
      expect(result, tHost);
    },
  );
}
