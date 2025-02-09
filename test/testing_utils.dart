import 'package:flutter_test/flutter_test.dart';

exceptionStartsWith(String message) {
  return throwsA(isA<Exception>().having((e) => e.toString(), 'message', startsWith(message)));
}