import '../dependencies.dart';
import 'expression.dart';

/// Represents a negation operation in the expression language.
///
/// Supports both arithmetic and logical negation depending on the operand type.
///
/// Evaluation rules:
/// - If the operand evaluates to `null`, returns `null`.
/// - If the operand is a [num], returns its arithmetic negation (`-value`).
/// - If the operand is a [bool], returns its logical negation (`!value`).
/// - If the operand is a [Duration], returns its arithmetic negation (`-duration`).
/// - Throws an [Exception] if the operand type does not support negation.
///
/// Example:
/// ```dart
/// final numExpr = NegationExpression(ConstantExpression<int>(5));
/// print(numExpr.evaluate(dependencies)); // -> -5
///
/// final boolExpr = NegationExpression(ConstantExpression<bool>(true));
/// print(boolExpr.evaluate(dependencies)); // -> false
///
/// final durationExpr = NegationExpression(ConstantExpression<Duration>(Duration(hours: 2)));
/// print(durationExpr.evaluate(dependencies)); // -> Duration(hours: -2)
/// ```
class NegationExpression extends Expression<dynamic> {
  final dynamic value;

  NegationExpression(this.value);

  @override
  dynamic evaluate(Dependencies dependencies) {
    final evaluated = evaluateValue(value, dependencies);

    // check for null
    if (evaluated == null) return null;

    if (evaluated is num) return -evaluated;
    if (evaluated is bool) return !evaluated;
    if (evaluated is Duration) return -evaluated;

    final evaluatedType = evaluated.runtimeType;
    throw Exception("Negation not applicable to type '$evaluatedType'");
  }
}
