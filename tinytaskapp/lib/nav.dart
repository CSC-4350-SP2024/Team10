import 'package:flutter/material.dart';
import 'homeScreen/home.dart';
import 'processTasks/addTask.dart';
import 'settings/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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

  void _onNavIndexChanged(int newIndex) {
    setState(() {
      _navIndex = newIndex;
    });
  }

  final List<Widget> _screens = [
    const HomeContentScreen(),
    AddTaskScreen(),
    const SettingsScreen(),
  ];

  Color fontColor = const Color.fromARGB(255, 255, 255,
      255); // Styles for the app are stored in variables. Could be used for app preferences. Will replace with theme later.
  Color backgroundColor = const Color.fromARGB(255, 26, 33, 41);
  Color navBackgroundColor = const Color.fromARGB(255, 37, 55, 73);

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
            icon: Icon(Icons.add_circle),
            label: 'Add Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _navIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 204, 204, 204),
        unselectedIconTheme:
            const IconThemeData(color: Color.fromARGB(255, 131, 131, 131)),
        onTap: _onNavTapped,
      ),
    );
  }
}
