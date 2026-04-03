import 'dart:ui';

extension MapExt<K, V> on Map<K, V> {
  /// Returns the value for [key] as a string.
  ///
  /// - If the key exists, its value is converted with `toString()`.
  /// - If the key is missing or the value is `null`, returns [defaultValue].
  String asString(String key, [String defaultValue = ""]) {
    return this[key]?.toString() ?? defaultValue;
  }

  /// Removes all entries from this map that also exist in [map].
  ///
  /// Comparison is based on keys only; values are ignored.
  void subtract(Map<K, V> map) {
    removeWhere((key, value) => map.containsKey(key));
  }

  /// Returns an unmodifiable deep copy of this map.
  ///
  /// - Nested maps are recursively converted to immutable maps.
  /// - Nested lists are recursively converted to immutable lists.
  Map<K, V> immutable() {
    final map = {};
    for (final entry in entries) {
      final value = entry.value;
      map[entry.key] = (value is Map)
          ? value.immutable()
          : ((value is List) ? value.immutable() : value);
    }
    return Map.unmodifiable(map);
  }

  /// Returns the first entry in the map, or `null` if empty.
  MapEntry<K, V>? firstOrNull() {
    for (final entry in entries) {
      return entry;
    }
    return null;
  }

  /// Returns the first entry in the map.
  ///
  /// Throws [Exception] if the map is empty.
  MapEntry<K, V> first() {
    final entry = firstOrNull();
    if (entry != null) return entry;
    throw Exception("Cannot get first item because the map is empty");
  }

  /// Returns the last entry in the map, or `null` if empty.
  MapEntry<K, V>? lastOrNull() {
    MapEntry<K, V>? entry;
    for (entry in entries) {}
    return entry;
  }

  /// Returns the last entry in the map.
  ///
  /// Throws [Exception] if the map is empty.
  MapEntry<K, V> last() {
    final entry = lastOrNull();
    if (entry != null) return entry;
    throw Exception("Cannot get last item because the map is empty");
  }

  /// Removes all keys from this map that are present in [referenceMap].
  void removeKeys(Map<K, dynamic> referenceMap) {
    for (final key in referenceMap.keys) {
      remove(key);
    }
  }
}

extension ListExt<E> on List<E> {
  /// Adds [value] to the list if it is not `null`.
  void addIfNotNull(E? value) {
    if (value != null) {
      add(value);
    }
  }

  /// Returns the first element, or `null` if the list is empty.
  E? firstOrNull() {
    return (isNotEmpty) ? first : null;
  }

  /// Returns the last element, or `null` if the list is empty.
  E? lastOrNull() {
    return (isNotEmpty) ? last : null;
  }

  /// Removes all elements from this list that are also present in [list].
  void subtract(List<E> list) {
    removeWhere((element) => list.contains(element));
  }

  /// Returns an unmodifiable deep copy of this list.
  ///
  /// - Nested maps are recursively converted to immutable maps.
  /// - Nested lists are recursively converted to immutable lists.
  List<E> immutable() {
    final list = [];
    for (final value in this) {
      list.add((value is Map) ? value.immutable() : ((value is List) ? value.immutable() : value));
    }
    return List.unmodifiable(list);
  }

  /// Inserts [element] at [index], filling gaps with [filler] if needed.
  ///
  /// Example:
  /// ```dart
  /// final list = <int>[];
  /// list.insertFill(2, 42, 0);
  /// // list = [0, 0, 42]
  /// ```
  void insertFill(int index, E element, E filler) {
    while (index >= length) {
      insert(length, filler);
    }
    this[index] = element;
  }

  /// Moves the element at [fromIndex] to [toIndex].
  ///
  /// Adjusts indices to preserve order correctly.
  void move(int fromIndex, int toIndex) {
    if (fromIndex != toIndex) {
      insert(toIndex, this[fromIndex]);
      removeAt(fromIndex + (fromIndex > toIndex ? 1 : 0));
    }
  }
}

extension ColorExt on Color {
  /// Regular expression for stripping common color prefixes (`#`, `0x`).
  static RegExp colorPrefixRegExp = RegExp("^(#|0x)*");

  /// Parses a hex string into a [Color].
  ///
  /// - Accepts strings with or without `#`/`0x` prefix.
  /// - If 6 hex digits are provided, assumes opaque (`FF` alpha).
  /// - If 8 hex digits are provided, interprets as ARGB.
  /// - Throws [Exception] if the string is not valid.
  static Color parse(String value) {
    var argb = value.replaceAll(colorPrefixRegExp, "");
    if (argb.length == 6) {
      argb = "FF$argb";
    }
    if (argb.length == 8) {
      final colorInt = int.parse(argb, radix: 16);
      return Color(colorInt);
    }
    throw Exception("Invalid color value: $value");
  }

  /// Returns the color as an ARGB hex string (`0xAARRGGBB`).
  String asString() {
    return "0x${toARGB32().toRadixString(16).padLeft(8, '0')}";
  }
}
