import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'login.dart';
import 'register.dart';

Color backgroundColorT = Color.fromARGB(255, 26, 33, 41);
Color backgroundColorB = Color.fromARGB(255, 31, 48, 66);

class UserDirectoryScreen extends StatelessWidget {
  const UserDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              backgroundColorT,
              backgroundColorB,
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/tinytasklogo.png',
              ),
              SizedBox(height: 50),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: SizedBox(
                      width: 300,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: const Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegScreen()),
                    ),
                    child: SizedBox(
                      width: 300,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: const Text(
                            'Create an Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: '',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 175),
            ],
          ),
        ),
      ),
    );
  }
}
