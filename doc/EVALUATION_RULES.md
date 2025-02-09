# Expression Evaluation Rules

Below is the operator precedence and associativity table. Operators are executed according
to their precedence level. If two operators share an operand, the operator with higher precedence
will be executed first. If the operators have the same precedence level, it depends on the
associativity. Both the precedence level and associativity can be seen in the table below.

| Level | Operator                       | Category                                                   | Associativity |
|-------|--------------------------------|------------------------------------------------------------|---------------|
| 11    | identifier<br>'string'<br>123  | Primary Expressions (references, string literals, numbers) | N/A           |
| 10    | `()`<br>`[]`<br>`.`            | Function call, scope, array/member access                  | Right-to-left |
| 9     | `-expr`<br>`!expr`             | Unary Prefix (negation, NOT)                               | Left-to-right |
| 8     | `*`<br>`/`<br>`~/`<br>`%`      | Multiplicative Operators                                   | Left-to-right |
| 7     | `+`<br>`-`                     | Additive Operators                                         | Left-to-right |
| 6     | `<`<br>`>`<br>`<=`<br>`>=`     | Relational Operators                                       | Left-to-right |
| 5     | `==`<br>`!=`                   | Equality Operators                                         | Left-to-right |
| 4     | `&&`                           | Logical AND                                                | Left-to-right |
| 3     | <code>&#124;&#124;</code>      | Logical OR                                                 | Left-to-right |
| 2     | `expr1 ?? expr2`               | Null Coalescing (If null)                                  | Left-to-right |
| 1     | `expr ? expr1 : expr2`         | Conditional (ternary) Operator                             | Right-to-left |


**Important Note:** Strings must be enclosed in single quotes ('). Double quotes (") are not
supported at this time.