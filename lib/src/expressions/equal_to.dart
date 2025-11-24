import '../dependencies.dart';
import 'expression.dart';

/// Represents an equality comparison (`==`) in the expression language.
///
/// Compares two operands for equality with special handling for
/// `null`, `DateTime`, `String`, and `Enum` values.
///
/// Evaluation rules:
/// - If both operands evaluate to `null`, returns `true`.
/// - If only one operand is `null`, returns `false`.
/// - If both operands are [DateTime], returns `true` if they represent
///   the same moment in time (`isAtSameMomentAs`).
/// - If both operands are [String], compares them lexicographically
///   (`compareTo == 0`).
/// - If the left operand is an [Enum] and the right is a [String],
///   compares the enum’s `.name` to the string.
/// - If the left operand is a [String] and the right is an [Enum],
///   compares the string to the enum’s `.name`.
/// - Otherwise, falls back to the standard `==` operator.
///
/// Example:
/// ```dart
/// final expr = EqualToExpression(ConstantExpression<int>(5), ConstantExpression<int>(5));
/// print(expr.evaluate(dependencies)); // -> true
///
/// final dateExpr = EqualToExpression(
///   ConstantExpression<DateTime>(DateTime.utc(2025, 1, 1)),
///   ConstantExpression<DateTime>(DateTime.utc(2025, 1, 1)),
/// );
/// print(dateExpr.evaluate(dependencies)); // -> true
///
/// final enumExpr = EqualToExpression(MyEnum.value1, ConstantExpression<String>("value1"));
/// print(enumExpr.evaluate(dependencies)); // -> true
/// ```
class EqualToExpression extends Expression<bool> {
  final dynamic left;
  final dynamic right;

  EqualToExpression(this.left, this.right);

  @override
  bool evaluate(Dependencies dependencies) {
    final leftValue = evaluateValue(left, dependencies);
    final rightValue = evaluateValue(right, dependencies);

    // check null conditions
    if (leftValue == null && rightValue == null) return true;
    if (leftValue == null) return false;
    if (rightValue == null) return false;

    if (leftValue is DateTime && rightValue is DateTime) {
      return leftValue.isAtSameMomentAs(rightValue);
    }
    if (leftValue is String && rightValue is String) {
      return leftValue.compareTo(rightValue) == 0;
    }
    if (leftValue is Enum && rightValue is String) {
      return leftValue.name == rightValue;
    }
    if (leftValue is String && rightValue is Enum) {
      return leftValue == rightValue.name;
    }
    return leftValue == rightValue;
  }
}
