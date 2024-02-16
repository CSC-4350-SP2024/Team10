import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int maxTasks = 3; // Maximum number of tasks that can be displayed at once.
Color fontColor = Color.fromARGB(255, 255, 255,
    255); // Styles for the app are stored in variables. Could be used for app preferences. Will replace with theme later.
Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
Color navBackgroundColor = Color.fromARGB(255, 37, 55, 73);

class HomeContentScreen extends StatefulWidget {
  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'To do',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: fontColor,
              ),
            ),
          ),
          const SizedBox(height: 20), // Add some space below the header
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TaskList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
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

          return ListView.builder(
            itemCount: maxTasks,
            itemBuilder: (context, index) {
              final currentTask = snapshot.data!.docs[index];
              final taskTitle = currentTask['name'] ?? " ";
              final isCompleted = currentTask['isComplete'] ?? false;
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: navBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  title: Text(
                    taskTitle,
                    style: TextStyle(
                      color: Colors.white,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: GestureDetector(
                    onTap: () {
                      // Updates the task's completion status when the user taps the checkbox.
                      currentTask.reference
                          .update({'isComplete': !isCompleted});
                    },
                    child: isCompleted
                        ? const Icon(Icons.check_circle_rounded,
                            color: Colors.green)
                        : const Icon(Icons.radio_button_unchecked_rounded,
                            color: Colors.green),
                  ),
                  trailing: Icon(Icons.more_vert, color: Colors.white),
                ),
              );
            },
          );
        });
  }
}
