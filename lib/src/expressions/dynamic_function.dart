import 'package:logging/logging.dart';
import 'package:petitparser/core.dart';

import '../dependencies.dart';
import '../utils/converters.dart';
import '../utils/formatters.dart';
import '../utils/math.dart';
import '../utils/misc.dart';
import '../utils/validators.dart';
import 'expression.dart';

final _log = Logger("DynamicFunction");
final _registeredFunctions = <String, Function>{};
final _registeredMethodResolvers = <InstanceMethodResolver>[];

/// Resolves a method [name] on a [source] object to a callable [Function].
///
/// Returns `null` to defer resolution to other registered resolvers.
typedef InstanceMethodResolver = Function? Function(String name, dynamic source);

/// Registers a global custom [func] under [name], making it callable from any
/// EL expression as a top-level function (e.g., `${myFunc(arg)}`).
///
/// Resolution order in [getDynamicFunction]: built-in functions take priority,
/// then registered functions, then [Dependencies] entries. Re-registering the
/// same [name] replaces the previous function.
///
/// Functions accept positional arguments only; named parameters are not
/// supported by EL.
///
/// Example:
/// ```dart
/// registerFunction("formatCurrency", (dynamic value) => '\$${value}');
/// ```
/// ```xml
/// <Text data="${formatCurrency(price)}"/>
/// ```
void registerFunction(String name, Function func) {
  _registeredFunctions[name] = func;
}

/// Registers a resolver for instance method dispatch on custom types.
///
/// Resolvers run inside [getDynamicFunctionOn] after the built-in switch falls
/// through, in registration order. The first resolver that returns a non-null
/// [Function] wins. Built-in instance methods always take priority over
/// registered resolvers.
void registerMethodResolver(InstanceMethodResolver resolver) {
  _registeredMethodResolvers.add(resolver);
}

/// Resolves a dynamic function by [name] from the global registry or [dependencies].
///
/// - Matches against a predefined set of built‑in functions (math, converters,
///   validators, misc utilities).
/// - If no built‑in match is found, attempts to resolve from [dependencies].
/// - Throws [Exception] if the function cannot be found.
///
/// Example:
/// ```dart
/// final func = getDynamicFunction("abs", deps);
/// print(func(-5)); // -> 5
/// ```
Function getDynamicFunction(String name, Dependencies dependencies) {
  switch (name) {
    // please maintain alphabetical order
    case "abs":
      return abs;
    case "ceil":
      return ceil;
    case "clamp":
      return clamp;
    case "contains":
      return contains;
    case "containsKey":
      return containsKey;
    case "containsValue":
      return containsValue;
    case "diffDateTime":
      return diffDateTime;
    case "endsWith":
      return endsWith;
    case "first":
      return first;
    case "floor":
      return floor;
    case "formatBytes":
      return formatBytes;
    case "formatCompact":
      return formatCompact;
    case "formatDateTime":
      return formatDateTime;
    case "formatDuration":
      return formatDuration;
    case "formatElapsed":
      return formatElapsed;
    case "formatNumber":
      return formatNumber;
    case "formatOrdinal":
      return formatOrdinal;
    case "formatPercent":
      return formatPercent;
    case "formatPlural":
      return formatPlural;
    case "isBlank":
      return isBlank;
    case "isEmpty":
      return isEmpty;
    case "isFalse":
      return isFalse;
    case "isFalseOrNull":
      return isFalseOrNull;
    case "isNotBlank":
      return isNotBlank;
    case "isNotEmpty":
      return isNotEmpty;
    case "isNotNull":
      return isNotNull;
    case "isNull":
      return isNull;
    case "isTrue":
      return isTrue;
    case "isTrueOrNull":
      return isTrueOrNull;
    case "last":
      return last;
    case "length":
      return length;
    case "logDebug":
      return _log.fine;
    case "matches":
      return matches;
    case "max":
      return max;
    case "min":
      return min;
    case "now":
      return now;
    case "nowUtc":
      return nowUtc;
    case "randomDouble":
      return randomDouble;
    case "randomInt":
      return randomInt;
    case "replaceAll":
      return replaceAll;
    case "replaceFirst":
      return replaceFirst;
    case "round":
      return round;
    case "startsWith":
      return startsWith;
    case "substring":
      return substring;
    case "toBool":
      return toBool;
    case "toColor":
      return toColor;
    case "toDateTime":
      return toDateTime;
    case "toDays":
      return toDays;
    case "toDouble":
      return toDouble;
    case "toDuration":
      return toDuration;
    case "toHours":
      return toHours;
    case "toInt":
      return toInt;
    case "toMillis":
      return toMillis;
    case "toMinutes":
      return toMinutes;
    case "toSeconds":
      return toSeconds;
    case "toString":
      return toString;
    case "tryToBool":
      return tryToBool;
    case "tryToColor":
      return tryToColor;
    case "tryToDateTime":
      return tryToDateTime;
    case "tryToDays":
      return tryToDays;
    case "tryToDouble":
      return tryToDouble;
    case "tryToDuration":
      return tryToDuration;
    case "tryToHours":
      return tryToHours;
    case "tryToInt":
      return tryToInt;
    case "tryToMillis":
      return tryToMillis;
    case "tryToMinutes":
      return tryToMinutes;
    case "tryToSeconds":
      return tryToSeconds;
    default:
      {
        // Check registered functions first
        final registered = _registeredFunctions[name];
        if (registered != null) {
          return registered;
        }

        // Then check dependencies
        final func = dependencies.getValue(name);
        if (func is Function) {
          return func;
        }
      }
  }
  throw Exception("Function '$name' not found.");
}

