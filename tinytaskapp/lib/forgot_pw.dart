import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'nav.dart';
import 'register.dart';
import '/themes/theme.dart';

class ForgotPw extends StatefulWidget {
 const ForgotPw({Key? key}) : super(key:key);

 @override 
 State<ForgotPw> createState() => _ForgotPwState();
}

class _ForgotPwState extends State<ForgotPw> {

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }


  // Future<void> passwordReset() async {
  //   try {
  //     // Check if the user exists
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: 'password', // Provide a dummy password as signInWithEmailAndPassword requires a non-empty password
  //     );

  //     // If the user exists, send the password reset email
  //     await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());

  //     // displays this message if the user was found and the email was sent
  //     showDialog(
  //       context: context, 
  //       builder: (context) {
  //         return AlertDialog(
  //           content: Text('We sent you an email with a link to reset your password. Please check your email. If you do not receive an email, check your spam folder or try again.'),
  //         );
  //       }
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     // displays this message is the email wasnt found in our database
  //     print(e.toString());
  //     if (e.code == 'user-not-found') {
  //       showDialog(
  //         context: context, 
  //         builder: (context) {
  //           return AlertDialog(
  //             content: Text('The provided email is not registered. Please check your email address and try again.'),
  //           );
  //         }
  //       );
  //     } else {
  //       // general error message
  //       showDialog(
  //         context: context, 
  //         builder: (context) {
  //           return AlertDialog(
  //             content: Text('An error occurred. Please check your email address and try again.'),
  //           );
  //         }
  //       );
  //     }
  //   }
  // }


  Future<void> passwordReset() async {
  try {
    // Send the password reset email
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          content: Text('We sent you an email with a link to reset your password. Please check your email. If you do not receive an email, check your spam folder or try again.'),
        );
      }
    );
  } on FirebaseAuthException catch (e) {
    print(e.toString());
    if (e.code == 'user-not-found') {
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: Text('The provided email is not registered. Please check your email address and try again.'),
          );
        }
      );
    } else {
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: Text('An error occurred. Please try again.'),
          );
        }
      );
    }
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/tinytasklogo.png', // Path to your image asset
                    width: 300, // Set the width as needed
                    height: 117, // Set the height as needed
                  ),
                  const SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: const Text(
                      'Enter the email address associated with your account and we will send you an email with instructions to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white), 
                    ),
                  ),

                  
                  //email field
                  const SizedBox(height: 5.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        //email = value;
                      });
                    },
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hoverColor: Colors.green,
                      hintText: 'Email',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                    ),
                  ),



                  // Reset password button
                  const SizedBox(height:10),
                  // MaterialButton(
                  //   onPressed: (){},
                  //   child: Text('Reset Password'),
                  //   color: Colors.green,
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            passwordReset();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Set button's background color here
                            padding: const EdgeInsets.all(25),
                          ),
                          child: const Text(
                            'Reset Password',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
            ),
            )
          ),
        ),
      );
    }
}