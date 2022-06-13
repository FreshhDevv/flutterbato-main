import 'package:flutter/material.dart' show BuildContext, Key, MaterialApp, StatelessWidget, Widget, runApp;

import 'screens/loading.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
    
    
  }
}
