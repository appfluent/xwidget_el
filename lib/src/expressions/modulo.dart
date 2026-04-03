import '../dependencies.dart';
import 'expression.dart';

/// Represents a modulo (`%`) operation in the expression language.
///
/// Performs remainder division between two operands with type‑specific rules.
///
/// Evaluation rules:
/// - If the dividend ([left]) evaluates to `null`, throws an [Exception].
/// - If the divisor ([right]) evaluates to `null`, throws an [Exception].
/// - Attempts to apply the `%` operator to the evaluated values.
/// - Throws an [Exception] if the `%` operator is not applicable to the
///   operand types.
///
/// Example:
/// ```dart
/// final expr = ModuloExpression(
///   ConstantExpression<int>(10),
///   ConstantExpression<int>(3),
/// );
/// print(expr.evaluate(dependencies)); // -> 1
///
/// final durationExpr = ModuloExpression(
///   ConstantExpression<Duration>(Duration(minutes: 65)),
///   ConstantExpression<Duration>(Duration(hours: 1)),
/// );
/// print(durationExpr.evaluate(dependencies)); // -> Duration(minutes: 5)
/// ```
class ModuloExpression extends Expression<dynamic> {
  final dynamic left;
  final dynamic right;

  ModuloExpression(this.left, this.right);

  @override
  dynamic evaluate(Dependencies dependencies) {
    final leftValue = evaluateValue(left, dependencies);
    final rightValue = evaluateValue(right, dependencies);

    // check null conditions
    if (leftValue == null) throw Exception("Dividend cannot be 'null'");
    if (rightValue == null) throw Exception("Cannot divide by 'null'");

    try {
      return leftValue % rightValue;
    } catch (e) {
      throw Exception(
        "Modulo division is not applicable to types "
        "'${leftValue.runtimeType}' and '${rightValue.runtimeType}'",
      );
    }
  }
}
