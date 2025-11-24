import '../dependencies.dart';
import 'expression.dart';

/// Represents a subtraction (`-`) operation in the expression language.
///
/// Supports subtraction between numeric values and special handling for
/// subtracting a [Duration] from a [DateTime].
///
/// Evaluation rules:
/// - If both operands evaluate to `null`, returns `null`.
/// - If the left operand is `null` and the right is non‑null, returns the right
///   operand (though this may be reconsidered — see TODO).
/// - If the right operand is `null` and the left is non‑null, returns the left operand.
/// - If the left operand is a [DateTime] and the right operand is a [Duration],
///   returns a new [DateTime] shifted backwards by the duration.
/// - Otherwise, attempts to apply the `-` operator to the evaluated values.
/// - Throws an [Exception] if the `-` operator is not applicable to the
///   operand types.
///
/// Example:
/// ```dart
/// final expr = SubtractionExpression(
///   ConstantExpression<int>(10),
///   ConstantExpression<int>(3),
/// );
/// print(expr.evaluate(dependencies)); // -> 7
///
/// final dateExpr = SubtractionExpression(
///   ConstantExpression<DateTime>(DateTime.utc(2025, 1, 10)),
///   ConstantExpression<Duration>(Duration(days: 5)),
/// );
/// print(dateExpr.evaluate(dependencies)); // -> DateTime.utc(2025, 1, 5)
/// ```
class SubtractionExpression extends Expression<dynamic> {
  final dynamic left;
  final dynamic right;

  SubtractionExpression(this.left, this.right);

  @override
  dynamic evaluate(Dependencies dependencies) {
    final leftValue = evaluateValue(left, dependencies);
    final rightValue = evaluateValue(right, dependencies);

    if (leftValue == null && rightValue == null) return null;
    if (leftValue == null) return rightValue; // TODO: throw exception ?
    if (rightValue == null) return leftValue;
    if (leftValue is DateTime && rightValue is Duration) {
      return leftValue.subtract(rightValue);
    }

    try {
      return leftValue - rightValue;
    } catch(e) {
      throw Exception("Subtraction is not applicable to types "
          "'${leftValue.runtimeType}' and '${rightValue.runtimeType}'");
    }
  }
}
