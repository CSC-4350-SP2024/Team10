import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinytaskapp/processTasks/editTask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../settings/settings.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/themes/theme.dart';

// int maxTasks = 4; // Maximum number of tasks that can be displayed at once.
Color fontColor = Color.fromARGB(255, 255, 255,
    255); // Styles for the app are stored in variables. Could be used for app preferences. Will replace with theme later.
Color backgroundColorT = Color.fromARGB(255, 26, 33, 41);
Color backgroundColorB = Color.fromARGB(255, 31, 48, 66);
Color navBackgroundColor = Color.fromARGB(255, 37, 55, 73);

class HomeContentScreen extends StatefulWidget {
  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  late final TextEditingController searchController;
  String searchText = "";
  int? userMaxTasks;
  bool isLoading = true;
  late Future<void> _findMaxTasksFuture;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text;
      });
    });
    _findMaxTasksFuture = _findMaxTasks();
  }

  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _findMaxTasks() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userCredentialID = currentUser!.uid;

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredentialID)
        .get();

    int userMaxTasks = userSnapshot['maxTasks'];

    setState(() {
      this.userMaxTasks = userMaxTasks;
      // isLoading = false;
    });
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
        body: FutureBuilder(
          future: _findMaxTasksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  /* Padding(
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
              */
                  const SizedBox(
                      height: 20), // Add some space below the search bar
                  Expanded(
                    child: TaskList(maxTasks: userMaxTasks ?? 4),
                  ),
                  const SizedBox(height: 20), // Add some space below the list
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final int maxTasks;

  const TaskList({super.key, required this.maxTasks});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool isCompleted = false;
  bool showCompletedGif = false;

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

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...',
              style: TextStyle(color: Colors.white));
        }
        User? currentUser = FirebaseAuth.instance.currentUser;
        String userCredentialID = currentUser!.uid;

        final filteredTasks = snapshot.data!.docs.where((task) {
          final taskName = task['name'] as String?;
          final taskDescription = task['desc'] as String?;
          final taskUser = task['userID'] as String?;
          final taskDueTimestamp = task['due'] as Timestamp?;
          final isTaskDaily = task['isDaily'] as bool? ?? false;
          final isTaskWeekly = task['isWeekly'] as bool? ?? false;
          final isRecurring = task['isRecurring'] as bool? ?? false;
          final isCompleted = task['isComplete'] as bool? ?? false;
          final taskCompletedOn = task['completedOn'] as Timestamp?;
          final weeklyDaysList = task['weeklyDays'] as List<dynamic>? ?? [];
          final currentWeekdayString =
              DateFormat('EEEE').format(DateTime.now());
          final today = DateTime.now();
          final todayWithoutTime = DateTime(today.year, today.month, today.day);

          bool isIncludedInWeeklyDays(List<dynamic> weeklyDaysList) {
            return weeklyDaysList.contains(currentWeekdayString);
          }

          if (isCompleted &&
              (isTaskDaily ||
                  (isTaskWeekly && isIncludedInWeeklyDays(weeklyDaysList)))) {
            if (taskCompletedOn != null) {
              DateTime completedOn = DateTime.fromMillisecondsSinceEpoch(
                  taskCompletedOn.millisecondsSinceEpoch);
              completedOn = DateTime(completedOn.year, completedOn.month,
                  completedOn.day); // Removes time from date

              if (todayWithoutTime.isAfter(completedOn) && isTaskDaily) {
                task.reference.update({'isComplete': false}).catchError(
                  (error) {
                    // Handle error while updating task
                    print("Failed to mark task as incomplete: $error");
                  },
                );
              } else if (!(todayWithoutTime.isAtSameMomentAs(completedOn)) &&
                  isTaskWeekly) {
                task.reference.update({'isComplete': false}).catchError(
                  (error) {
                    // Handle error while updating task
                    print("Failed to mark task as incomplete: $error");
                  },
                );
              }
            }
          }

          if (isCompleted) {
            return false;
          }

          if (isRecurring) {
            return taskName != null &&
                taskDescription != null &&
                taskUser == userCredentialID &&
                ((isTaskWeekly && isIncludedInWeeklyDays(weeklyDaysList)) ||
                    isTaskDaily);
          } else {
            return taskName != null &&
                taskDescription != null &&
                taskUser == userCredentialID &&
                _isDue(taskDueTimestamp);
          }
        }).toList();

        if (filteredTasks.isEmpty) {
          showCompletedGif = true;
        } else {
          showCompletedGif = false;
        }

        if (showCompletedGif) {
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

        // Sort tasks by urgency. Urgent tasks always shown first.
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
            itemCount: widget.maxTasks < filteredTasks.length
                ? widget.maxTasks
                : filteredTasks.length,
            itemBuilder: (context, index) {
              final currentTask = filteredTasks[index];
              final taskTitle = currentTask['name'] ?? " ";
              final isCompleted = currentTask['isComplete'] ?? false;
              final isUrgent = currentTask['isUrgent'] ?? false;
              //final isDaily = currentTask['isDaily'] ?? false;
              final isRecurring = currentTask['isRecurring'] ?? false;
              //final completedOn = currentTask['completedOn'] as Timestamp?;

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
                      maxLines: 1,
                      style: TextStyle(
                        color: isUrgent ? Colors.black : Colors.white,
                        fontSize: 20,
                        fontWeight:
                            isUrgent ? FontWeight.w400 : FontWeight.w400,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    leading: GestureDetector(
                      onTap: () async {
                        if (await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirmation",
                                  style: TextStyle(color: fontColor)),
                              content: Text("Mark task as completed?",
                                  style: TextStyle(color: fontColor)),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(
                                        false); // Dismiss the dialog and return false
                                  },
                                  child: Text("No",
                                      style: TextStyle(color: fontColor)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Add your action here
                                    Navigator.of(context).pop(
                                        true); // Dismiss the dialog and return true
                                  },
                                  child: const Text("Yes",
                                      style: TextStyle(color: Colors.green)),
                                ),
                              ],
                              backgroundColor: backgroundColorT,
                            );
                          },
                        )) {
                          if (!(isRecurring)) {
                            currentTask.reference.delete();
                          }
                          currentTask.reference.update(
                            {
                              'isComplete': true,
                              'completedOn': Timestamp.now()
                            },
                          ).catchError((error) {
                            // Handle error while updating task
                            print("Failed to mark task as completed: $error");
                          });
                        }
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
