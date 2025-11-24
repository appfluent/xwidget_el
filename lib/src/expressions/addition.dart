import '../dependencies.dart';
import 'expression.dart';

/// Represents an addition operation in the expression language.
///
/// Supports addition between numeric values, strings, and specific
/// combinations of [DateTime] and [Duration].
///
/// Evaluation rules:
/// - If both operands evaluate to `null`, returns `null`.
/// - If one operand is `null`, returns the other operand.
/// - If the left operand is a [DateTime] and the right is a [Duration],
///   returns a new [DateTime] advanced by the duration.
/// - If the left operand is a [Duration] and the right is a [DateTime],
///   returns a new [DateTime] advanced by the duration.
/// - Otherwise, attempts to apply the `+` operator to the evaluated values.
/// - Throws [Exception] if the `+` operator is not applicable to the operand types.
class AdditionExpression extends Expression<dynamic> {
  final dynamic left;
  final dynamic right;

  AdditionExpression(this.left, this.right);

  @override
  dynamic evaluate(Dependencies dependencies) {
    final leftValue = evaluateValue(left, dependencies);
    final rightValue = evaluateValue(right, dependencies);

    if (leftValue == null && rightValue == null) return null;
    if (leftValue == null) return rightValue;
    if (rightValue == null) return leftValue;
    if (leftValue is DateTime && rightValue is Duration) {
      return leftValue.add(rightValue);
    }
    if (leftValue is Duration && rightValue is DateTime) {
      return rightValue.add(leftValue);
    }

    try {
      return leftValue + rightValue;
    } catch(e) {
      throw Exception("Addition is not applicable to types "
          "'${leftValue.runtimeType}' and '${rightValue.runtimeType}'");
    }
  }
}
