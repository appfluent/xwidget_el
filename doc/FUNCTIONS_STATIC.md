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
