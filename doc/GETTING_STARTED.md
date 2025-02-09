# Getting Started

Install package.

```shell
flutter pub add xwidget_el
```

Create an ELParser instance.

```dart
final parser = ELParser();
```

Create required dependencies. This may include data, custom functions, and objects needed
for evaluation.

```dart
final dependencies = Dependencies({
  "size" : {
    "width": 300.0,
    "height": 200
  },
  "indexes": [1, 0, 2],
  "users": [
    { "name": "Mike Jones"  },
    { "name": "Sally Smith" }
  ],
  "myFunctions": {
    "func1": (a) => a,
    "func2": (a, b) => [a, b],
  },
});
```
   
Expressions are processed in two distinct steps:

1. **Parsing** – The expression is broken down into its individual components, such as operators,
   operands, and function calls. This step ensures that the structure of the expression
   is well-formed and ready for evaluation.
2. **Evaluation** – The parsed expression is then executed in the context of the provided
   dependencies. This means resolving variable references, applying operators, invoking
   functions, and computing the final result. The evaluation process ensures that the
   expression dynamically adapts to the given data and can react to changes in dependencies
   if needed.

 ```dart
 final result = parser.parse("users[indexes[0]].name + ', ' + users[0].name");
 expect(result.value.evaluate(dependencies), "Sally Smith, Mike Jones");
 ```

 ```dart
 final result = parser.parse("users[4 % length(indexes)].name");
 expect(result.value.evaluate(dependencies), "Sally Smith");
 ```

 ```dart
 final result = parser.parse('size.width > 200');
 expect(result.value.evaluate(dependencies), true);
 ```

There are two convenient methods for parsing and evaluating expressions in a single call:
- `Result evaluate(String, Dependencies)` – Parses and evaluates the expression, returning
  the computed result.

  ```dart
  final result = parser.evalute("users[4 % length(indexes)].name", dependencies);
  expect(result, "Sally Smith");
  ```
    
- `String evaluateEmbedded(String, Dependencies)` – Parses the expression, evaluates it, 
  and embeds the result within the original string.

  ```dart
  final result = parser.evaluteEmbedded("Hello, ${users[4 % length(indexes)].name}", dependencies);
  expect(result, "Hello, Sally Smith");
  ```