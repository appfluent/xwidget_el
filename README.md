<p align="center">
    <img src="https://raw.githubusercontent.com/appfluent/xwidget_el/main/doc/assets/xwidget_el_logo_full.png"
        style="margin-top:16px; margin-bottom: 16px;"
        alt="XWidget EL Logo"
        height="80"
    />
</p>

# XWidget EL

A powerful expression language for [XWidget](https://pub.dev/packages/xwidget) that enables
dynamic evaluation of expressions within XML markup. Supports arithmetic, logical, conditional,
and relational operators, along with 50+ built-in functions, instance method chaining, and custom
function registration.

```xml
<Text data="${user.firstName + ' ' + user.lastName}"/>
<Text visible="${items.length > 0}" data="Found ${length(items)} items"/>
<Container color="${isActive ? toColor('#00FF00') : toColor('#FF0000')}"/>
```

## Features

- **Full Operator Support** — Arithmetic (`+`, `-`, `*`, `/`, `~/`, `%`), logical (`&&`, `||`, `!`), relational (`<`, `>`, `<=`, `>=`, `==`, `!=`), ternary (`? :`), and null-coalescing (`??`)
- **50+ Built-in Functions** — Type conversions, string manipulation, collection queries, date/time formatting, math operations, and validators
- **Instance Method Chaining** — Call methods directly on values: `${name.toUpperCase().trim()}`
- **Custom Functions** — Register your own functions on any `Dependencies` instance
- **Null Safety** — Null-coalescing, null-safe property access, and null-checking functions built in
- **Type-Aware Operations** — DateTime arithmetic, Duration math, Enum comparison, and automatic type coercion
- **Reactive Data Model** — `Dependencies` class with dot/bracket notation, global data, and change notifications via `ValueNotifier`
- **Data Modeling** — Structured models with property transformers, type converters, translations, and instance management

## Quick Start

```bash
flutter pub add xwidget_el
```

If you're using [XWidget](https://pub.dev/packages/xwidget), `xwidget_el` is included automatically as a dependency.

Expressions are evaluated within `${...}` delimiters in XML attributes:

```xml
<!-- References -->
<Text data="${user.name}"/>

<!-- Arithmetic -->
<Text data="${toString(price * quantity)}"/>

<!-- Conditionals -->
<Text data="${isVip ? 'Welcome back!' : 'Hello!'}"/>

<!-- Function calls -->
<Text data="${formatDateTime('yyyy-MM-dd', now())}"/>

<!-- Method chaining -->
<Text data="${title.trim().toUpperCase()}"/>

<!-- Null coalescing -->
<Text data="${user.nickname ?? user.firstName}"/>
```

## Documentation

Full documentation is available at **[docs.xwidget.dev](https://docs.xwidget.dev)**, including:

- [Expression Language Rules](https://docs.xwidget.dev/el/rules/) — Operator precedence and syntax
- [Static Functions](https://docs.xwidget.dev/el/static_functions/) — Built-in functions reference
- [Instance Functions](https://docs.xwidget.dev/el/instance_functions/) — Method chaining reference
- [Custom Functions](https://docs.xwidget.dev/el/custom_functions/) — Registering your own functions
- [Core Classes](https://docs.xwidget.dev/el/core_classes/) — Dependencies, Model, and ELParser

## License

See [LICENSE](LICENSE) for details.