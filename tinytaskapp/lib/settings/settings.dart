import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './editSettings.dart';
import '../userDirectory.dart';
import '/themes/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

Color fontColor = Color.fromARGB(255, 255, 255, 255);
Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
Color settingsBackgroundColor = Color.fromARGB(255, 26, 33, 41);

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void>? _userProfileFuture;

  bool isDarkModeEnabled = true;
  int? maxTasks;
  String username = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  DateTime? birthday;
  String? gender = '';
  String selectedOption = 'Normal (5 Tasks)';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userProfileFuture = _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    // Get the current user's profile information
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> userProfile =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      final Map<String, dynamic> data = userProfile.data()!;
      setState(() {
        isDarkModeEnabled = data['hasDarkTheme'] ?? true;
        maxTasks = data['maxTasks'] ?? 5;
        selectedOption = getSelectedOption(maxTasks!);
        firstName = data['firstName'] ?? " ";
        lastName = data['lastName'] ?? " ";
        email = data['email'] ?? " ";
        username =
            data['username'] ?? (data['firstName'][0] + data['lastName'][0]);
        gender = data['gender'] ?? " ";
        birthday = data['birthday'] != ''
            ? (data['birthday'] as Timestamp).toDate()
            : null;
      });
    } else {
      print('User is null');
    }
  }

  void _signOut() async {
    // Sign out of the user's account and redirect to directory screen.
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserDirectoryScreen()),
        (route) => false,
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  String getSelectedOption(int maxTasks) {
    if (maxTasks == 3) {
      return 'Low (3 Tasks)';
    } else if (maxTasks == 5) {
      return 'Normal (5 Tasks)';
    } else {
      return 'Overachiever (8 Tasks)';
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MM/dd/yyyy');
    return FutureBuilder(
      future: _userProfileFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return Container(
          decoration: gradientBackground(Theme.of(context)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              title: 'View Settings',
              isReturnable: true,
              icon: const Icon(Icons.logout),
              onReturn: _signOut,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.account_circle, size: 80, color: fontColor),
                      SizedBox(height: 10),
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: 20,
                            color:
                                fontColor), // Applying fontColor to the username text
                      ),
                    ],
                  ),
                ),
                Divider(color: fontColor), // Applying fontColor to the divider
                ListTile(
                  title: Text('First Name',
                      style: TextStyle(
                          color: fontColor)), // Applying fontColor to the text
                  trailing: Text(firstName,
                      style: TextStyle(
                          color: fontColor,
                          fontSize: 16)), // Applying fontColor to the text
                ),
                ListTile(
                  title: Text('Last Name',
                      style: TextStyle(
                          color: fontColor)), // Applying fontColor to the text
                  trailing: Text(lastName,
                      style: TextStyle(
                          color: fontColor,
                          fontSize: 16)), // Applying fontColor to the text
                ),
                ListTile(
                  title: Text('Email',
                      style: TextStyle(
                          color: fontColor)), // Applying fontColor to the text
                  trailing: Text(email,
                      style: TextStyle(
                          color: fontColor,
                          fontSize: 16)), // Applying fontColor to the text
                ),
                ListTile(
                  title: Text('Birthday',
                      style: TextStyle(
                          color: fontColor)), // Applying fontColor to the text
                  trailing: Text(
                      birthday != null ? dateFormat.format(birthday!) : 'N/A',
                      style: TextStyle(color: fontColor, fontSize: 16)),
                ),
                ListTile(
                  title: Text('Gender',
                      style: TextStyle(
                          color: fontColor)), // Applying fontColor to the text
                  trailing: Text(gender ?? 'Empty',
                      style: TextStyle(
                          color: fontColor,
                          fontSize: 16)), // Applying fontColor to the text
                ),
                ListTile(
                  title: Text('Number of Tasks Displayed',
                      style: TextStyle(color: fontColor)),
                  trailing: Text('$selectedOption',
                      style: TextStyle(color: fontColor, fontSize: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditSettingsScreen(
                                onProfileUpdated: _getUserProfile,
                              )));
                    },
                    child: Text('Edit Profile',
                        style: TextStyle(color: fontColor)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
