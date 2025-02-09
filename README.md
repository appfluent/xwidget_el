<!-- This file was generated. Run 'dart run tool/markdown.dart -i doc/README.md -o README.md' to update this file. -->

<!-- #include HEADER.md -->
<p align="center">
    <img src="https://raw.githubusercontent.com/appfluent/xwidget_el/main/doc/assets/xwidget_el_logo_full.png"
        alt="XWidget EL Logo"
        height="100"
    />
</p>
<!-- // end of #include -->

<!-- #include INTRO.md -->
# What is XWidget EL

XWidget EL is a powerful expression language that enables dynamic evaluation of expressions
within a structured data model. It supports arithmetic, logical, conditional, relational
operators, and functions, allowing for complex calculations and decision-making.

Beyond evaluation, it supports model change notifications and model transformations,
ensuring data-driven applications stay responsive, making it ideal for UI updates, workflow
automation, reactive processing, real-time computation, and dynamic content adaptation.
<!-- // end of #include -->

<!-- #include GETTING_STARTED.md -->
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
<!-- // end of #include -->

<!-- #include EVALUATION_RULES.md -->
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
<!-- // end of #include -->

<!-- #include FUNCTIONS_STATIC.md -->
# Static Functions

These functions are universally accessible within every EL (Expression Language) expression,
providing powerful tools for manipulation and evaluation. They are designed to accept other
expressions as arguments, enabling dynamic and flexible computation. This allows for the creation
of complex expressions by combining multiple functions and expressions, enhancing the overall
functionality and usability of EL in various contexts.

List of static functions:

```dart
num abs(dynamic value);
int ceil(dynamic value);
bool contains(dynamic value, dynamic searchValue);
bool containsKey(Map? map, dynamic searchKey);
bool containsValue(Map? map, dynamic searchValue);
Duration diffDateTime(DateTime left, DateTime right);
bool endsWith(String value, String searchValue);
dynamic eval(String? value);
dynamic first(dynamic value);
int floor(dynamic value);
String formatDateTime(String format, DateTime dateTime);
String? formatDuration(Duration? value, [String precision = "s", DurationFormat? format = defaultDurationFormat]);
bool isBlank(dynamic value);
bool isEmpty(dynamic value);
bool isFalseOrNull(dynamic value);
bool isNotBlank(dynamic value);
bool isNotEmpty(dynamic value);
bool isNotNull(dynamic value);
bool isNull(dynamic value);
bool isTrueOrNull(dynamic value);
dynamic last(dynamic value);
int length(dynamic value);
void logDebug(dynamic message);
bool matches(String value, String regExp);
DateTime now();
DateTime nowInUtc();
double randomDouble();
int randomInt(int max);
String replaceAll(String value, String regex, String replacement);
String replaceFirst(String value, String regex, String replacement, [int startIndex = 0]);
int round(dynamic value);
bool startsWith(String value, String searchValue);
String substring(String value, int start, [int end = -1]);
bool? toBool(dynamic value);
Color? toColor(dynamic value);
DateTime? toDateTime(dynamic value);
int? toDays(dynamic value);
double? toDouble(dynamic value);
Duration? toDuration(dynamic value, [String? intUnit]);
int? toHours(dynamic value);
int? toInt(dynamic value);
int? toMillis(dynamic value);
int? toMinutes(dynamic value);
int? toSeconds(dynamic value);
String? toString(dynamic value);
bool tryToBool(dynamic value);
Color? tryToColor(dynamic value);
DateTime? tryToDateTime(dynamic value);
int? tryToDays(dynamic value);
double? tryToDouble(dynamic value);
Duration? tryToDuration(dynamic value, [String? intUnit]);
int? tryToHours(dynamic value);
int? tryToInt(dynamic value);
int? tryToMillis(dynamic value);
int? tryToMinutes(dynamic value);
int? tryToSeconds(dynamic value);
String? tryToString(dynamic value);
```
A few examples:

