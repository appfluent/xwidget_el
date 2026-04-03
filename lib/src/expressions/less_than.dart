import '../dependencies.dart';
import 'expression.dart';

/// Represents a "less than" (`<`) comparison in the expression language.
///
/// Compares two operands with type‑specific rules:
///
/// Evaluation rules:
/// - If both operands evaluate to `null`, returns `false`.
/// - If the left operand is `null` and the right is non‑null, returns `true`.
/// - If the right operand is `null` and the left is non‑null, returns `false`.
/// - If both operands are [num], performs numeric comparison.
/// - If both operands are [Duration], compares their lengths.
/// - If both operands are [DateTime], returns `true` if the left is before the right.
/// - If both operands are [String], compares them lexicographically (`compareTo < 0`).
/// - Throws [Exception] if the operand types are not supported.
///
/// Example:
/// ```dart
/// final expr = LessThanExpression(ConstantExpression<int>(3), ConstantExpression<int>(5));
/// print(expr.evaluate(dependencies)); // -> true
///
/// final dateExpr = LessThanExpression(
///   ConstantExpression<DateTime>(DateTime.utc(2025, 1, 1)),
///   ConstantExpression<DateTime>(DateTime.utc(2025, 12, 31)),
/// );
/// print(dateExpr.evaluate(dependencies)); // -> true
///
/// final strExpr = LessThanExpression(
///   ConstantExpression<String>("apple"),
///   ConstantExpression<String>("banana"),
/// );
/// print(strExpr.evaluate(dependencies)); // -> true
/// ```
class LessThanExpression extends Expression<bool> {
  final dynamic left;
  final dynamic right;

  LessThanExpression(this.left, this.right);

  @override
  bool evaluate(Dependencies dependencies) {
    final leftValue = evaluateValue(left, dependencies);
    final rightValue = evaluateValue(right, dependencies);

    // check null conditions
    if (leftValue == null && rightValue == null) return false;
    if (leftValue == null) return true;
    if (rightValue == null) return false;

    if (leftValue is num && rightValue is num) {
      return leftValue < rightValue;
    }
    if (leftValue is Duration && rightValue is Duration) {
      return leftValue < rightValue;
    }
    if (leftValue is DateTime && rightValue is DateTime) {
      return leftValue.isBefore(rightValue);
    }
    if (leftValue is String && rightValue is String) {
      return leftValue.compareTo(rightValue) < 0;
    }

    final leftType = leftValue.runtimeType;
    final rightType = rightValue.runtimeType;
    throw Exception(
      "Less-Than comparison not applicable to types "
      "'$leftType' and '$rightType'",
    );
  }
}
