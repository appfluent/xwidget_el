import 'package:petitparser/petitparser.dart';

import 'dependencies.dart';
import 'expressions/addition.dart';
import 'expressions/conditional_expression.dart';
import 'expressions/constant_expression.dart';
import 'expressions/division.dart';
import 'expressions/dynamic_function.dart';
import 'expressions/equal_to.dart';
import 'expressions/expression.dart';
import 'expressions/if_null.dart';
import 'expressions/integer_division.dart';
import 'expressions/less_than.dart';
import 'expressions/less_than_or_equal_to.dart';
import 'expressions/logical_and.dart';
import 'expressions/logical_or.dart';
import 'expressions/modulo.dart';
import 'expressions/multiplication.dart';
import 'expressions/negation.dart';
import 'expressions/nullable_to_non_nullable.dart';
import 'expressions/reference.dart';
import 'expressions/subtraction.dart';
import 'grammar.dart';

class ELParser {
  static final _containsExpressions = RegExp(r"\$\{(.*?)}");

  final Parser _parser = ELParserDefinition().build();

  /// Parses a raw expression string into a [Result] using the expression grammar.
  ///
  /// Returns a [Success] if the expression is valid, otherwise a [Failure]
  /// with details about the parsing error.
  Result parse(String expression) {
    return _parser.parse(expression);
  }

  /// Evaluates and replaces embedded EL expressions inside a larger string.
  ///
  /// Example:
  /// ```dart
  /// final parser = ELParser();
  /// parser.evaluateEmbedded("Hello ${1 + 2}");
  /// // -> "Hello 3"
  /// ```
  ///
  /// If [dependencies] are provided, they are passed to each embedded
  /// expression during evaluation.
  String evaluateEmbedded(String input, [Dependencies? dependencies]) {
    // for performance reasons, check input for possible expressions before
    // using a regexp
    if (input.contains("\${")) {
      // possible embedded expression
      return input.replaceAllMapped(_containsExpressions, (Match match) {
        // parse embedded expression
        final value = evaluate(match[1]!, dependencies);
        return value != null ? value.toString() : "";
      });
    }
    return input;
  }

  /// Evaluates a single EL expression string and returns its computed value.
  ///
  /// - If the expression is empty, the original string is returned.
  /// - If parsing succeeds, the resulting [Expression] is evaluated with
  ///   the optional [dependencies].
  /// - If parsing fails, an [Exception] is thrown with details.
  dynamic evaluate(String expression, [Dependencies? dependencies]) {
    if (expression.isEmpty) return expression;
    final result = _parser.parse(expression);
    if (result is Success) return result.value.evaluate(dependencies);
    throw Exception(
      "Failed to parse EL expression "
      "'$expression'. ${result.message}",
    );
  }
}

class ELParserDefinition extends ELGrammarDefinition {
  late Parser _parser;

  /// Builds the root parser for the expression grammar.
  ///
  /// This method initializes and caches the parser instance.
  @override
  Parser build() {
    return _parser = super.build();
  }

  /// Builds a parser from a given [parser] and caches it as the active parser.
  @override
  Parser<T> buildFrom<T>(Parser<T> parser) {
    return _parser = super.buildFrom<T>(parser);
  }

  /// Defines the failure state of the grammar.
  ///
  /// Throws an [Exception] with the last seen symbol when invalid syntax
  /// is encountered.
  @override
  Parser failureState() => super.failureState().map((c) {
    final lastSeenSymbol = (c is List && c.length >= 2) ? c[1] : c;
    throw Exception('Invalid syntax, last seen symbol: {$lastSeenSymbol} ');
  });

  /// Parses additive expressions (`+` and `-`) and maps them to
  /// [AdditionExpression] or [SubtractionExpression].
  @override
  Parser additiveExpression() => super.additiveExpression().map((c) {
    Expression left = c[0];
    for (final item in c[1]) {
      Expression right = item[1];
      if (item[0].value == '+') {
        left = AdditionExpression(left, right);
      } else if (item[0].value == '-') {
        left = SubtractionExpression(left, right);
      } else {
        throw Exception("Unknown additive expression type '${item[0].value}'");
      }
    }
    return left;
  });

  /// Parses multiplicative expressions (`*`, `/`, `%`, `~/`) and maps them to
  /// [MultiplicationExpression], [DivisionExpression], [ModuloExpression],
  /// or [IntegerDivisionExpression].
  @override
  Parser multiplicativeExpression() => super.multiplicativeExpression().map((c) {
    Expression left = c[0];
    for (final item in c[1]) {
      Expression right = item[1];
      if ((item[0] is List) && (item[0][0].value == '~') && (item[0][1].value == '/')) {
        left = IntegerDivisionExpression(left, right);
      } else if (item[0].value == '*') {
        left = MultiplicationExpression(left, right);
      } else if (item[0].value == '/') {
        left = DivisionExpression(left, right);
      } else if (item[0].value == '%') {
        left = ModuloExpression(left, right);
      } else {
        throw Exception(
          "Unknown multiplicative expression type "
          "'${item[0].value}'",
        );
      }
    }
    return left;
  });

  /// Parses expressions wrapped in parentheses and returns a [ReferenceExpression].
  @override
  Parser expressionInParentheses() => super.expressionInParentheses().map((c) {
    return ReferenceExpression(c[1], "", c[3]);
  });

  /// Parses unary expressions (`-` or `!`) and maps them to [NegationExpression].
  @override
  Parser unaryExpression() => super.unaryExpression().map((c) {
    if (c is List && c.length == 2) {
      if (c[0].value == '-' || c[0].value == '!') {
        return NegationExpression(c[1]);
      }
    }
    return c;
  });

