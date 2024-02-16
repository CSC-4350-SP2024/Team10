import 'package:flutter/material.dart';
import 'nav.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDtcrqZDhKdFgPJCJzmhWIA-Ei9oBEHqQQ",
          appId: "1:202382514585:android:882ade15a361502f24db08",
          messagingSenderId: "202382514585",
          projectId: "tinytask-99a5f"));
  runApp(TaskApp());
}

final ThemeData defaultTinyTheme = ThemeData(
  primarySwatch: Colors.blue,
  fontFamily: 'Oxygen',
);

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

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
