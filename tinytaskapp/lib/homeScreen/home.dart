import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinytaskapp/processTasks/editTask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

int maxTasks = 4; // Maximum number of tasks that can be displayed at once.
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

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            backgroundColor,
            const Color.fromARGB(255, 31, 48, 66)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: "Today is ",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: fontColor),
                  ),
                  TextSpan(
                    text: "${DateFormat('EEEE').format(DateTime.now())}",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent[400]!),
                  ),
                ]),
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
              child: TaskList(searchText: searchText),
            ),
            const SizedBox(height: 20), // Add some space below the list
          ],
        ),
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
    final dueDate = DateTime(
      currTaskDueTimestamp.toDate().year,
      currTaskDueTimestamp.toDate().month,
      currTaskDueTimestamp.toDate().day,
    );
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
          return SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'lib/assets/confetti.gif',
                  width: 400,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5),
                const Text(
                  'You\'re all caught up!',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...',
              style: TextStyle(color: Colors.white));
        }

        final query = widget.searchText.toLowerCase();

        final filteredTasks = snapshot.data!.docs.where((task) {
          final taskName = task['name'] as String?;
          final taskDescription = task['desc'] as String?;
          final taskUser = task['userID'] as String?;
          final taskDueTimestamp = task['due'] as Timestamp?;

          if (query.isNotEmpty) {
            return taskName != null &&
                taskDescription != null &&
                taskUser == currentUserId &&
                _isDue(taskDueTimestamp) &&
                (taskName.toLowerCase().contains(query.toLowerCase()) ||
                    taskDescription
                        .toLowerCase()
                        .contains(query.toLowerCase()));
          }

          return taskName != null &&
              taskDescription != null &&
              taskUser == currentUserId &&
              _isDue(taskDueTimestamp);
        }).toList();

        filteredTasks.sort((a, b) {
          bool isUrgentA = a['isUrgent'] ?? false;
          bool isUrgentB = b['isUrgent'] ?? false;

          if (isUrgentA && !isUrgentB) {
            return -1;
          } else if (!isUrgentA && isUrgentB) {
            return 1;
          } else {
            return 0;
          }
        });

        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final currentTask = filteredTasks[index];
              final taskTitle = currentTask['name'] ?? " ";
              final isCompleted = currentTask['isComplete'] ?? false;
              final isUrgent = currentTask['isUrgent'] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: isUrgent
                      ? Color.fromARGB(255, 247, 192, 42)
                      : navBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: 70,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    title: Text(
                      taskTitle,
                      style: TextStyle(
                        color: isUrgent ? Colors.black : Colors.white,
                        fontSize: 20,
                        fontWeight:
                            isUrgent ? FontWeight.w400 : FontWeight.w300,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    leading: GestureDetector(
                      onTap: () {
                        currentTask.reference
                            .update({'isComplete': true}).then((_) {
                          // Task marked as completed, now delete it
                          currentTask.reference.delete();
                        }).catchError((error) {
                          // Handle error while updating task
                          print("Failed to mark task as completed: $error");
                        });
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
