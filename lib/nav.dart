import 'package:flutter/material.dart';
import 'home/home.dart';
import 'addTask.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  void _onNavTapped(int index) {
    setState(() {
      _navIndex = index;
    });
  }

  final List<Widget> _screens = [
    HomeContentScreen(),
    AddTaskScreen(),
    SettingsScreen(),
  ];

  Color fontColor = Color.fromARGB(255, 255, 255,
      255); // Styles for the app are stored in variables. Could be used for app preferences. Will replace with theme later.
  Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
  Color navBackgroundColor = Color.fromARGB(255, 37, 55, 73);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_navIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: navBackgroundColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _navIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromARGB(255, 204, 204, 204),
        unselectedIconTheme:
            IconThemeData(color: Color.fromARGB(255, 131, 131, 131)),
        onTap: _onNavTapped,
      ),
    );
  }
}
