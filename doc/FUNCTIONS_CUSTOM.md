# Custom Functions

Custom functions are user-defined functions that you can add to any `Dependencies` instance.
While they behave similarly to static functions, they are bound to a single
`Dependencies` instance.

It's important to note that custom functions can only accept positional arguments, which
means they cannot use named parameters.

For example:

```dart
// Define a custom function
void greet(String name) {
  return 'Hello, $name!';
}

// Add the custom function to your Dependencies instance
final dependencies = Dependencies();
dependencies.setValue("greet", greet);

// Call 'greet' custom function
final parser = ELParser();
parser.evaluate("greet('Sally')", dependencies) // evaluates to 'Hello, Sally!'
```