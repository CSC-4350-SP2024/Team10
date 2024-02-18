import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinytaskapp/processTasks/editTask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

int maxTasks = 3; // Maximum number of tasks that can be displayed at once.
String currentUserId =
    "ray"; // Replace "Humayra" with the current user's ID (from Firebase Authentication)
Color fontColor = Color.fromARGB(255, 255, 255,
    255); // Styles for the app are stored in variables. Could be used for app preferences. Will replace with theme later.
Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
Color navBackgroundColor = Color.fromARGB(255, 37, 55, 73);

class HomeContentScreen extends StatefulWidget {
  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  late final TextEditingController searchController;
  String searchText = "";

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text;
      });
    });
  }

  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onSearchTextChanged() {
    setState(() {
      searchText = searchController.text;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        // title: const Text('Tiny Tasks'),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Today is ${DateFormat('EEEE').format(DateTime.now())}",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: fontColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'To do',
              style: TextStyle(
                fontSize: 24,
                color: fontColor,
              ),
            ),
          ),
          const SizedBox(height: 20), // Add some space below the header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                isDense: true,
                fillColor: navBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Add some space below the search bar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TaskList(searchText: searchText),
            ),
          ),
          const SizedBox(height: 20), // Add some space below the list
        ],
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final String searchText;

  const TaskList({Key? key, required this.searchText}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool _isDue(Timestamp? currTaskDueTimestamp) {
    if (currTaskDueTimestamp == null) {
      return false;
    }
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(currTaskDueTimestamp.toDate().year,
        currTaskDueTimestamp.toDate().month, currTaskDueTimestamp.toDate().day);
    return today.isAtSameMomentAs(dueDate);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Uh oh! Something went wrong.');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No tasks found.');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          final query = widget.searchText.toLowerCase();
          final filteredTasks = snapshot.data!.docs.where((task) {
            final taskName = task['name'] as String?;
            final taskDescription = task['desc'] as String?;
            final taskUser = task['userID'] as String?;
            final taskDueTimestamp = task['due'] as Timestamp?;

            if (query.isEmpty) {
              taskName != null &&
                  taskDescription != null &&
                  taskUser == currentUserId &&
                  _isDue(taskDueTimestamp);
            }

            return taskName != null &&
                taskDescription != null &&
                (taskName.toLowerCase().contains(query) ||
                    taskDescription.toLowerCase().contains(query)) &&
                taskUser == currentUserId &&
                _isDue(
                    taskDueTimestamp); // Only show tasks that belong to the current user.
          }).toList(); // filteredTasks returns a filtered list of items based on userID and further filtered by the search text.

          return ListView.builder(
            itemCount: filteredTasks.length > maxTasks
                ? maxTasks
                : filteredTasks.length,
            itemBuilder: (context, index) {
              final currentTask = filteredTasks[index];
              final taskTitle = currentTask['name'] ?? " ";
              final isCompleted = currentTask['isComplete'] ?? false;
              final isUrgent = currentTask['isUrgent'] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isUrgent
                      ? Color.fromARGB(255, 255, 187, 0)
                      : navBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  title: Text(
                    taskTitle,
                    style: TextStyle(
                      color: isUrgent ? Colors.black : Colors.white,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: GestureDetector(
                    onTap: () {
                      currentTask.reference
                          .update({'isComplete': !isCompleted});
                    },
                    child: isCompleted
                        ? const Icon(Icons.check_circle_rounded,
                            color: Colors.green)
                        : const Icon(Icons.radio_button_unchecked_rounded,
                            color: Colors.green),
                  ),
                  onLongPress: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditTaskScreen(
                          currentTask: currentTask,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        });
  }
}
