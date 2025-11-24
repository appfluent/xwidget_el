import '../dependencies.dart';
import 'expression.dart';

/// Represents a type conversion expression in the expression language.
///
/// A [ConversionExpression] wraps another [Expression] and casts its
/// evaluated result from type [TFrom] to type [TTo].
///
/// This is useful when the grammar or evaluation engine needs to
/// enforce a more specific type at runtime, such as converting a
/// general `Object` or `dynamic` into a narrower type.
///
/// Evaluation rules:
/// - Evaluates the inner [value] expression.
/// - Casts the result to type [TTo].
/// - Throws a [TypeError] at runtime if the cast is invalid.
///
/// Example:
/// ```dart
/// final expr = ConversionExpression<num, int>(ConstantExpression<num>(42));
/// print(expr.evaluate(dependencies)); // -> 42 as int
/// ```
class ConversionExpression<TFrom, TTo extends TFrom> extends Expression<TTo> {
  final Expression<TFrom> value;

  ConversionExpression(this.value);

  @override
  TTo evaluate(Dependencies dependencies) {
    return value.evaluate(dependencies) as TTo;
  }
}
