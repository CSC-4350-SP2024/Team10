import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinytaskapp/settings/editSettings';
import '../userDirectory.dart';

Color fontColor = Color.fromARGB(255, 255, 255, 255);
Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
Color settingsBackgroundColor = Color.fromARGB(255, 37, 55, 73);

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkModeEnabled = false;
  String selectedOption = 'Normal (5 Tasks)';

  final String username = "BM";
  final String firstName = "Brayan";
  final String lastName = "Maldonado";
  final DateTime? birthday = DateTime(1990, 10, 15);
  final String? gender = 'Male';

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

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MM/dd/yyyy');
    return Scaffold(
      appBar: AppBar(
        title: Text('View Settings', style: TextStyle(color: fontColor)),
        backgroundColor:
            backgroundColor, // Applying backgroundColor to the app bar
        iconTheme: IconThemeData(color: fontColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserDirectoryScreen(),
                ),
              );
            },
          ),
        ], // Change back button color here
      ),
      body: Container(
        color: backgroundColor, // Applying settingsBackgroundColor to the body
        child: Column(
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
                  null;
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
