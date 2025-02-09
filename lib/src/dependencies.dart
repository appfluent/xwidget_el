import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'model/brackets.dart';

class Dependencies {
  static final _globalData = <String, dynamic>{};

  final _data = <String, dynamic>{};

  Dependencies([Map<String, dynamic>? data]) {
    if (data != null) addAll(data);
  }

  /// Adds all key/value dependency pairs of [data] to this instance.
  ///
  /// Supports dot/bracket notation and global references in keys.
  Dependencies addAll(Map<String, dynamic> data) {
    for (final entry in data.entries) {
      setValue(entry.key, entry.value);
    }
    return this;
  }

  /// Returns the dependency references by [key] or null.
  ///
  /// Supports global references, but does not support dot/bracket notation in
  /// keys.
  dynamic operator [](String key) {
    final resolved = _getDataStore(key);
    return resolved.value[resolved.key];
  }

  /// Adds or replaces a dependency referenced by [key].
  ///
  /// Supports global references, but does not support dot/bracket notation in
  /// keys.
  void operator []=(String key, dynamic value) {
    final resolved = _getDataStore(key);
    resolved.value[resolved.key] = value;
  }

  /// Adds or replaces a dependency referenced by [path].
  ///
  /// Supports dot/bracket notation and global references.
  /// For example, `dependencies.setValue('user.email[0]', 'name@example.com');`
  void setValue(String path, dynamic value) {
    final resolved = _getDataStore(path);
    resolved.value.setValue(resolved.key, value);
  }

  /// Returns the dependency referenced by [path] or null.
  ///
  /// Supports dot/bracket notation and global references in keys.
  /// For example, `dependencies.getValue('user.email[0]');`
  dynamic getValue(String path) {
    final resolved = _getDataStore(path);
    return resolved.key.isNotEmpty
        ? resolved.value.getValue(resolved.key)
        : resolved.value;
  }

  /// Removes the dependency referenced by [key].
  ///
  /// Returns the removed dependency or null.
  ///
  /// Supports dot/bracket notation and global references in keys.
  /// Returns the removed value.
  dynamic removeValue(String key) {
    final resolved = _getDataStore(key);
    return resolved.value.removeValue(resolved.key);
  }

  /// Creates or returns the existing [ValueNotifier] for the dependency
  /// referenced by [path].
  ///
  /// Sets the notifier's value to [initialValue], if provided, otherwise it's
  /// set to the existing dependency value. If both are null, then the
  /// notifier's value is set to [defaultValue].
  ValueNotifier listenForChanges(String path, [dynamic initialValue, dynamic defaultValue]) {
    final resolved = _getDataStore(path);
    return resolved.value.listenForChanges(resolved.key, initialValue, defaultValue);
  }

  /// Adds the [value] as a dependency for the specified [key] if it doesn't
  /// already exist.
  void putIfAbsent(String key, dynamic value) {
    final resolved = _getDataStore(key);
    if (!resolved.value.containsKey(resolved.key)) {
      resolved.value[resolved.key] = value;
    }
  }

  /// Creates a shallow copy.
  ///
  /// The copy excludes the expression parser, if there is one, because the
  /// parser can only be bound to one [Dependencies] instance. A new parser is
  /// created and bound to the copy when needed.
  Dependencies copy({Map<String, dynamic>? addData, List<String>? preserveData}) {
    final copy = Dependencies(_data);
    if (addData != null) {
      copy._data.addAll(addData);
      if (preserveData != null) {
        for (final key in preserveData) {
          copy._data[key] = _data[key];
        }
      }
    }
    return copy;
  }

  /// Returns a formatted JSON string representation of this instance.
  @override
  String toString() {
    return JsonEncoder.withIndent('  ', (value) => value?.toString()).convert({
      "data": _data,
      "global": _globalData
    });
  }

  /// Gets local or global data depending on the key's prefix
  MapEntry<String, Map<String, dynamic>> _getDataStore(String key) {
    if (key == "global") return MapEntry("", _globalData);
    if (key.startsWith("global.")) return MapEntry(key.substring(7), _globalData);
    return MapEntry(key, _data);
  }
}