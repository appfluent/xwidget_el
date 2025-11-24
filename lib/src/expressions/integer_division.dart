import '../dependencies.dart';
import 'expression.dart';

/// Represents an integer division (`~/`) operation in the expression language.
///
/// Supports integer division between numeric values and other types that
/// implement the `~/` operator.
///
/// Evaluation rules:
/// - If the dividend ([left]) evaluates to `null`, throws an [Exception].
/// - If the divisor ([right]) evaluates to `null`, throws an [Exception].
/// - Attempts to apply the `~/` operator to the evaluated values.
/// - Throws an [Exception] if the `~/` operator is not applicable to the
///   operand types.
///
/// Example:
/// ```dart
/// final expr = IntegerDivisionExpression(
///   ConstantExpression<int>(10),
///   ConstantExpression<int>(3),
/// );
/// print(expr.evaluate(dependencies)); // -> 3
///
/// final durationExpr = IntegerDivisionExpression(
///   ConstantExpression<Duration>(Duration(hours: 4)),
///   ConstantExpression<int>(2),
/// );
/// print(durationExpr.evaluate(dependencies)); // -> Duration(hours: 2)
/// ```
class IntegerDivisionExpression extends Expression<dynamic> {
  final dynamic left;
  final dynamic right;

  IntegerDivisionExpression(this.left, this.right);

  @override
  dynamic evaluate(Dependencies dependencies) {
    final leftValue = evaluateValue(left, dependencies);
    final rightValue = evaluateValue(right, dependencies);

    // check null conditions
    if (leftValue == null) throw Exception("Dividend cannot be 'null'");
    if (rightValue == null) throw Exception("Divisor cannot be 'null'");

    try {
      return leftValue ~/ rightValue;
    } catch(e) {
      throw Exception("Integer division is not applicable to types "
          "'${leftValue.runtimeType}' and '${rightValue.runtimeType}'");
    }
  }
}
