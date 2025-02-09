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
