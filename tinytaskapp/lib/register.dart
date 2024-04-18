import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tinytaskapp/processTasks/addTask.dart';
import 'package:tinytaskapp/userDirectory.dart';
import 'login.dart';
import 'themes/theme.dart';

Color fontColor = Color.fromARGB(255, 255, 255, 255);
Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
Color settingsBackgroundColor = Color.fromARGB(255, 37, 55, 73);

class RegScreen extends StatelessWidget {
  const RegScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _firstNameController = TextEditingController();
    final TextEditingController _lastNameController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String hintText;

    String selectedMaxTasks = 'Normal (5 Tasks)';

    int convertMaxTasks(String maxTasks) {
      switch (maxTasks) {
        case 'Low (3 Tasks)':
          return 3;
        case 'Normal (5 Tasks)':
          return 5;
        case 'Overachiever (8 Tasks)':
          return 8;
        default:
          return 5;
      }
    }

    void _signUp() async {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);

        String userId = userCredential.user!.uid;
        await _firestore.collection('users').doc(userId).set({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'maxTasks': convertMaxTasks(selectedMaxTasks),
          "birthday": "",
          "gender": "",
          "hasDarkTheme": true,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserDirectoryScreen(),
          ),
        );
      } catch (e) {
        print('Error: $e');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sign up Failed'),
                content: const Text('An error occurred. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            });
      }
    }

    return Container(
      decoration: gradientBackground(Theme.of(context)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: '',
          isReturnable: true,
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    'lib/assets/tinytasklogo.png', // Path to your image asset
                    width: 300, // Set the width as needed
                    height: 117, // Set the height as needed
                  ),
                const SizedBox(height: 60.0),
                const Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _firstNameController,
                  cursorColor: Colors.green,
                  style: TextStyle(color: fontColor),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.person),
                    labelText: 'First Name *',
                    labelStyle: TextStyle(color: fontColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _lastNameController,
                  cursorColor: Colors.green,
                  style: TextStyle(color: fontColor),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.person),
                    labelText: 'Last Name *',
                    labelStyle: TextStyle(color: fontColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  cursorColor: Colors.green,
                  style: TextStyle(color: fontColor),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.mail),
                    labelText: 'Email *',
                    labelStyle: TextStyle(color: fontColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Applying regex validation for email
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0), // Shift to the right by 30px
                  child: Text(
                    'Max Tasks Shown?',
                    style: TextStyle(color: fontColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, ), 
                  child: Row(
                    children: [
                      Icon(Icons.add_box, color: fontColor), // Add the add_box icon
                      const SizedBox(width:12), // Add some space between the icon and the dropdown button
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selectedMaxTasks,
                            dropdownColor: backgroundColor, // Default value
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                              border: OutlineInputBorder(),
                            ),
                            items: <String>[
                              'Low (3 Tasks)',
                              'Normal (5 Tasks)',
                              'Overachiever (8 Tasks)'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: fontColor)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              selectedMaxTasks = newValue!;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  cursorColor: Colors.green,
                  style: TextStyle(color: fontColor),
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock_person_rounded),
                    labelText: 'Password *',                    
                    hintText: 'Must be 8 characters, 1 letter and 1 special character',
                    labelStyle: TextStyle(color: fontColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    // Applying regex validation for password
                    if (!RegExp(
                            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
                        .hasMatch(value)) {
                      return 'Your password must:\nContain eight characters\nContain at least one letter\nContain one special character';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  cursorColor: Colors.green,
                  style: TextStyle(color: fontColor),
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock_person_rounded),
                    labelText: 'Confirm Password *',
                    labelStyle: TextStyle(color: fontColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                  obscureText: true,
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


                // Sign up button
                const SizedBox(height: 16.0),
                // ElevatedButton(
                //   onPressed: () {
                //     _signUp();
                //   },
                //   style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all(Colors.green),                    
                //   ),
                //   child: const Text(
                //     'Sign Up',
                //     style: TextStyle(
                //       color: Color.fromARGB(255, 255, 255, 255),
                //       fontFamily: 'Roboto',
                //     ),
                //   ),
                // ),


                Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _signUp();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Set button's background color here
                            padding: const EdgeInsets.all(25),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              ),
                          ),
                        ),
                      ),
                    ],
                  ),

                // Sign in link
                const SizedBox(height: 50.0),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the sign-in page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontFamily: 'Roboto',
                        ),
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                          ),
                          TextSpan(
                            text: "Sign in now.",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold, 
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
