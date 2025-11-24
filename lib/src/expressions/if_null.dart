import '../dependencies.dart';
import 'expression.dart';

/// Represents a null‑coalescing (`??`) expression in the expression language.
///
/// An [IfNullExpression] evaluates the [left] operand, and if the result
/// is `null`, it evaluates and returns the [right] operand instead.
///
/// This mirrors the behavior of Dart’s `??` operator:
/// ```dart
/// left ?? right
/// ```
///
/// Evaluation rules:
/// - If [left] evaluates to a non‑null value, that value is returned.
/// - If [left] evaluates to `null`, the result of [right] is returned.
/// - Both operands must be [Expression]s and are evaluated against the
///   provided [Dependencies].
///
/// Example:
/// ```dart
/// final expr = IfNullExpression(
///   ConstantExpression<String?>(null),
///   ConstantExpression<String>("fallback"),
/// );
/// print(expr.evaluate(dependencies)); // -> "fallback"
/// ```
class IfNullExpression extends Expression {
  final Expression left;
  final Expression right;

  IfNullExpression(this.left, this.right);

  @override
  dynamic evaluate(Dependencies dependencies) {
    return left.evaluate(dependencies) ?? right.evaluate(dependencies);
  }
}
