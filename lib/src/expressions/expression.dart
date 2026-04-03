import 'package:flutter/foundation.dart';

import '../dependencies.dart';

/// Base class for all expressions in the expression language.
///
/// An [Expression] represents a node in the expression tree that can be
/// evaluated against a set of [Dependencies]. Subclasses implement specific
/// operations such as arithmetic, logical, or constant values.
///
/// Type parameter [T] defines the type of value the expression produces
/// when evaluated.
///
/// Example:
/// ```dart
/// class ConstantExpression<T> extends Expression<T> {
///   final T value;
///   ConstantExpression(this.value);
///
///   @override
///   T evaluate(Dependencies dependencies) => value;
/// }
///
/// final expr = ConstantExpression<int>(42);
/// print(expr.evaluate(dependencies)); // -> 42
/// ```
abstract class Expression<T> {
  /// Evaluates this expression using the provided [dependencies].
  ///
  /// Subclasses must implement this method to define how the expression
  /// computes its value.
  T evaluate(Dependencies dependencies);

  /// Evaluates a dynamic [value] into a strongly typed result of type [V].
  ///
  /// - If [value] is itself an [Expression], it is evaluated recursively.
  /// - If the evaluated result matches type [V], it is returned.
  /// - If [value] is already of type [V], it is returned directly.
  /// - Throws an [Exception] if the value cannot be converted to type [V].
  ///
  /// This method is useful for safely unwrapping nested expressions or
  /// dynamic values into the expected type.
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
    throw Exception(
      "Unexpected type for $value. Was expecting a subclass"
      " of 'Expression<$V>' or '$V'",
    );
  }
}
