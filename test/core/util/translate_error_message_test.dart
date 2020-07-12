import 'package:etrax_rescue_app/core/util/translate_error_messages.dart';
import 'package:etrax_rescue_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget createTestableAppEnvironment(Widget child) {
  return MediaQuery(
    data: MediaQueryData(),
    child: MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: child,
    ),
  );
}

void main() {
  testWidgets('should return proper messages when a key is given',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        createTestableAppEnvironment(Builder(builder: (BuildContext context) {
      // UNEXPECTED_FAILURE_MESSAGE
      expect(translateErrorMessage(context, UNEXPECTED_FAILURE_MESSAGE_KEY),
          equals(S.of(context).UNEXPECTED_FAILURE_MESSAGE));

      // NETWORK_FAILURE_MESSAGE
      expect(translateErrorMessage(context, NETWORK_FAILURE_MESSAGE_KEY),
          equals(S.of(context).NETWORK_FAILURE_MESSAGE));

      // SERVER_URL_FAILURE_MESSAGE_KEY
      expect(translateErrorMessage(context, SERVER_URL_FAILURE_MESSAGE_KEY),
          equals(S.of(context).SERVER_URL_FAILURE_MESSAGE));

      // SERVER_FAILURE_MESSAGE
      expect(translateErrorMessage(context, SERVER_FAILURE_MESSAGE_KEY),
          equals(S.of(context).SERVER_FAILURE_MESSAGE));

      // CACHE_FAILURE_MESSAGE
      expect(translateErrorMessage(context, CACHE_FAILURE_MESSAGE_KEY),
          equals(S.of(context).CACHE_FAILURE_MESSAGE));

      // INVALID_INPUT_FAILURE_MESSAGE
      expect(translateErrorMessage(context, INVALID_INPUT_FAILURE_MESSAGE_KEY),
          equals(S.of(context).INVALID_INPUT_FAILURE_MESSAGE));

      // LOGIN_FAILURE_MESSAGE
      expect(translateErrorMessage(context, LOGIN_FAILURE_MESSAGE_KEY),
          equals(S.of(context).LOGIN_FAILURE_MESSAGE));

      // default return message
      expect(translateErrorMessage(context, 'garbage'),
          equals(S.of(context).UNEXPECTED_FAILURE_MESSAGE));

      // Dummy return
      return Placeholder();
    })));
  });
}
