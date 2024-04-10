import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './editSettings.dart';
import '../userDirectory.dart';
import '/themes/theme.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Color fontColor = Color.fromARGB(255, 255, 255, 255);
Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
Color settingsBackgroundColor = Color.fromARGB(255, 26, 33, 41);

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDarkModeEnabled = true;
  late int maxTasks;
  late String username;
  late String firstName;
  late String lastName;
  late DateTime? birthday;
  late String? gender;
  late String selectedOption;

  void _getUserProfile() async {
    // Get the current user's profile information
    final User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot<Map<String, dynamic>> userProfile =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
    final Map<String, dynamic> data = userProfile.data()!;
    setState(() {
      isDarkModeEnabled = data['hasDarkTheme'] ?? true;
      maxTasks = data['maxTasks'] ?? 5;
      firstName = data['firstName'] ?? " ";
      lastName = data['lastName'] ?? " ";
      username = data['firstName'][0] + data['lastName'][0] ?? " ";
      gender = data['gender'] ?? " ";
      birthday = data['birthday'] != ''
          ? (data['birthday'] as Timestamp).toDate()
          : null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserProfile();
    selectedOption = getSelectedOption(maxTasks);
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

  @override
  Widget build(BuildContext context) {
    _getUserProfile();
    final DateFormat dateFormat = DateFormat('MM/dd/yyyy');
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
              subtitle: Text(firstName,
                  style: TextStyle(
                      color: fontColor)), // Applying fontColor to the text
            ),
            ListTile(
              title: Text('Last Name',
                  style: TextStyle(
                      color: fontColor)), // Applying fontColor to the text
              subtitle: Text(lastName,
                  style: TextStyle(
                      color: fontColor)), // Applying fontColor to the text
            ),
            ListTile(
              title: Text('Birthday',
                  style: TextStyle(
                      color: fontColor)), // Applying fontColor to the text
              subtitle: Text(
                  birthday != null ? dateFormat.format(birthday!) : 'Empty',
                  style: TextStyle(color: fontColor)),
            ),
            ListTile(
              title: Text('Gender',
                  style: TextStyle(
                      color: fontColor)), // Applying fontColor to the text
              subtitle: Text(gender ?? 'Empty',
                  style: TextStyle(
                      color: fontColor)), // Applying fontColor to the text
            ),
            ListTile(
              title: Text('Dark Mode',
                  style: TextStyle(
                      color: fontColor)), // Applying fontColor to the text
              trailing: Switch(
                value: isDarkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    isDarkModeEnabled = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Number of Tasks Displayed',
                  style: TextStyle(color: fontColor)),
              subtitle: DropdownButton<String>(
                value: selectedOption,
                dropdownColor: backgroundColor,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue!;
                  });
                },
                items: <String>[
                  'Low (3 Tasks)',
                  'Normal (5 Tasks)',
                  'Overachiever (8 Tasks)'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: fontColor)),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to edit settings page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditSettingsScreen()));
                    },
                    child: Text('Edit Settings'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
