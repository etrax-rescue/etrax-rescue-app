import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:etrax_rescue_app/backend/repositories/app_connection_repository.dart';
import 'package:etrax_rescue_app/backend/usecases/scan_qr_code.dart';

import '../../reference_types.dart';

class MockAppConnectionRepository extends Mock
    implements AppConnectionRepository {}

void main() {
  ScanQrCode usecase;
  MockAppConnectionRepository mockAppConnectionRepository;

  setUp(() {
    mockAppConnectionRepository = MockAppConnectionRepository();
    usecase = ScanQrCode(mockAppConnectionRepository);
  });

  final tCancelText = 'Cancel';
  final tFlashOnText = 'Flash On';
  final tFlashOffText = 'Flash Off';

  final tScanQrCodeParams = ScanQrCodeParams(
    cancelText: tCancelText,
    flashOnText: tFlashOnText,
    flashOffText: tFlashOffText,
  );
  test(
    'should call the scan QR code method of the AppConnectionRepository',
    () async {
      // arrange
      when(mockAppConnectionRepository.scanQRCode(any, any, any))
          .thenAnswer((_) async => Right(tHost));
      // act
      final result = await usecase(tScanQrCodeParams);
      // assert
      expect(result, Right(tHost));
      verify(mockAppConnectionRepository.scanQRCode(
          tCancelText, tFlashOnText, tFlashOffText));
      verifyNoMoreInteractions(mockAppConnectionRepository);
    },
  );
}
