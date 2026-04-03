import '../dependencies.dart';
import 'expression.dart';

/// Represents a division operation in the expression language.
///
/// Supports division between numeric values and special handling for
/// dividing a [Duration] by an [int].
///
/// Evaluation rules:
/// - If the dividend ([left]) is `null`, throws an [Exception].
/// - If the divisor ([right]) is `null`, throws an [Exception].
/// - If the divisor is a numeric type (`num`) and equals `0`, throws an [Exception].
/// - If the dividend is a [Duration] and the divisor is an [int], returns
///   the result of integer division (`~/`) producing a new [Duration].
/// - Otherwise, attempts to apply the `/` operator to the evaluated values.
/// - Throws an [Exception] if the `/` operator is not applicable to the operand types.
///
/// Example:
/// ```dart
/// final expr = DivisionExpression(ConstantExpression<int>(10), ConstantExpression<int>(2));
/// print(expr.evaluate(dependencies)); // -> 5
///
/// final durationExpr = DivisionExpression(ConstantExpression<Duration>(Duration(hours: 4)),
///                                         ConstantExpression<int>(2));
/// print(durationExpr.evaluate(dependencies)); // -> Duration(hours: 2)
/// ```
class DivisionExpression extends Expression<dynamic> {
  final dynamic left;
  final dynamic right;

  DivisionExpression(this.left, this.right);

  @override
  dynamic evaluate(Dependencies dependencies) {
    final leftValue = evaluateValue(left, dependencies);
    final rightValue = evaluateValue(right, dependencies);

    if (leftValue == null) throw Exception("Dividend cannot be 'null'");
    if (rightValue == null) throw Exception("Divisor cannot be 'null'");
    if (rightValue is num) {
      if (rightValue == 0) throw Exception("Cannot divide by '0'");
      if (leftValue is Duration && rightValue is int) {
        return leftValue ~/ rightValue;
      }
    }

    try {
      return leftValue / rightValue;
    } catch (e) {
      throw Exception(
        "Division is not applicable to types "
        "'${leftValue.runtimeType}' and '${rightValue.runtimeType}'",
      );
    }
  }
}