/// Resolves a dynamic function by [name] on a given [source] object.
///
/// - If [source] is a [Map], looks up the function by key.
/// - Otherwise, attempts to resolve against known methods of the source type
///   (e.g., `String`, `List`, `Set`, `num`).
/// - Returns a callable function or closure wrapping the property.
/// - Throws [Exception] if the function cannot be found.
///
/// Example:
/// ```dart
/// final func = getDynamicFunctionOn("toUpperCase", "hello");
/// print(func()); // -> "HELLO"
/// ```
Function getDynamicFunctionOn(String name, dynamic source) {
  if (source != null) {
    if (source is Map) {
      final func = source[name];
      if (func is Function) {
        return func;
      }
    }
    switch (name) {
      // please maintain alphabetical order
      case "abs":
        return source.abs;
      case "ceil":
        return source.ceil;
      case "compareTo":
        return source.compareTo;
      case "contains":
        return source.contains;
      case "containsKey":
        return source.containsKey;
      case "containsValue":
        return source.containsValue;
      case "difference":
        return source.difference;
      case "elementAt":
        return source.elementAt;
      case "endsWith":
        return source.endsWith;
      case "entries":
        return () => source.entries;
      case "first":
        return () => source.first;
      case "floor":
        return source.floor;
      case "indexOf":
        return source.indexOf;
      case "intersection":
        return source.intersection;
      case "isEmpty":
        return () => source.isEmpty;
      case "isEven":
        return () => source.isEven;
      case "isFinite":
        return () => source.isFinite;
      case "isInfinite":
        return () => source.isInfinite;
      case "isNaN":
        return () => source.isNaN;
      case "isNegative":
        return () => source.isNegative;
      case "isNotEmpty":
        return () => source.isNotEmpty;
      case "isOdd":
        return () => source.isOdd;
      case "keys":
        return () => source.keys;
      case "last":
        return () => source.last;
      case "lastIndexOf":
        return source.lastIndexOf;
      case "length":
        return () => source.length;
      case "matches":
        return source.matches;
      case "padLeft":
        return source.padLeft;
      case "padRight":
        return source.padRight;
      case "replaceAll":
        return source.replaceAll;
      case "replaceFirst":
        return source.replaceFirst;
      case "replaceRange":
        return source.replaceRange;
      case "round":
        return source.round;
      case "runtimeType":
        return () => source.runtimeType;
      case "shuffle":
        return source.shuffle;
      case "single":
        return () => source.single;
      case "split":
        return source.split;
      case "startsWith":
        return source.startsWith;
      case "sublist":
        return source.sublist;
      case "substring":
        return source.substring;
      case "toDouble":
        return source.toDouble;
      case "toInt":
        return source.toInt;
      case "toList":
        return source.toList;
      case "toLowerCase":
        return source.toLowerCase;
      case "toRadixString":
        return source.toRadixString;
      case "toSet":
        return source.toSet;
      case "toString":
        return source.toString;
      case "toUpperCase":
        return source.toUpperCase;
      case "trim":
        return source.trim;
      case "trimLeft":
        return source.trimLeft;
      case "trimRight":
        return source.trimRight;
      case "truncate":
        return source.truncate;
      case "union":
        return source.union;
      case "values":
        return () => source.values;
    }
    // Fall through to registered resolvers for custom types
    for (final resolver in _registeredMethodResolvers) {
      final func = resolver(name, source);
      if (func != null) return func;
    }
  }
  throw Exception("Function '$name' not found.");
}

