import '../dependencies.dart';
import 'expression.dart';

/// Represents a logical AND (`&&`) operation in the expression language.
///
/// Evaluates two boolean expressions and returns `true` only if both
/// operands evaluate to `true`.
///
/// This mirrors the behavior of Dart’s `&&` operator:
/// ```dart
/// left && right
/// ```
///
/// Evaluation rules:
/// - Both [left] and [right] must evaluate to `bool`.
/// - Returns `true` if both operands evaluate to `true`.
/// - Returns `false` if either operand evaluates to `false`.
/// - Throws an [Exception] if either operand does not evaluate to a boolean.
///
/// Example:
/// ```dart
/// final expr = LogicalAndExpression(
///   ConstantExpression<bool>(true),
///   ConstantExpression<bool>(false),
/// );
/// print(expr.evaluate(dependencies)); // -> false
/// ```
class LogicalAndExpression extends Expression<bool> {
  final Expression left;
  final Expression right;

  LogicalAndExpression(this.left, this.right);

  @override
  bool evaluate(Dependencies dependencies) {
    return left.evaluate(dependencies) && right.evaluate(dependencies);
  }
}
