import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/error/failures.dart';
import '../repositories/app_connection_repository.dart';
import '../types/usecase.dart';

class ScanQrCode extends UseCase<String, ScanQrCodeParams> {
  final AppConnectionRepository repository;
  ScanQrCode(this.repository);

  @override
  Future<Either<Failure, String>> call(ScanQrCodeParams params) async {
    return await repository.scanQRCode(
        params.cancelText, params.flashOnText, params.flashOffText);
  }
}

class ScanQrCodeParams extends Equatable {
  final String cancelText;
  final String flashOnText;
  final String flashOffText;

  ScanQrCodeParams({
    @required this.cancelText,
    @required this.flashOnText,
    @required this.flashOffText,
  });

  @override
  List<Object> get props => [cancelText, flashOnText, flashOffText];
}