/// Expression that evaluates another expression string dynamically.
///
/// Wraps an inner [expression] that produces a string, then parses and
/// evaluates that string using the provided [parser].
///
/// Evaluation rules:
/// - Evaluates [expression] to a string.
/// - Parses the string with [parser].
/// - If parsing succeeds, evaluates the resulting expression tree.
/// - Throws [Exception] if parsing fails.
///
/// Example:
/// ```dart
/// final expr = EvalFunction(ConstantExpression("1 + 2"), parser);
/// print(expr.evaluate(deps)); // -> 3
/// ```
class EvalFunction extends Expression<dynamic> {
  final Expression expression;
  final Parser parser;

  EvalFunction(this.expression, this.parser);

  @override
  dynamic evaluate(Dependencies dependencies) {
    final exp = evaluateValue(expression, dependencies);
    if (exp.isNotEmpty) {
      final result = parser.parse(exp);
      if (result is Success) {
        return result.value.evaluate(dependencies);
      } else {
        throw Exception("Failed to evaluate '$exp'. ${result.message}");
      }
    }
  }
}

/// Represents a dynamic function call in the expression language.
///
/// Supports both global functions (via [getDynamicFunction]) and
/// instance methods (via [getDynamicFunctionOn]).
///
/// Evaluation rules:
/// - Resolves the function by [name] from either global registry or [source].
/// - Evaluates any [positionalArgs] before invocation.
/// - Invokes the function using [Function.apply].
///
/// Example:
/// ```dart
/// final expr = DynamicFunction("abs", null, [ConstantExpression(-5)]);
/// print(expr.evaluate(deps)); // -> 5
/// ```
class DynamicFunction extends Expression<dynamic> {
  final String name;
  final dynamic source;
  final List<dynamic>? positionalArgs;
  final Map<Symbol, dynamic>? namedArgs;

  DynamicFunction(this.name, [this.source, this.positionalArgs, this.namedArgs]);

  @override
  dynamic evaluate(Dependencies dependencies) {
    final func = source == null
        ? getDynamicFunction(name, dependencies)
        : getDynamicFunctionOn(name, source);
    final posArgs = _evaluatePositionalArgs(positionalArgs, dependencies);
    return Function.apply(func, posArgs);
  }

  dynamic _evaluatePositionalArgs(List<dynamic>? args, Dependencies dependencies) {
    final evaluated = [];
    if (args != null) {
      for (final arg in args) {
        evaluated.add(arg is Expression ? arg.evaluate(dependencies) : arg);
      }
    }
    return evaluated;
  }
}
