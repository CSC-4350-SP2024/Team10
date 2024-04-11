import 'package:flutter/material.dart';
import 'package:tinytaskapp/firebase_options.dart';
import 'nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'userDirectory.dart';
import './themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const TaskApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Handle the error gracefully
  }
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
      title: 'TinyTask',
      theme: AppThemes.darkTheme(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Get the user
            User? user = snapshot.data;
            // If the user is not null, they're logged in
            if (user != null) {
              return HomeScreen(); // Or whatever your home screen is
            }
            // User is not logged in
            return const UserDirectoryScreen();
          }
          // Waiting for connection state to be active
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