```dart
final parser = ELParser();

// Absolute Value - Returns 42
parser.evaluate("abs(-42)");

// Rounding a Number - Returns 4
parser.evaluate("round(3.7)");

// Checking if a String Contains a Substring - Returns true
parser.evaluate("contains('Hello, World!', 'World')");

// Getting Current Date and Time - Returns the current date and time
parser.evaluate("now()");

// Formatting a Date - Returns current date in YYYY-MM-DD format
parser.evaluate("formatDateTime('yyyy-MM-dd', now())");

// Checking if a Collection is Empty - Returns true if myList is empty
parser.evaluate("isEmpty(myList)", dependencies);

// Generating a Random Integer - Returns a random integer between 0 and 99
parser.evaluate("randomInt(100)");

// Replacing a Substring - Returns 'I love programming'
parser.evaluate("replaceAll('I enjoy programming', 'enjoy', 'love')");

// Checking if a String Starts With a Substring - Returns true
parser.evaluate("startsWith('Dart is fun', 'Dart')");

// Converting to Integer - Returns 123
parser.evaluate("toInt('123')");

// Getting the Length of a String - Returns 5
parser.evaluate("length('Hello')");

// Evaluating an Expression - Returns 4
parser.evaluate("eval('2 + 2')");
```
<!-- // end of #include -->

<!-- #include FUNCTIONS_INSTANCE.md -->
# Instance Functions

In addition to using static functions, you can call instance functions on references and
expressions. This allows you to access and manipulate their properties dynamically.
Instance functions operate on specific instances of a class and can provide more tailored
behavior based on the object's state.

Please note that not all instance functions are supported. If you attempt to call a function
that does not exist on an object, a `NoSuchMethodError` will be thrown. To help you navigate
this limitation, below is a curated list of supported instance functions:

```dart
// alphabetical order
T abs();
int ceil();
int compareTo(T other);
bool contains(E element);
bool containsKey(K key);
bool containsValue(V value);
Set<E> difference(Set<Object> other);
E elementAt(int index);
bool endsWith(String other);
Iterable<MapEntry<K, V>> entries;
E first();
int floor();
int indexOf(E element, [int start = 0]);
Set<E> intersection(Set<Object> other);
bool isEmpty();
bool isEven();
bool isFinite();
bool isInfinite();
bool isNaN();
bool isNegative();
bool isNotEmpty();
bool isOdd();
Iterable<K> keys();
E last();
int lastIndexOf(E element, [int start]);
int length();
Iterable<RegExpMatch> matches(String input);
String padLeft(int width, [String padding = ' ']);
String padRight(int width, [String padding = ' ']);
String replaceAll(Pattern from, String replace);
String replaceFirst(Pattern from, String replace, [int startIndex = 0]);
String replaceRange(int start, int end, String replacement);
int round();
Type runtimeType();
void shuffle([Random? random]);
E single();
List<String> split(Pattern pattern);
bool startsWith(String other, [int index = 0]);
List<E> sublist(int start, [int? end]);
String substring(int start, [int? end]);
double toDouble();
int toInt();
List<E> toList({bool growable = true});
String toLowerCase();
String toRadixString(int radix);
Set<E> toSet();
String toString();
String toUpperCase();
String trim();
String trimLeft();
String trimRight();
int truncate();
Set<E> union(Set<E> other);
Iterable<V> values();
```
A few examples:

```dart
final parser = ELParser();

// List Operations - Returns the number of elements in myList
parser.evaluate("myList.length()", dependencies);

// Map Access - checks if 'key1' exists in myMap
parser.evaluate("myMap.containsKey('key1')", dependencies);

// String Manipulation - Concatenation and uppercase conversion
parser.evaluate("(person.firstName + ' ' + person.lastName).toUpperCase()", dependencies);
```
<!-- // end of #include -->

<!-- #include FUNCTIONS_CUSTOM.md -->
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
<!-- // end of #include -->

<!-- #include DEPENDENCIES.md -->
# Dependencies

