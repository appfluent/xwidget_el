import 'package:petitparser/petitparser.dart';

/// Grammar definition for the Expression Language (EL).
///
/// Defines the lexical and syntactic rules used to parse EL expressions.
/// Built on top of [petitparser]'s [GrammarDefinition].
class ELGrammarDefinition extends GrammarDefinition {

  /// Entry point of the grammar.
  ///
  /// Parses a full [expression] followed by end‑of‑input, or falls back
  /// to [failureState] if parsing fails.
  @override
  Parser start() => (ref0(expression).end()).or(ref0(failureState));

  /// Matches the boolean literal `false`.
  Parser boolFalse() =>
      ref1(token, 'false');

  /// Matches the boolean literal `true`.
  Parser boolTrue() =>
      ref1(token, 'true');

  /// Defines the failure state of the grammar.
  ///
  /// Used to capture invalid syntax by attempting to parse an [expression]
  /// followed by [fail], or just [fail].
  Parser failureState() =>
      (ref0(expression).trim() & ref0(fail).trim()) | ref0(fail).trim();

  /// Matches any single character (used for failure recovery).
  Parser fail() => any();

  /// Matches a letter or underscore.
  Parser letterOrUnderscore() =>
      ref0(letter) | ref1(token, '_');

  /// Matches a floating‑point number (digits before and after a decimal point).
  Parser doubleNumber() =>
      ref0(digit) &
      ref0(digit).star() &
      char('.') &
      ref0(digit) &
      ref0(digit).star();

  /// Matches an integer number (sequence of digits).
  Parser integerNumber() =>
      ref0(digit).plus().flatten();

  /// Matches a single‑quoted string literal.
  Parser singleLineString() =>
      char("'") & ref0(stringContent).star() & char("'");

  /// Matches the content inside a single‑quoted string.
  Parser stringContent() =>
      pattern("^'");

  /// Matches a literal value (number, boolean, or string).
  Parser literal() => ref1(
      token,
      ref0(doubleNumber) |
      ref0(integerNumber) |
      ref0(boolTrue) |
      ref0(boolFalse) |
      ref0(singleLineString)
  );

  /// Matches an identifier (letters, underscores, digits).
  Parser identifier() =>
      (ref0(letterOrUnderscore) &
      (ref0(letterOrUnderscore) | ref0(digit)).star()).flatten();

  /// Matches a reference (identifier plus optional subpath).
  Parser reference() =>
      ref0(identifier) & ref0(referenceSubPath);

  /// Matches reference subpaths (array or property access).
  Parser referenceSubPath() =>
      (ref0(arrayReference) | (char('.') & (ref0(functionReference) | ref0(identifier)))).star();

  /// Matches a function reference (identifier followed by parentheses).
  Parser functionReference() =>
      ref0(identifier) &
      ref1(token, '(') &
      ref0(functionParameters).optional() &
      ref1(token, ')');

  /// Matches an array reference (indexing with square brackets).
  Parser arrayReference() =>
      char('[') &
      (ref0(expression) | ref0(reference)) &
      char(']');

  /// Matches a function call (identifier plus parameters).
  Parser function() =>
      ref0(identifier).flatten() &
      ref1(token, '(') &
      ref0(functionParameters).optional() &
      ref1(token, ')');

  /// Matches function parameters (comma‑separated expressions).
  Parser functionParameters() =>
      (ref0(expression) & ref1(token, ',')).star() & ref0(expression);

  /// Matches additive operators (`+` or `-`).
  Parser additiveOperator() => ref1(token, '+') | ref1(token, '-');

  /// Matches relational operators (`>=`, `>`, `<=`, `<`).
  Parser relationalOperator() =>
      ref1(token, '>=') | ref1(token, '>') | ref1(token, '<=') | ref1(token, '<');

  /// Matches equality operators (`==`, `!=`).
  Parser equalityOperator() => ref1(token, '==') | ref1(token, '!=');

  /// Matches multiplicative operators (`*`, `/`, `~/`, `%`).
  Parser multiplicativeOperator() =>
      ref1(token, '*') |
      ref1(token, '/') |
      ref1(token, '~') & ref1(token, '/') |
      ref1(token, '%');

  /// Matches unary negate operators (`-`, `!`).
  Parser unaryNegateOperator() => ref1(token, '-') | ref1(token, '!');

  /// Matches expressions wrapped in parentheses, with optional subpath.
  Parser expressionInParentheses() =>
      ref1(token, '(') &
      ref0(expression) &
      ref1(token, ')') &
      ref0(referenceSubPath);

  /// Top‑level expression rule.
  Parser expression() => ref0(conditionalExpression);

  /// Matches conditional (ternary) expressions.
  Parser conditionalExpression() =>
      ref0(ifNullExpression) &
      (ref1(token, '?') & ref0(expression) & ref1(token, ':') & ref0(expression)).optional();

  /// Matches null‑coalescing expressions (`??`).
  Parser ifNullExpression() =>
      ref0(logicalOrExpression) &
      (ref1(token, '??') & ref0(logicalOrExpression)).star();

  /// Matches logical OR expressions (`||`).
  Parser logicalOrExpression() =>
      ref0(logicalAndExpression) &
      (ref1(token, '||') & ref0(logicalAndExpression)).star();

  /// Matches logical AND expressions (`&&`).
  Parser logicalAndExpression() =>
      ref0(equalityExpression) &
      (ref1(token, '&&') & ref0(equalityExpression)).star();

  /// Matches equality expressions (`==`, `!=`).
  Parser equalityExpression() =>
      ref0(relationalExpression) &
      (ref0(equalityOperator) & ref0(relationalExpression)).optional();

  /// Matches relational expressions (`<`, `<=`, `>`, `>=`).
  Parser relationalExpression() =>
      ref0(additiveExpression) &
      (ref0(relationalOperator) & ref0(additiveExpression)).optional();

  /// Matches additive expressions (`+`, `-`).
  Parser additiveExpression() =>
      ref0(multiplicativeExpression) &
      (ref0(additiveOperator) & ref0(multiplicativeExpression)).star();

  /// Matches multiplicative expressions (`*`, `/`, `%`, `~/`).
  Parser multiplicativeExpression() =>
      ref0(postfixOperatorExpression) &
      (ref0(multiplicativeOperator) & ref0(postfixOperatorExpression)).star();

  /// Matches postfix operator expressions (e.g., nullability).
  Parser postfixOperatorExpression() =>
      ref0(unaryExpression) & (char('!').seq(char('=').not())).optional();

  /// Matches unary expressions (literal, parentheses, function, reference, or negation).
  Parser unaryExpression() =>
      ref0(literal) |
      ref0(expressionInParentheses) |
      ref0(function) |
      ref0(reference) |
      ref0(unaryNegateOperator) & ref0(unaryExpression);

  /// Wraps [input] in a token parser.
  ///
  /// - If [input] is a [Parser], trims and tokenizes it.
  /// - If [input] is a [String], creates a char or string parser.
  /// - If [input] is a parser factory, resolves it via [ref0].
  /// - Throws [ArgumentError] if [input] is invalid.
  Parser token(Object input) {
    if (input is Parser) {
      return input.token().trim();
    } else if (input is String) {
      return token(input.length == 1 ? char(input) : string(input));
    } else if (input is Parser Function()) {
      return token(ref0(input));
    }
    throw ArgumentError.value(input, 'invalid token parser');
  }
}
