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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  Future<void>? _userProfileFuture;

  bool isDarkModeEnabled = true;
  int? maxTasks;
  String username = '';
  String firstName = '';
  String lastName = '';
  DateTime? birthday;
  DateTime? _selectedDate;
  String? gender = '';
  String selectedOption = 'Normal (5 Tasks)';

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _getUserProfile();
    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
  }

  // Prefill the text fields with the user's current information
  Future<void> _getUserProfile() async {
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
      username =
          data['username'] ?? (data['firstName'][0] + data['lastName'][0]);
      gender = data['gender'] ?? " ";
      birthday = data['birthday'] != ''
          ? (data['birthday'] as Timestamp).toDate()
          : null;
      _selectedDate = birthday;
      selectedOption = getSelectedOption(maxTasks!);
      _usernameController.text = username;
      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
      _genderController.text = gender ?? '';
    });
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

  Future<void> _updateProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'username': _usernameController.text,
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'birthday': _selectedDate ?? birthday,
      'maxTasks': convertMaxTasks(selectedOption),
      'gender': _genderController.text,
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userProfileFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

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
                            Icon(Icons.account_circle,
                                size: 80, color: fontColor),
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
                      Divider(color: fontColor),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: fontColor)),
                        style: TextStyle(color: fontColor),
                      ), // Applying fontColor to the divider
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
                                ? DateFormat('MM/dd/yyyy')
                                    .format(_selectedDate!)
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
                      Text(
                        'How many tasks do you want displayed daily?',
                        style: TextStyle(color: fontColor),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selectedOption,
                            dropdownColor: backgroundColor, // Default value
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              border: OutlineInputBorder(),
                            ),
                            items: <String>[
                              'Low (3 Tasks)',
                              'Normal (5 Tasks)',
                              'Overachiever (8 Tasks)'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(color: fontColor)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              selectedOption = newValue!;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _updateProfile();
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
      },
    );
  }
}