The Dependencies class provides a structured and dynamic way to store and manage data, objects,
and functions used in expression evaluation. At its core, it functions as a flexible key-value map,
allowing nested data access via dot and bracket notation. Reads automatically resolve to null if
a collection does not exist, while writes create the necessary structures. This makes handling
complex data models seamless and intuitive.

Beyond standard mapping behavior, Dependencies supports global data that can be shared across
instances, simplifying cross-component communication. It also integrates with listeners to
enable UI updates when data changes, making it a powerful tool for reactive applications.
Additionally, while Dependencies supports the bracket operator ([]), it maintains ordinary
map behavior, ensuring compatibility with traditional Dart collections.

## Dot/Bracket Notation

Values can be referenced using dot/bracket notation for easy access to nested collections. Nulls
are handled automatically. If the underlying collection does not exist, reads will resolve to
null and writes will create the appropriate collections and store the data.

```dart
// example using setValue
final dependencies = Dependencies();
dependencies.setValue("users[0].name", "John Flutter");
dependencies.setValue("users[0].email", "name@example.com");

print(dependencies.getValue("users"));
```
Or you could use the constructor:
```dart
// example setting values via Dependencies constructor
final dependencies = Dependencies({
  "users[0].name": "John Flutter",
  "users[0].email": "name@example.com"
});

print(dependencies.getValue("users"));
```
**Note:** The Dependencies class supports the bracket operator ([]) directly, i.e.
`dependencies[<key>]`, however, it functions like a standard map, without the advanced features 
provided by `getValue` and `setValue`.

## Global Data

Sometimes you just need to access data from multiple parts of an application without a lot
of fuss. Global data are accessible across all ```Dependencies``` instances by adding a
```global``` prefix to the key notation.

```dart
// example setting global values
final dependencies = Dependencies({
  "global.users[0].name": "John Flutter",
  "global.users[0].email": "name@example.com"
});

print(dependencies.getValue("global.users"));
```

## Listen for Changes

```dart
// example listening to changes
final dependencies = Dependencies({
  "users[0].name": "John Flutter",
  "users[0].email": "name@example.com"
});

var changed = false;
final notifier = dependencies.listenForChanges("users[0]");
notifier.addListener(() => changed = true);
dependencies.setValue("users[0].name", "Sally Flutter");

expect(changed, true);
expect(dependencies.getValue("users[0].name"), "Sally Flutter");
```
<!-- // end of #include -->

<!-- #include MODEL.md -->
# Model

The Model class serves as the base class for representing structured data in a standardized
format. It provides a flexible and dynamic way to manage properties, offering built-in support
for data transformation, instance management, and null safety. Models can be initialized with
raw data maps and are equipped with utility methods to access and modify properties efficiently.

```dart
class Topic extends Model {

  // getters
  String get key => getValue("key!");
  String get label => getValue("label!");
  String? get rank => getValue("rank");

  // setters
  set rank(String? rank) => setValue("rank", rank);

  Topic(super.data, {super.translation, super.immutable});
}
```

## Null Safety

The Model class ensures null safety through strict property access rules. The ! operator is used
to assert that a value is non-null. When accessing properties using `getValue("property!")`, 
it enforces that the value must be present. If the value is missing, an error is thrown,
helping developers catch issues early. Otherwise,

## Instance Management

Instance management ensures that models are consistently instantiated, avoiding duplicate objects
representing the same data. The following factory methods facilitate controlled instance creation.

### `singleInstance`

Ensures that only one instance of a model exists for a given data set. If an instance already
exists, it is returned instead of creating a new one.

```dart
class Topic extends Model {
  Topic._(super.data, {super.translation, super.immutable});

  factory Topic(
    Map<String, dynamic> data, {
    PropertyTranslation? translation,
    bool? immutable,
  }) {
    return Model.singleInstance<Topic>(
      factory: Topic._,
      data: data,
      tranlsation: translation,
      immutable: immutable
    );
  }
}
```

### `keyedInstance`

Creates and retrieves model instances based on a unique key. This ensures that multiple instances
representing the same entity use the same underlying object.

