import 'package:flutter/material.dart';
import 'login.dart';

Color fontColor = Color.fromARGB(255, 255, 255, 255);
Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
Color settingsBackgroundColor = Color.fromARGB(255, 37, 55, 73);

class RegScreen extends StatelessWidget {
  const RegScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up for an Account', style: TextStyle(color: fontColor)),
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
                icon: Icon(Icons.person, color: fontColor), // Adding fontColor to the icon color
                labelText: 'First Name *',
                labelStyle: TextStyle(color: fontColor), // Adding fontColor to the label text color
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person, color: fontColor), // Adding fontColor to the icon color
                labelText: 'Last Name *',
                labelStyle: TextStyle(color: fontColor), // Adding fontColor to the label text color
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.mail, color: fontColor), // Adding fontColor to the icon color
                labelText: 'Email *',
                labelStyle: TextStyle(color: fontColor), // Adding fontColor to the label text color
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                // Applying regex validation for email
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'How many tasks do you want displayed daily?',
              style: TextStyle(color: fontColor),
            ),
            DropdownButtonFormField<String>(
              value: 'up to 3', // Default value
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: <String>['up to 3', 'up to 5', 'up to 8'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: fontColor)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // store the value in the database
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                icon: Icon(Icons.lock_person_rounded, color: fontColor), // Adding fontColor to the icon color
                labelText: 'Password *',
                labelStyle: TextStyle(color: fontColor), // Adding fontColor to the label text color
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                // Applying regex validation for password
                if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$').hasMatch(value)) {
                  return 'Your password must:\nContain eight characters\nContain at least one letter\nContain at least one number\nContain one special character';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.lock_person_rounded, color: fontColor), // Adding fontColor to the icon color
                labelText: 'Confirm Password *',
                labelStyle: TextStyle(color: fontColor), // Adding fontColor to the label text color
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match. Please try again.';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
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
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Navigate to the sign-in page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text (
                "Already have an account? Sign in now.",
                style: TextStyle(color: fontColor), // Adding fontColor to the text color
              ),
            )
          ],
        ),
      ),
    );
  }
}
