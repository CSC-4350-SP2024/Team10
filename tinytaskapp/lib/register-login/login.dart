import 'package:flutter/material.dart';
import 'register.dart';

Color fontColor = Color.fromARGB(255, 255, 255, 255);
Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
Color settingsBackgroundColor = Color.fromARGB(255, 37, 55, 73);

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: fontColor)),
        backgroundColor: backgroundColor, // Applying backgroundColor to the app bar
        iconTheme: IconThemeData(color: fontColor), 
      ),
      body: Container(
        color: settingsBackgroundColor, // Applying settingsBackgroundColor to the body
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.mail, color: fontColor), // Adding fontColor to the icon color
                labelText: 'Email *',
                labelStyle: TextStyle(color: fontColor), // Adding fontColor to the label text color
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.lock_person_rounded, color: fontColor), // Adding fontColor to the icon color
                labelText: 'Password *',
                labelStyle: TextStyle(color: fontColor), // Adding fontColor to the label text color
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement sign up logic
              },              
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(settingsBackgroundColor), // Using settingsBackgroundColor for button background
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color: fontColor, // Adding fontColor to button text color
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegScreen()),
                );
              },
              child: Text(
                "Don't have an account? Register now.",
                style: TextStyle(color: fontColor), // Adding fontColor to the text color
              ),
            )
          ],
        ),
      ),
    );
  }
}
