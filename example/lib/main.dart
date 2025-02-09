import 'package:flutter/material.dart';
import 'package:xwidget_el/xwidget_el.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _parser = ELParser();
  final _dependencies = Dependencies({
    "user" : {
      "first": "Mike",
      "last": "Jones",
      "email": "mjones@example.com"
    },
    "greet": (name) => "Hello, $name!"
  });

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_parser.evaluate("greet(user.first + ' ' + user.last)", _dependencies),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)
                ),
                Text(_parser.evaluate("'The date is ' + formatDateTime('MM/dd/yyyy', now())", _dependencies),
                  style: TextStyle(fontSize: 17)
                ),
              ]
            ),
          )
        )
      )
    );
  }
}

