import 'package:flutter/foundation.dart';

import '../dependencies.dart';

abstract class Expression<T> {
  T evaluate(Dependencies dependencies);

  @nonVirtual
  V evaluateValue<V>(dynamic value, Dependencies dependencies) {
    if (value is Expression) {
      final result = value.evaluate(dependencies);
      if (result is V) {
        return result;
      }
    } else if (value is V) {
      return value;
    }
    throw Exception("Unexpected type for $value. Was expecting a subclass"
        " of 'Expression<$V>' or '$V'");
  }
}
