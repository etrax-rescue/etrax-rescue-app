import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';

class UriInputConverter {
  Either<Failure, String> convert(String connectionString) {
    if (connectionString.contains(' ')) {
      return Left(InvalidInputFailure());
    }
    // Removes trailing backslash from uri
    connectionString =
        connectionString.replaceAllMapped(RegExp(r'\/$'), (match) => '');
    Uri uri;
    try {
      uri = Uri.parse(connectionString);
    } on FormatException {
      return Left(InvalidInputFailure());
    }

    if (Uri.encodeFull(uri.authority) != uri.authority) {
      return Left(InvalidInputFailure());
    }

    bool valid = uri.isAbsolute && !uri.hasQuery;

    if (!valid) {
      return Left(InvalidInputFailure());
    }

    return Right(connectionString);
  }
}