```dart
Models.register<Topic>(Topic.new, const [
  PropertyTransformer<String>("key", isKey: true),
  PropertyTransformer<String?>("name"),
]);

class Topic extends Model {
  Topic._(super.data, {super.translation, super.immutable});

  factory Topic(
    Map<String, dynamic> data, {
    PropertyTranslation? translation,
    bool? immutable,
  }) {
    return Model.keyedInstance<Topic>(
      factory: Topic._,
      data: data,
      tranlsation: translation,
      immutable: immutable
    );
  }
}
```

### `hasInstance`

Checks whether an instance of a model exists for the given data. This is useful when determining
whether to create a new instance or retrieve an existing one.

### `clearInstances`

Removes all stored instances, ensuring that future calls to singleInstance or keyedInstance
generate new objects. This is useful for refreshing models when underlying data changes
significantly.

## Loading Data

When loading data into your models, you may need to first transform its structure or convert its
properties to different types. To do this, use `PropertyTransformer` and `PropertyTranslation` 
classes to define the target format and data mappings.

### PropertyTransformer

Each `PropertyTransformer` instance represents a property in your model. It describes a property's
name, data type, and default value. They define the structure of your model. When you register a
model using `Models.register` you can optionally pass a list of `PropertyTransformer`s.
These transformers will automatically be used whenever you create a new model instance.

```dart
// register Content model class
Models.register<Content>(Content.new, const [
  PropertyTransformer<String>("title"),
  PropertyTransformer<String?>("summary"),
  PropertyTransformer<List<Image>>("images"),
]);

// register Image model class
Models.register<Image>(Image.new, const [
    PropertyTransformer<String>("url"),
    PropertyTransformer<String?>("caption"),
    PropertyTransformer<bool>("active", defaultValue: true),
]);

class Content extends Model {
  Content(super.data, {super.translation, super.immutable}); 
}

class Image extends Model {
  Image(super.data, {super.translation, super.immutable});
}
```

The following property types are natively supported:

* Anything that extends `Model`, provided it's registered using with `Models.register`.
* The Basic types `String`, `int`, `double`, and `bool`.
* The types `Color`, `DateTime`, and `Duration`.
* The collections `List`, `Set` and `Map`. Prefer using a subclass of `Model` class over `Map`, 
  if possible.
* `List<List>` is not well supported at the moment
* Custom types are supported by registering transform functions.
  See [Transform Functions](transform-functions)

### PropertyTranslation

The `PropertyTranslation` class enables you to map a source data structure to a target data
structure, making it particularly useful when the source data structure doesn't align with your
model's structure. This class is also beneficial when your model needs to load data from various
sources, each with its own distinct data structure. Simply specify a source/target property pair
for each property that needs to be mapped. If a target property is not explicitly mapped, it
will default to using the same name for the source property.

```dart
// translate 'firstName' to 'first' and 'lastName' to 'last' translation. Since all other source
// property names match the target property names, they will be imported without translation.

Models.register<Person>(Person.new, const [
  PropertyTransformer<String>("first"),
  PropertyTransformer<String>("last"),
  PropertyTransformer<bool>("employee"),
  PropertyTransformer<int>("age"),
]);

class Person extends Model {
  Person(super.data, {super.translation, super.immutable});
}

final person = Person({
  "firstName": "Mike",
  "lastName": "Jones",
  "employee": "true",
  "age": "25"
}, translation: PropertyTranslation({
  "firstName": "first",
  "lastName": "last"
}));

expect(person, {
  "first": "Mike",
  "last": "Jones",
  "employee": true,
  "age": 25
});
```

