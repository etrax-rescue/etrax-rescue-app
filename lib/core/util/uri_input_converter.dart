import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';

class UriInputConverter {
  Either<Failure, String> convert(String str) {
    if (str.contains(' ')) {
      return Left(InvalidInputFailure());
    }
    Uri uri;
    try {
      uri = Uri.parse(str);
    } on FormatException {
      return Left(InvalidInputFailure());
    }

    bool valid = uri.isAbsolute && !uri.hasQuery;

    if (!valid) {
      return Left(InvalidInputFailure());
    }

    if (uri.scheme != 'https') {
      return Left(InvalidInputFailure());
    }
    // Removes trailing backslash from uri
    final newStr = str.replaceAllMapped(RegExp(r'\/$'), (match) => '');
    return Right(newStr);
  }
}
