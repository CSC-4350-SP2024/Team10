import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(TaskApp());
}

final ThemeData defaultTinyTheme = ThemeData(
  primarySwatch: Colors.blue,
  fontFamily: 'Oxygen',
);

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
