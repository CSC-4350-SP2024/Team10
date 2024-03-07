import 'package:flutter/material.dart';
import 'register.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.mail),
                labelText: 'Email *',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.lock_person_rounded),
                labelText: 'Password *',
              ),
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
                  MaterialPageRoute(builder: (context) => RegScreen()),
                );
              },
              child: const Text(
                "Don't have an account? Register now.",
              )
            )
          ],
        ),
      ),
    );
  }
}
