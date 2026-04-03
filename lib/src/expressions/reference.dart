import '../model/brackets.dart';
import '../dependencies.dart';
import 'dynamic_function.dart';
import 'expression.dart';

/// Represents a reference to a value in the expression language.
///
/// A [ReferenceExpression] allows resolving values dynamically from
/// [Dependencies] or from a provided [data] object, following a path
/// and optional sub‑paths. This enables property access, indexing,
/// and dynamic function invocation within the expression tree.
///
/// Evaluation rules:
/// - If [data] is `null`, the initial value is resolved from
///   [Dependencies.getValue] using [path].
/// - If [data] is non‑null, it is evaluated first.
/// - Iterates through [subPaths] to resolve nested references:
///   - If the sub‑path starts with `"."`:
///     - If the next element is a [String], resolves a property via [PathResolution].
///     - If the next element is a [List], treats it as a dynamic function call
///       and evaluates it using [DynamicFunction].
///     - Otherwise, throws an [Exception].
///   - If the sub‑path starts with `"["` and the next element is an [Expression],
///     evaluates the index and resolves via [PathResolution].
///   - Otherwise, throws an [Exception].
/// - Returns the final resolved value, or `null` if resolution fails.
///
/// Example:
/// ```dart
/// // Resolves a property reference like `user.name`
/// final expr = ReferenceExpression(
///   null,
///   "user",
///   [[".", "name"]],
/// );
/// print(expr.evaluate(dependencies)); // -> value of user.name
///
/// // Resolves a list element like `items[0]`
/// final expr2 = ReferenceExpression(
///   null,
///   "items",
///   [["[", ConstantExpression<int>(0)]],
/// );
/// print(expr2.evaluate(dependencies)); // -> first element of items
///
/// // Resolves a dynamic function call like `text.toUpperCase()`
/// final expr3 = ReferenceExpression(
///   "hello",
///   "",
///   [[".", ["toUpperCase", null, null]]],
/// );
/// print(expr3.evaluate(dependencies)); // -> "HELLO"
/// ```
class ReferenceExpression extends Expression<dynamic> {
  final dynamic data;
  final String path;
  final List<dynamic> subPaths;

  ReferenceExpression(this.data, this.path, this.subPaths);

  @override
  dynamic evaluate(Dependencies dependencies) {
    dynamic value = data == null ? dependencies.getValue(path) : evaluateValue(data, dependencies);

    for (int i = 0; i < subPaths.length && value != null; i++) {
      final next = subPaths[i];
      if (next[0] == ".") {
        if (next[1] is String) {
          value = PathResolution(next[1], false, value).getValue(true);
        } else if (next[1] is List) {
          final func = DynamicFunction(next[1][0], value, next[1][2]);
          value = func.evaluate(dependencies);
        } else {
          throw Exception("Unrecognized reference subpart: ${next[1]}");
        }
      } else if (next[0] == "[" && next[1] is Expression) {
        final index = next[1].evaluate(dependencies);
        value = PathResolution("[$index]", false, value).getValue(true);
      } else {
        throw Exception("Unrecognized reference part: $next");
      }
    }
    return value;
  }
}
