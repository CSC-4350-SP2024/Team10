import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '/processTasks/editTask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/themes/theme.dart';
import '/settings/settings.dart';

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
    return Container(
      decoration: gradientBackground(Theme.of(context)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: '',
            isReturnable: false,
            icon: const Icon(Icons.settings),
            navigateTo: SettingsScreen(),
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
          )),
    );
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
            final isRecurring = currentTask['isRecurring'] ?? false;
            final isDaily = currentTask['isDaily'] ?? false;
            final isWeekly = currentTask['isWeekly'] ?? false;
            final weeklyDaysList =
                (currentTask['weeklyDays'] as List<dynamic>).cast<String>() ??
                    [];

            String dueDate = " ";

            if (dueTimeStamp != null) {
              final dueDateTime = (dueTimeStamp as Timestamp).toDate();
              final dueDateFormatted =
                  "${dueDateTime.month}/${dueDateTime.day}";
              dueDate = dueDateFormatted;
            }

            String getNextClosestDay(List<String> weeklyDaysList) {
              for (int i = 0; i < 7; i++) {
                final nextDay = DateTime.now().add(Duration(days: i));
                final nextDayString = DateFormat('EEEE').format(nextDay);

                if (weeklyDaysList.contains(nextDayString)) {
                  return nextDayString;
                }
              }

              return weeklyDaysList.isNotEmpty ? weeklyDaysList[0] : " ";
            }

            String getDueDateText() {
              if (isDaily) {
                return "Today";
              } else if (isWeekly) {
                return getNextClosestDay(weeklyDaysList);
              } else {
                return "Due: $dueDate";
              }
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
                      color: (isUrgent ? Colors.black : Colors.white),
                      fontSize: 20,
                      fontWeight: isUrgent ? FontWeight.w400 : FontWeight.w300,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  leading: GestureDetector(
                    onTap: () {
                      if (!(isRecurring)) {
                        currentTask.reference.delete();
                      }
                      currentTask.reference.update(
                        {
                          'isComplete': !isCompleted,
                          'completedOn': Timestamp.now()
                        },
                      ).catchError((error) {
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
                    isCompleted ? 'Completed' : getDueDateText(),
                    style: TextStyle(
                      color: !isUrgent
                          ? (isCompleted ? Colors.green : Colors.white)
                          : Colors.black,
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
