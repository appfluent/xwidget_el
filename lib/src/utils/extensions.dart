import 'dart:ui';


extension MapExt<K, V> on Map<K, V> {
  String asString(String key, [String defaultValue = ""]) {
    return this[key]?.toString() ?? defaultValue;
  }

  void subtract(Map<K, V> map) {
    removeWhere((key, value) => map.containsKey(key));
  }

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

  MapEntry<K, V>? firstOrNull() {
    for (final entry in entries) {
      return entry;
    }
    return null;
  }

  MapEntry<K, V> first() {
    final entry = firstOrNull();
    if (entry != null) return entry;
    throw Exception("Cannot get first item because the map is empty");
  }

  MapEntry<K, V>? lastOrNull() {
    MapEntry<K, V>? entry;
    for (entry in entries) {}
    return entry;
  }

  MapEntry<K, V> last() {
    final entry = lastOrNull();
    if (entry != null) return entry;
    throw Exception("Cannot get last item because the map is empty");
  }

  void removeKeys(Map<K, dynamic> referenceMap) {
    for (final key in referenceMap.keys) {
      remove(key);
    }
  }
}

extension ListExt<E> on List<E> {
  addIfNotNull(E? value) {
    if (value != null) {
      add(value);
    }
  }

  E? firstOrNull() {
    return (isNotEmpty) ? first : null;
  }

  E? lastOrNull() {
    return (isNotEmpty) ? last : null;
  }

  void subtract(List<E> list) {
    removeWhere((element) => list.contains(element));
  }

  List<E> immutable() {
    final list = [];
    for (final value in this) {
      list.add((value is Map)
          ? value.immutable()
          : ((value is List) ? value.immutable() : value));
    }
    return List.unmodifiable(list);
  }

  insertFill(int index, E element, E filler) {
    while (index >= length) {
      insert(length, filler);
    }
    this[index] = element;
  }

  void move(int fromIndex, int toIndex) {
    if (fromIndex != toIndex) {
      insert(toIndex, this[fromIndex]);
      removeAt(fromIndex + (fromIndex > toIndex ? 1 : 0));
    }
  }
}

extension ColorExt on Color {
  static RegExp colorPrefixRegExp = RegExp("^(#|0x)*");

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

  String asString() {
    return "0x${value.toRadixString(16).padLeft(8, '0')}";
  }
}
