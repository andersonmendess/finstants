import 'package:finstants/scaffold.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.redAccent
      ),
      darkTheme: ThemeData.dark().copyWith(
        accentColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 15, 15, 15),
          elevation: 0
        )
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: MyScaffold(),
    );
  }
}