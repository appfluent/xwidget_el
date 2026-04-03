import '../dependencies.dart';
import 'expression.dart';

/// Represents a multiplication (`*`) operation in the expression language.
///
/// Supports multiplication between numeric values and special handling for
/// multiplying a [Duration] by a numeric factor.
///
/// Evaluation rules:
/// - If both operands evaluate to `null`, returns `null`.
/// - If one operand is `null` and the other is non‑null, throws an [Exception].
/// - If the left operand is a [num] and the right operand is a [Duration],
///   returns a new [Duration] scaled by the numeric factor.
/// - Otherwise, attempts to apply the `*` operator to the evaluated values.
/// - Throws an [Exception] if the `*` operator is not applicable to the
///   operand types.
///
/// Example:
/// ```dart
/// final expr = MultiplicationExpression(
///   ConstantExpression<int>(6),
///   ConstantExpression<int>(7),
/// );
/// print(expr.evaluate(dependencies)); // -> 42
///
/// final durationExpr = MultiplicationExpression(
///   ConstantExpression<int>(2),
///   ConstantExpression<Duration>(Duration(hours: 1)),
/// );
/// print(durationExpr.evaluate(dependencies)); // -> Duration(hours: 2)
/// ```
class MultiplicationExpression extends Expression<dynamic> {
  final dynamic left;
  final dynamic right;

  MultiplicationExpression(this.left, this.right);

  @override
  dynamic evaluate(Dependencies dependencies) {
    final leftValue = evaluateValue(left, dependencies);
    final rightValue = evaluateValue(right, dependencies);

    if (leftValue == null && rightValue == null) {
      return null;
    }
    if (leftValue == null || rightValue == null) {
      throw Exception("Cannot multiply by 'null'");
    }
    if (leftValue is num && rightValue is Duration) {
      return rightValue * leftValue;
    }

    try {
      return leftValue * rightValue;
    } catch (e) {
      throw Exception(
        "Multiplication is not applicable to types "
        "'${leftValue.runtimeType}' and '${rightValue.runtimeType}'",
      );
    }
  }
}
