import '../dependencies.dart';
import 'expression.dart';

/// Represents a logical OR (`||`) operation in the expression language.
///
/// Evaluates two boolean expressions and returns `true` if either operand
/// evaluates to `true`.
///
/// This mirrors the behavior of Dart’s `||` operator:
/// ```dart
/// left || right
/// ```
///
/// Evaluation rules:
/// - Both [left] and [right] must evaluate to `bool`.
/// - Returns `true` if either operand evaluates to `true`.
/// - Returns `false` only if both operands evaluate to `false`.
/// - Throws an [Exception] if either operand does not evaluate to a boolean.
///
/// Example:
/// ```dart
/// final expr = LogicalOrExpression(
///   ConstantExpression<bool>(true),
///   ConstantExpression<bool>(false),
/// );
/// print(expr.evaluate(dependencies)); // -> true
/// ```
class LogicalOrExpression extends Expression<bool> {
  final Expression left;
  final Expression right;

  LogicalOrExpression(this.left, this.right);

  @override
  bool evaluate(Dependencies dependencies) {
    return left.evaluate(dependencies) || right.evaluate(dependencies);
  }
}
