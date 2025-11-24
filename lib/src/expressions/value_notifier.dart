import 'package:flutter/foundation.dart';

import '../dependencies.dart';
import 'expression.dart';

/// Represents an expression that wraps a [ValueNotifier] in the expression language.
///
/// A [ValueNotifierExpression] allows reactive values to be integrated into
/// the expression system. It evaluates to the current value held by the
/// [ValueNotifier].
///
/// This is particularly useful in Flutter applications where state changes
/// are tracked via [ValueNotifier], enabling the expression tree to respond
/// to dynamic updates.
///
/// Evaluation rules:
/// - Returns the current `value.value` from the wrapped [ValueNotifier].
/// - The result updates automatically whenever the [ValueNotifier] changes,
///   though evaluation must be re‑invoked to reflect the new value.
///
/// Example:
/// ```dart
/// final notifier = ValueNotifier<int>(10);
/// final expr = ValueNotifierExpression<int>(notifier);
///
/// print(expr.evaluate(dependencies)); // -> 10
///
/// notifier.value = 42;
/// print(expr.evaluate(dependencies)); // -> 42
/// ```
class ValueNotifierExpression<T> extends Expression<T> {
  final ValueNotifier<T> value;

  ValueNotifierExpression(this.value);

  @override
  T evaluate(Dependencies dependencies) {
    return value.value;
  }
}
