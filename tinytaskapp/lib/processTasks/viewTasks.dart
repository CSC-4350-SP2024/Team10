import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '/processTasks/editTask.dart';
import '/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';

Color fontColor = Color.fromARGB(255, 255, 255,
    255); // Styles for the app are stored in variables. Could be used for app preferences. Will replace with theme later.
Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
Color navBackgroundColor = Color.fromARGB(255, 37, 55, 73);

class ExtendedTaskListScreen extends StatefulWidget {
  @override
  State<ExtendedTaskListScreen> createState() => _ExtendedTaskListScreenState();
}

class _ExtendedTaskListScreenState extends State<ExtendedTaskListScreen> {
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
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          //  crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "All Tasks",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Expanded(
              child: ExtendedTaskList(
                searchText: searchText,
              ),
            ),
          ],
        ));
  }
}

class ExtendedTaskList extends StatefulWidget {
  final String searchText;
  @override
  const ExtendedTaskList({Key? key, required this.searchText})
      : super(key: key);
  State<ExtendedTaskList> createState() => _ExtendedTaskListState();
}

class _ExtendedTaskListState extends State<ExtendedTaskList> {
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

        User? currentUser = FirebaseAuth.instance.currentUser;
        String userCredentialID = currentUser!.uid;

        final query = widget.searchText.toLowerCase();

        final filteredTasks = snapshot.data!.docs.where((task) {
          final taskName = task['name'] as String?;
          final taskDescription = task['desc'] as String?;
          final taskUser = task['userID'] as String?;

          if (query.isNotEmpty) {
            return taskName != null &&
                taskDescription != null &&
                taskUser == userCredentialID &&
                (taskName.toLowerCase().contains(query.toLowerCase()) ||
                    taskDescription
                        .toLowerCase()
                        .contains(query.toLowerCase()));
          }

          return taskName != null &&
              taskDescription != null &&
              taskUser == userCredentialID;
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

        return ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final currentTask = filteredTasks[index];
            final taskTitle = currentTask['name'] ?? " ";
            final isCompleted = currentTask['isComplete'] ?? false;
            final isUrgent = currentTask['isUrgent'] ?? false;
            final dueTimeStamp = currentTask['due'] ?? " ";

            String dueDate = " ";

            if (dueTimeStamp != null) {
              final dueDateTime = (dueTimeStamp as Timestamp).toDate();
              final dueDateFormatted =
                  "${dueDateTime.month}/${dueDateTime.day}";
              dueDate = dueDateFormatted;
            }

            if (currentTask.reference == null) {
              return const SizedBox.shrink();
            }

            return Container(
              //   margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isUrgent
                    ? Color.fromARGB(255, 247, 192, 42)
                    : navBackgroundColor,
                //  borderRadius: BorderRadius.circular(20),
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
                      fontWeight: isUrgent ? FontWeight.w400 : FontWeight.w300,
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
                  trailing: Text(
                    "Due: $dueDate",
                    style: TextStyle(
                      color: isUrgent ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
        );
      },
    );
  }
}
