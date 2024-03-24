import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:tinytaskapp/homeScreen/home.dart';
// import 'package:tinytaskapp/processTasks/addTask.dart';
import 'nav.dart';
import 'register.dart';
import '/themes/theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User: ${userCredential.user}');

      if (userCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackground(Theme.of(context)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: '',
          isReturnable: true,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 150,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20.0),
                  Text("Login",
                      style: TextStyle(fontSize: 45, color: Colors.white)),
                  SizedBox(height: 20.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hoverColor: Colors.green,
                      hintText: 'Email/Username',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      _signInWithEmailAndPassword();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green, // Set button's background color here
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the sign-in page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegScreen()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign up now.",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
