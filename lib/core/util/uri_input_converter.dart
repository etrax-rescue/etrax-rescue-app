import 'package:dartz/dartz.dart';
import 'package:etrax_rescue_app/core/error/failures.dart';

class UriInputConverter {
  Either<Failure, String> convert(String authorityString) {
    if (authorityString.contains(' ')) {
      return Left(InvalidInputFailure());
    }
    // Removes trailing backslash from uri
    authorityString =
        authorityString.replaceAllMapped(RegExp(r'\/$'), (match) => '');
    Uri uri;
    try {
      uri = Uri.https(authorityString, '');
    } on FormatException {
      return Left(InvalidInputFailure());
    }

    bool valid = uri.isAbsolute && !uri.hasQuery;

    if (!valid) {
      return Left(InvalidInputFailure());
    }

    return Right(authorityString);
  }
}
