import '../dependencies.dart';
import 'expression.dart';

/// Represents a conversion from a nullable expression to a non‑nullable one
/// in the expression language.
///
/// A [NullableToNonNullableExpression] ensures that the wrapped [value]
/// evaluates to a non‑null result. If the result is `null`, it throws an
/// [Exception].
///
/// This is useful when the grammar or evaluation engine requires a
/// non‑nullable type at runtime, enforcing stricter type guarantees.
///
/// Evaluation rules:
/// - Evaluates the inner [value] expression.
/// - If the result is non‑null, returns it.
/// - If the result is `null`, throws an [Exception] indicating that a
///   non‑nullable type was expected.
///
/// Example:
/// ```dart
/// final expr = NullableToNonNullableExpression<String>(
///   ConstantExpression<String?>(null),
/// );
///
/// try {
///   print(expr.evaluate(dependencies));
/// } catch (e) {
///   print(e); // -> Exception: Instance of type String is null and can't be converted to non-nullable
/// }
///
/// final nonNullExpr = NullableToNonNullableExpression<String>(
///   ConstantExpression<String?>("Hello"),
/// );
/// print(nonNullExpr.evaluate(dependencies)); // -> "Hello"
/// ```
class NullableToNonNullableExpression<T> extends Expression<T> {
  final Expression<T?> value;

  NullableToNonNullableExpression(this.value);

  @override
  T evaluate(Dependencies dependencies) {
    var result = value.evaluate(dependencies);
    if (result == null) {
      throw Exception(
        'Instance of type $T is null and can\'t be '
        'converted to non-nullable',
      );
    }
    return result;
  }
}