  /// Parses postfix operator expressions (e.g., `!` for nullability) and maps
  /// them to [NullableToNonNullableExpression].
  @override
  Parser postfixOperatorExpression() => super.postfixOperatorExpression().map((c) {
    if (c[1] == null) return c[0];
    return NullableToNonNullableExpression(c[0]);
  });

  /// Parses conditional (ternary) expressions (`condition ? trueExpr : falseExpr`)
  /// and maps them to [ConditionalExpression].
  @override
  Parser conditionalExpression() => super.conditionalExpression().map((c) {
    if (c[1] == null) return c[0];
    return ConditionalExpression(c[0], c[1][1], c[1][3]);
  });

  /// Parses null-coalescing expressions (`??`) and maps them to [IfNullExpression].
  @override
  Parser ifNullExpression() => super.ifNullExpression().map((c) {
    Expression expression = c[0];
    for (final item in c[1]) {
      if (item[0].value == '??') {
        expression = IfNullExpression(expression, item[1]);
        continue;
      }
      throw Exception('Unknown if-null expression type');
    }
    return expression;
  });

  /// Parses logical OR expressions (`||`) and maps them to [LogicalOrExpression].
  @override
  Parser logicalOrExpression() => super.logicalOrExpression().map((c) {
    Expression expression = c[0];
    for (final item in c[1]) {
      if (item[0].value == '||') {
        expression = LogicalOrExpression(expression, item[1]);
        continue;
      }
      throw Exception('Unknown logical-or expression type');
    }
    return expression;
  });

  /// Parses logical AND expressions (`&&`) and maps them to [LogicalAndExpression].
  @override
  Parser logicalAndExpression() => super.logicalAndExpression().map((c) {
    Expression expression = c[0];
    for (final item in c[1]) {
      if (item[0].value == '&&') {
        expression = LogicalAndExpression(expression, item[1]);
        continue;
      }
      throw Exception('Unknown logical-and expression type');
    }
    return expression;
  });

  /// Parses equality expressions (`==`, `!=`) and maps them to
  /// [EqualToExpression] or a negated equality.
  @override
  Parser equalityExpression() => super.equalityExpression().map((c) {
    Expression left = c[0];
    if (c[1] == null) return left;

    final item = c[1];
    final right = item[1];
    if (item[0].value == '==') {
      left = EqualToExpression(left, right);
    } else if (item[0].value == '!=') {
      left = NegationExpression(EqualToExpression(left, right));
    }
    return left;
  });

  /// Parses relational expressions (`<`, `<=`, `>`, `>=`) and maps them to
  /// [LessThanExpression] or [LessThanOrEqualToExpression].
  @override
  Parser relationalExpression() => super.relationalExpression().map((c) {
    Expression left = c[0];
    if (c[1] == null) return left;

    final item = c[1];
    final right = item[1];
    if (item[0].value == '<') {
      left = LessThanExpression(left, right);
    } else if (item[0].value == '<=') {
      left = LessThanOrEqualToExpression(left, right);
    } else if (item[0].value == '>') {
      left = LessThanExpression(right, left);
    } else if (item[0].value == '>=') {
      left = LessThanOrEqualToExpression(right, left);
    } else {
      throw Exception("Unknown relational expression type '${item[0].value}'");
    }
    return left;
  });

  // Parses references (variables, identifiers) and maps them to [ReferenceExpression].
  @override
  Parser reference() => super.reference().map((reference) {
    return ReferenceExpression(null, reference[0], reference[1]);
  });

  /// Parses integer literals and maps them to [ConstantExpression<int>].
  @override
  Parser integerNumber() =>
      super.integerNumber().flatten().map((c) => ConstantExpression<int>(int.parse(c)));

  /// Parses double literals and maps them to [ConstantExpression<double>].
  @override
  Parser doubleNumber() =>
      super.doubleNumber().flatten().map((c) => ConstantExpression<double>(double.parse(c)));

  /// Parses single-line string literals and maps them to [ConstantExpression<String>].
  @override
  Parser singleLineString() => super.singleLineString().flatten().map(
    (c) => ConstantExpression<String>(c.substring(1, c.length - 1)),
  );

  // Parses function parameters and returns them as a list of [Expression]s.
  @override
  Parser functionParameters() => super.functionParameters().map((c) {
    final result = <Expression>[];
    for (var i = 0; i < c[0].length; i++) {
      result.add(c[0][i][0]);
    }
    result.add(c[1]);
    return result;
  });

  /// Parses literal values and returns their raw value.
  @override
  Parser literal() => super.literal().map((c) => c.value);

  /// Parses function calls.
  ///
  /// - If the function name is `"eval"`, returns an [EvalFunction].
  /// - Otherwise, returns a [DynamicFunction].
  @override
  Parser function() => super.function().map((c) {
    return c[0] == "eval" ? EvalFunction(c[2][0], _parser) : DynamicFunction(c[0], null, c[2]);
  });

  /// Parses the boolean literal `true` and maps it to [ConstantExpression<bool>]
  @override
  Parser boolTrue() => super.boolTrue().map((c) => ConstantExpression<bool>(c.value == 'true'));

  // Parses the boolean literal `false` and maps it to [ConstantExpression<bool>].
  @override
  Parser boolFalse() => super.boolFalse().map((c) => ConstantExpression<bool>(c.value != 'false'));
}
