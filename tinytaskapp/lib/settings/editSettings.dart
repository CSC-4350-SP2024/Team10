import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/themes/theme.dart';
import 'settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Color fontColor = Color.fromARGB(255, 255, 255, 255);
Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
Color settingsBackgroundColor = Color.fromARGB(255, 37, 55, 73);

class EditSettingsScreen extends StatefulWidget {
  const EditSettingsScreen({super.key});

  @override
  _EditSettingsScreenState createState() => _EditSettingsScreenState();
}

class _EditSettingsScreenState extends State<EditSettingsScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  late DateTime? _selectedDate;
  late String username;
  late String firstName;
  late String lastName;
  late DateTime? birthday;
  late String? gender;
  late bool isDarkModeEnabled;
  late int maxTasks;

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
    super.initState();
    _getUserProfile();
    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
    _selectedDate = birthday;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackground(Theme.of(context)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: "", isReturnable: true),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
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
                  Divider(
                      color: fontColor), // Applying fontColor to the divider
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: fontColor)),
                    style: TextStyle(color: fontColor),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: fontColor)),
                    style: TextStyle(color: fontColor),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Birthday',
                        labelStyle: TextStyle(color: fontColor),
                        suffixIcon:
                            Icon(Icons.calendar_today, color: fontColor),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('MM/dd/yyyy').format(_selectedDate!)
                            : 'Select a Date',
                        style: TextStyle(color: fontColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _genderController,
                    decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(color: fontColor)),
                    style: TextStyle(color: fontColor),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title:
                        Text('Dark Theme', style: TextStyle(color: fontColor)),
                    trailing: Switch(
                      value: isDarkModeEnabled,
                      onChanged: (value) {
                        setState(() {
                          isDarkModeEnabled = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Save the settings
                    },
                    child: Text('Save Settings',
                        style: TextStyle(color: fontColor)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(backgroundColor),
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
