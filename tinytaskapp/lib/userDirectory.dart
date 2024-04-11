import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'login.dart';
import 'register.dart';
import '/themes/theme.dart';

Color backgroundColorT = Color.fromARGB(255, 26, 33, 41);
Color backgroundColorB = Color.fromARGB(255, 31, 48, 66);

class UserDirectoryScreen extends StatelessWidget {
  const UserDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme(),
      home: Container(
        decoration: gradientBackground(Theme.of(context)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: '',
            isReturnable: false,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 125),
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
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
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
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
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
                      SizedBox(height: 40),
                      Text(
                        'Tiny App, Big Results.',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pacifico',
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              blurRadius: 2,
                              color: const Color.fromARGB(255, 73, 60, 60)
                                  .withOpacity(0.3),
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 175),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
