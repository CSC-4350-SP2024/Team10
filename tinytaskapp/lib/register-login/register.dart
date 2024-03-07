import 'package:flutter/material.dart';
import 'login.dart';

class RegScreen extends StatelessWidget {
  const RegScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up for an Account'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'First Name *',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Last Name *',
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.mail),
                labelText: 'Email *',
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
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                icon: Icon(Icons.lock_person_rounded),
                labelText: 'Password *',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                // Applying regex validation for password
                if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$').hasMatch(value)) {
                  return 'Your password must:\nContain eight characters\nContain at least one character\nContain one special character';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.lock_person_rounded),
                labelText: 'Confirm Password *',
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
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement sign up logic
              },              
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 37, 55, 73)),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Navigate to the sign-in page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text (
                "Already have an account? Sign in now.",
              )
            )
          ],
        ),
      ),
    );
  }
}
