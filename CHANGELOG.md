## 0.5.0

### Added

- **Custom instance method dispatch** — `registerMethodResolver(resolver)` allows registering resolvers that handle instance method calls on custom types. Resolvers run after built-in instance methods in [getDynamicFunctionOn], in registration order; the first non-null result wins.
- **Expanded `toDuration` int unit aliases** — When converting an `int` to a `Duration`, `intUnit` now accepts long-form aliases for every unit:
  - days: `d`, `day`, `days`
  - hours: `h`, `hour`, `hours`
  - minutes: `M`, `min`, `mins`, `minutes`
  - seconds: `s`, `sec`, `secs`, `seconds`
  - milliseconds: `ms`, `milli`, `millis`, `milliseconds`

  Defaults to milliseconds when `intUnit` is omitted or `null`.
- **Expanded `parseDuration` string unit aliases** — String parsing now accepts `sec`/`secs` for seconds, `minutes` for minutes, and `hours` for hours, alongside the existing short forms.

### Fixed

- **`entries` instance function on Map** — `case "entries"` in `getDynamicFunctionOn` was returning the iterable directly instead of a closure, causing `Function.apply` to throw on invocation. Now wrapped consistently with `keys` and `values`.
- **`toDuration` no longer silently falls through to milliseconds** — Previously, an unrecognized `intUnit` produced a millisecond-based `Duration` due to default fall-through. Unrecognized units now throw an exception.

### Tests

- Completed test coverage for static and instance dynamic EL functions, including converters, validators, formatters, set operations, `isInfinite`/`isNaN`, `lastIndexOf`, `replaceRange`, and the new `entries` and `registerMethodResolver` paths.

## 0.4.0

### Added

- **New EL formatter functions**
    - `formatNumber(value, pattern)` — ICU/intl number formatting with grouping, decimals, and currency support.
    - `formatPercent(value, decimalPlaces)` — Formats a decimal as a percentage string.
    - `formatBytes(value, decimalPlaces)` — Human-readable byte sizes (B, KB, MB, GB, TB).
    - `formatCompact(value, decimalPlaces)` — Compact number suffixes (K, M, B, T).
    - `formatOrdinal(value)` — English ordinal suffixes (1st, 2nd, 3rd, 4th).
    - `formatPlural(count, singular, plural)` — Count-aware label pluralization.
    - `formatElapsed(dateTime)` — Relative time strings ("5 minutes ago", "in 3 hours").

- **New EL math functions**
    - `min(a, b)` — Returns the smaller of two comparable values.
    - `max(a, b)` — Returns the larger of two comparable values.
    - `clamp(value, lower, upper)` — Constrains a value to a range.

- **New EL static functions**
    - `first(value)` — Returns the first element of a List, Set, or Map.
    - `last(value)` — Returns the last element of a List, Set, or Map.

- **Custom function registration** — `registerFunction(name, func)` allows registering user-defined static EL functions at startup. Resolution order: built-in → registered → dependency.

### Fixed

- **Ternary expressions now accept dynamic conditions** — `ConditionalExpression` condition type widened from `Expression<bool>` to `Expression`, allowing function calls that return bool to be used directly as ternary conditions (e.g., `isAdmin() ? 'yes' : 'no'`). Non-bool conditions throw a clear runtime error.

### Tests

- Added 405 tests across 7 test files covering formatters, math, misc, converters, validators, dynamic functions, and conditional expressions.

## 0.3.1

- Updated minimum Dart SDK to 3.8.
- Minor documentation updates.

## 0.3.0

- Updated minimum Flutter version to 3.10.0.
- Updated minimum Dart SDK to 3.4.
- Fixed `runtimeType` instance function using incorrect casing in `getDynamicFunctionOn`.
- Fixed missing `return` for `values` instance function in `getDynamicFunctionOn`.

## 0.2.2

- Changed logging package from `logger` to `logging`.

## 0.2.1

- Resolved code linting warnings
- Expanded developer documentation throughout the codebase

## 0.2.0

- Updated petitparser dependency to ^7.0.1
- Fixed issue with `ELParserDefinition`'s `build` and `buildFrom` methods.

## 0.1.0

- Initial release.
