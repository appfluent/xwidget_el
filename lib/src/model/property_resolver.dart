/// Wraps a resolved property value.
///
/// Distinguishes "resolved to a value" from "not resolved": resolvers return
/// `null` to defer to other resolvers, or a [PropertyResolution] whose [value]
/// may itself legitimately be null (e.g. the first element of `[null]`).
class PropertyResolution {
  final dynamic value;

  const PropertyResolution(this.value);
}

/// Resolves a property [name] on a [target] object.
///
/// Returns `null` to defer resolution to other registered resolvers.
typedef PropertyResolver = PropertyResolution? Function(String name, dynamic target);

final _registeredPropertyResolvers = <PropertyResolver>[];

/// Registers a resolver for property access on custom types.
///
/// Property access is direct member resolution on path segments — e.g.
/// `${order.total}` in EL or `data.getValue("order.total")` in Dart — used
/// when a segment is not a Map key or List index.
///
/// Resolvers run inside [resolveProperty] after the built-in core properties
/// fall through, in registration order. The first resolver that returns a
/// non-null [PropertyResolution] wins. Built-in core properties always take
/// priority over registered resolvers.
///
/// Example:
/// ```dart
/// registerPropertyResolver((name, target) {
///   if (target is Point) {
///     switch (name) {
///       case "x": return PropertyResolution(target.x);
///       case "y": return PropertyResolution(target.y);
///     }
///   }
///   return null;
/// });
/// ```
void registerPropertyResolver(PropertyResolver resolver) {
  _registeredPropertyResolvers.add(resolver);
}

/// Resolves property [name] on [target] to a [PropertyResolution], or `null`
/// when neither the built-in core properties nor any registered resolver
/// recognizes it.
///
/// Core properties cover the complete public instance-getter surface
/// (excluding Object members) of String, Iterable, List, Map, num, int,
/// Duration, DateTime, and Uri — complete so the future generated resolver
/// reproduces identical semantics. `first`/`last`/`single` follow Dart
/// semantics and throw [StateError] when unsatisfiable.
PropertyResolution? resolveProperty(String name, dynamic target) {
  final core = _resolveCoreProperty(name, target);
  if (core != null) return core;

  for (final resolver in _registeredPropertyResolvers) {
    final resolution = resolver(name, target);
    if (resolution != null) return resolution;
  }
  return null;
}

PropertyResolution? _resolveCoreProperty(String name, dynamic target) {
  // please maintain alphabetical order within each type group
  if (target is String) {
    switch (name) {
      case "codeUnits":
        return PropertyResolution(target.codeUnits);
      case "isEmpty":
        return PropertyResolution(target.isEmpty);
      case "isNotEmpty":
        return PropertyResolution(target.isNotEmpty);
      case "length":
        return PropertyResolution(target.length);
      case "runes":
        return PropertyResolution(target.runes);
    }
  } else if (target is Map) {
    switch (name) {
      case "entries":
        return PropertyResolution(target.entries);
      case "isEmpty":
        return PropertyResolution(target.isEmpty);
      case "isNotEmpty":
        return PropertyResolution(target.isNotEmpty);
      case "keys":
        return PropertyResolution(target.keys);
      case "length":
        return PropertyResolution(target.length);
      case "values":
        return PropertyResolution(target.values);
    }
  } else if (target is Iterable) {
    if (target is List) {
      switch (name) {
        case "reversed":
          return PropertyResolution(target.reversed);
      }
    }
    switch (name) {
      case "first":
        return PropertyResolution(target.first);
      case "isEmpty":
        return PropertyResolution(target.isEmpty);
      case "isNotEmpty":
        return PropertyResolution(target.isNotEmpty);
      case "iterator":
        return PropertyResolution(target.iterator);
      case "last":
        return PropertyResolution(target.last);
      case "length":
        return PropertyResolution(target.length);
      case "single":
        return PropertyResolution(target.single);
    }
  } else if (target is num) {
    if (target is int) {
      switch (name) {
        case "bitLength":
          return PropertyResolution(target.bitLength);
        case "isEven":
          return PropertyResolution(target.isEven);
        case "isOdd":
          return PropertyResolution(target.isOdd);
      }
    }
    switch (name) {
      case "isFinite":
        return PropertyResolution(target.isFinite);
      case "isInfinite":
        return PropertyResolution(target.isInfinite);
      case "isNaN":
        return PropertyResolution(target.isNaN);
      case "isNegative":
        return PropertyResolution(target.isNegative);
      case "sign":
        return PropertyResolution(target.sign);
    }
  } else if (target is Duration) {
    switch (name) {
      case "inDays":
        return PropertyResolution(target.inDays);
      case "inHours":
        return PropertyResolution(target.inHours);
      case "inMicroseconds":
        return PropertyResolution(target.inMicroseconds);
      case "inMilliseconds":
        return PropertyResolution(target.inMilliseconds);
      case "inMinutes":
        return PropertyResolution(target.inMinutes);
      case "inSeconds":
        return PropertyResolution(target.inSeconds);
      case "isNegative":
        return PropertyResolution(target.isNegative);
    }
  } else if (target is DateTime) {
    switch (name) {
      case "day":
        return PropertyResolution(target.day);
      case "hour":
        return PropertyResolution(target.hour);
      case "isUtc":
        return PropertyResolution(target.isUtc);
      case "microsecond":
        return PropertyResolution(target.microsecond);
      case "microsecondsSinceEpoch":
        return PropertyResolution(target.microsecondsSinceEpoch);
      case "millisecond":
        return PropertyResolution(target.millisecond);
      case "millisecondsSinceEpoch":
        return PropertyResolution(target.millisecondsSinceEpoch);
      case "minute":
        return PropertyResolution(target.minute);
      case "month":
        return PropertyResolution(target.month);
      case "second":
        return PropertyResolution(target.second);
      case "timeZoneName":
        return PropertyResolution(target.timeZoneName);
      case "timeZoneOffset":
        return PropertyResolution(target.timeZoneOffset);
      case "weekday":
        return PropertyResolution(target.weekday);
      case "year":
        return PropertyResolution(target.year);
    }
  } else if (target is Uri) {
    switch (name) {
      case "authority":
        return PropertyResolution(target.authority);
      case "data":
        return PropertyResolution(target.data);
      case "fragment":
        return PropertyResolution(target.fragment);
      case "hasAbsolutePath":
        return PropertyResolution(target.hasAbsolutePath);
      case "hasAuthority":
        return PropertyResolution(target.hasAuthority);
      case "hasEmptyPath":
        return PropertyResolution(target.hasEmptyPath);
      case "hasFragment":
        return PropertyResolution(target.hasFragment);
      case "hasPort":
        return PropertyResolution(target.hasPort);
      case "hasQuery":
        return PropertyResolution(target.hasQuery);
      case "hasScheme":
        return PropertyResolution(target.hasScheme);
      case "host":
        return PropertyResolution(target.host);
      case "isAbsolute":
        return PropertyResolution(target.isAbsolute);
      case "origin":
        return PropertyResolution(target.origin);
      case "path":
        return PropertyResolution(target.path);
      case "pathSegments":
        return PropertyResolution(target.pathSegments);
      case "port":
        return PropertyResolution(target.port);
      case "query":
        return PropertyResolution(target.query);
      case "queryParameters":
        return PropertyResolution(target.queryParameters);
      case "queryParametersAll":
        return PropertyResolution(target.queryParametersAll);
      case "scheme":
        return PropertyResolution(target.scheme);
      case "userInfo":
        return PropertyResolution(target.userInfo);
    }
  }
  return null;
}