```dart
// this example shows how to load data into a nested model, 'Image'.

Models.register<Content>(Content.new, const [
  PropertyTransformer<String>("title"),
  PropertyTransformer<String?>("summary"),
  PropertyTransformer<Image>("image"),
]);

Models.register<Image>(Image.new, const [
  PropertyTransformer<String>("url"),
  PropertyTransformer<String?>("caption"),
]);

class Content extends Model {
  Content(super.data, {super.translation, super.immutable});
}

class Image extends Model {
  Image(super.data, {super.translation, super.immutable});
}

final content = Content({
  "title": "Hello World",
  "summary": "Basic App",
  "imageUrl": "https://www.example.com/image.jpg",
  "imageCaption": "Sunset",
}, translation: PropertyTranslation({
  "imageUrl": "image.url",
  "imageCaption": "image.caption",
}));

expect(content, {
  'title': 'Hello World',
  'summary': 'Basic App',
  'image': {'url': 'https://www.example.com/image.jpg', 'caption': 'Sunset'}
});
```

```dart
// this example shows how to add multiple models to a List.

Models.register<Content>(Content.new, const [
  PropertyTransformer<String>("title"),
  PropertyTransformer<String?>("summary"),
  PropertyTransformer<List<Image>>("images"),
]);

Models.register<Image>(Image.new, const [
  PropertyTransformer<String>("url"),
  PropertyTransformer<String?>("caption"),
]);

class Content extends Model {
  Content(super.data, {super.translation, super.immutable});
}

class Image extends Model {
  Image(super.data, {super.translation, super.immutable});
}

final content = Content({
  "title": "Hello World",
  "summary": "Basic App",
  "myImages": [
    {"url": "https://www.example.com/image1.jpg", "caption": "#1"},
    {"url": "https://www.example.com/image2.jpg", "caption": "#2"},
    {"url": "https://www.example.com/image3.jpg", "caption": "#3"},
  ]
}, translation: PropertyTranslation({
  "myImages": "images",
}));

expect(content, {
  'title': 'Hello World',
  'summary': 'Basic App',
  'images': [
    {'url': 'https://www.example.com/image1.jpg', 'caption': '#1'},
    {'url': 'https://www.example.com/image2.jpg', 'caption': '#2'},
    {"url": "https://www.example.com/image3.jpg", "caption": "#3"},
  ]
});
```

```dart
// this example shows how to add multiple unindexed models to a list.

Models.register<Content>(Content.new, const [
  PropertyTransformer<String>("title"),
  PropertyTransformer<String?>("summary"),
  PropertyTransformer<List<Image>>("images"),
]);

Models.register<Image>(Image.new, const [
  PropertyTransformer<String>("url"),
  PropertyTransformer<String?>("caption"),
]);

class Content extends Model {
  Content(super.data, {super.translation, super.immutable});
}

class Image extends Model {
  Image(super.data, {super.translation, super.immutable});
}

final model = TestModel({
  "title": "Hello World",
  "summary": "Basic App",
  "primaryImageUrl": "https://www.example.com/image.jpg",
  "secondaryImageUrl": "https://www.example.com/image2.jpg",
  "secondaryImageCaption": "Secondary",
}, translation: PropertyTranslation({
  "primaryImageUrl": "images.url",
  "primaryImageCaption": "images.caption",
  "secondaryImageUrl": "images.url",
  "secondaryImageCaption": "images.caption",
}));

expect(model, {
  'title': 'Hello World',
  'summary': 'Basic App',
  'images': [
    {'url': 'https://www.example.com/image.jpg'},
    {'url': 'https://www.example.com/image2.jpg', 'caption': 'Secondary'}
  ]
});
```

### Type Converters

When importing data, Model converts source data types into the target's data types using
converter functions. There are preregistered converter functions for `String`, `int`,
`double`, `bool`, `DateTime`, `Duration`, `Color` and `dynamic`. You can also define custom
type converters using the `TypeConverters.register` method. Typically, you should 
registration your custom functions in `main()`.

```dart
main() {
  TypeConverters.register<Money>((value) {
    if (value is Money) {
      return value;
    } else if (value is String) {
      return Money.parse(value, isoCode: 'USD');
    } else if (value is int) {
      return Money.fromInt(value, isoCode: 'USD');
    } else {
      throw Exception("Unable to convert value of type ${value.runtimeType} to 'Money'");
    }
  });
}
```
<!-- // end of #include -->