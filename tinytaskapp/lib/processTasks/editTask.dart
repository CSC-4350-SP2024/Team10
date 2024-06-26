import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinytaskapp/homeScreen/home.dart';
import 'package:tinytaskapp/nav.dart';
import '/themes/theme.dart';

class EditTaskScreen extends StatefulWidget {
  final QueryDocumentSnapshot currentTask;

  EditTaskScreen({required this.currentTask});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  Color fontColor = Color.fromARGB(255, 255, 255, 255);
  Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
  Color navBackgroundColor = Color.fromARGB(255, 37, 55, 73);
  Color accentColor = Colors.green;

  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool isRecurring = false;
  bool repeatDaily = false;
  bool repeatWeekly = false;
  bool isUrgent = false;
  List<String> weeklyDaysSelection = [];
  DateTime? selectedDate;

  bool isTaskNameEmpty = false;
  bool isDescriptionEmpty = false;

  @override
  void initState() {
    super.initState();
    // Populate fields with existing task data
    taskNameController.text = widget.currentTask['name'];
    taskDescriptionController.text = widget.currentTask['desc'];
    Timestamp? dueTimestamp = widget.currentTask['due'];
    if (dueTimestamp != null) {
      selectedDate = dueTimestamp.toDate();
      dateController.text =
          '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
    }
    isUrgent = widget.currentTask['isUrgent'];
    isRecurring = widget.currentTask['isRecurring'];
    repeatDaily = widget.currentTask['isDaily'];
    repeatWeekly = widget.currentTask['isWeekly'];
    weeklyDaysSelection = List<String>.from(widget.currentTask['weeklyDays']);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackground(Theme.of(context)),
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor:
              navBackgroundColor, // Set unselected color of checkboxes and switches
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: "Edit ${widget.currentTask['name']}",
            isReturnable: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task',
                  style: TextStyle(
                      color: fontColor, fontSize: 16.0, fontFamily: 'Roboto'),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: navBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: taskNameController,
                    style: TextStyle(color: fontColor),
                    cursorColor: isTaskNameEmpty ? Colors.red : fontColor,
                    onChanged: (value) {
                      setState(() {
                        isTaskNameEmpty = value.isEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorText: isTaskNameEmpty ? 'Required' : null,
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Description',
                  style: TextStyle(
                      color: fontColor, fontSize: 16.0, fontFamily: 'Roboto'),
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 120.0, // Adjusted height
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: navBackgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: taskDescriptionController,
                    style: TextStyle(color: fontColor),
                    cursorColor: isDescriptionEmpty ? Colors.red : fontColor,
                    onChanged: (value) {
                      setState(() {
                        isDescriptionEmpty = value.isEmpty;
                      });
                    },
                    maxLines: null, // Allow multiple lines
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      errorText: isDescriptionEmpty ? 'Required' : null,
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Select Date',
                  style: TextStyle(
                      color: fontColor, fontSize: 16.0, fontFamily: 'Roboto'),
                ),
                SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData(
                            colorScheme: const ColorScheme.dark(
                              primary: Colors.green,
                              surface: Color.fromARGB(255, 19, 16, 41),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                        dateController.text =
                            '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0), // Adjusted padding
                      decoration: BoxDecoration(
                        color: navBackgroundColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextFormField(
                        controller: dateController,
                        style: TextStyle(color: fontColor),
                        decoration: InputDecoration(
                          border: InputBorder
                              .none, // Set the border to none to make it transparent
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .transparent), // Set the border color to transparent
                          ),
                          suffixIcon:
                              Icon(Icons.calendar_today, color: fontColor),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    SizedBox(width: 0.0),
                    Text('Urgent:',
                        style: TextStyle(
                            color: fontColor,
                            fontSize: 16.0,
                            fontFamily: 'Roboto')),
                    SizedBox(width: 8.0), // Add space between text and toggle
                    Switch(
                      value: isUrgent,
                      onChanged: (value) {
                        setState(() {
                          isUrgent = value;
                          if (!isUrgent) {
                            repeatDaily = false;
                            repeatWeekly = false;
                          }
                        });
                      },
                      activeTrackColor: accentColor,
                      inactiveThumbColor: fontColor,
                      inactiveTrackColor: navBackgroundColor,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 0.0),
                    Text('Recurring:',
                        style: TextStyle(
                            color: fontColor,
                            fontSize: 16.0,
                            fontFamily: 'Roboto')),
                    SizedBox(width: 8.0), // Add space between text and toggle
                    Switch(
                      value: isRecurring,
                      onChanged: (value) {
                        setState(() {
                          isRecurring = value;
                          if (!isRecurring) {
                            repeatDaily = false;
                            repeatWeekly = false;
                          }
                        });
                      },
                      activeTrackColor: accentColor,
                      inactiveThumbColor: fontColor,
                      inactiveTrackColor: navBackgroundColor,
                    ),
                  ],
                ),
                if (isRecurring) ...[
                  SizedBox(height: 16.0),
                  CheckboxListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Repeat Daily',
                            style: TextStyle(
                                color: fontColor,
                                fontSize: 16.0,
                                fontFamily: 'Roboto'),
                          ),
                          if (isRecurring && !repeatDaily && !repeatWeekly) 
                            TextSpan(
                              text: ' Required',
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                    value: repeatDaily,
                    activeColor: accentColor,
                    onChanged: (value) {
                      setState(() {
                        repeatDaily = value!;
                        if (repeatDaily) {
                          repeatWeekly = false;
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Repeat Weekly',
                            style: TextStyle(
                                color: fontColor,
                                fontSize: 16.0,
                                fontFamily: 'Roboto'),
                          ),
                          if (isRecurring && !repeatDaily && !repeatWeekly) 
                            TextSpan(
                              text: ' Required',
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                    value: repeatWeekly,
                    activeColor: accentColor,
                    onChanged: (value) {
                      setState(() {
                        repeatWeekly = value!;
                        if (repeatWeekly) {
                          repeatDaily = false;
                        }
                      });
                    },
                  ),
                  if (repeatWeekly) ...[
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text('Choose Day(s):',
                            style: TextStyle(
                                color: fontColor,
                                fontSize: 16.0,
                                fontFamily: 'Roboto')),
                        if (weeklyDaysSelection.isEmpty) 
                          Text(
                            ' Required',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: List.generate(
                        7,
                        (index) => FilterChip(
                          label: Text(
                            _getDayOfWeek(index),
                            style: TextStyle(
                                color: weeklyDaysSelection
                                        .contains(_getDayOfWeek(index))
                                    ? fontColor
                                    : fontColor,
                                fontSize: 16.0),
                          ),
                          selected: weeklyDaysSelection
                              .contains(_getDayOfWeek(index)),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                weeklyDaysSelection.add(_getDayOfWeek(index));
                              } else {
                                weeklyDaysSelection.removeWhere((String name) =>
                                    name == _getDayOfWeek(index));
                              }
                            });
                          },
                          checkmarkColor: accentColor,
                          selectedColor: navBackgroundColor,
                          backgroundColor: navBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: navBackgroundColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      bool confirmDelete = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Confirmation",
                              style: TextStyle(color: fontColor),
                            ),
                            content: Text(
                              "Are you sure you want to delete this task?",
                              style: TextStyle(color: fontColor),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: fontColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                            backgroundColor: backgroundColor,
                          );
                        },
                      );

                      if (confirmDelete == true) {
                        await deleteTask();
                        // Navigate back to the home screen
                        Navigator.pop(context);

                        // Show snackbar on the home screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Task deleted',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                            action: SnackBarAction(
                              label: 'Undo',
                              textColor: Colors.white,
                              onPressed: () {
                                // Restore the deleted task
                                restoreDeletedTask();
                              },
                            ),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(navBackgroundColor),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 16), // Add spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (taskNameController.text.isEmpty ||
                          taskDescriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Required fields not filled',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      // Check for recurring tasks
                      if (isRecurring && !repeatDaily && !repeatWeekly) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Must select recurring frequency',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Check for repeat weekly days
                      if (repeatWeekly && weeklyDaysSelection.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Must select at least one day',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      await updateTask();
                      // Dismiss keyboard
                      FocusScope.of(context).unfocus();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(color: fontColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDayOfWeek(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        return '';
    }
  }

  Future<void> updateTask() async {
    String taskName = taskNameController.text;
    String taskDesc = taskDescriptionController.text;
    DateTime? taskDate = selectedDate;

    Map<String, dynamic> taskData = {
      'name': taskName,
      'desc': taskDesc,
      'due': taskDate,
      'isUrgent': isUrgent,
      'isRecurring': isRecurring,
      'isDaily': repeatDaily,
      'isWeekly': repeatWeekly,
      'weeklyDays': weeklyDaysSelection,
    };

    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.currentTask.id)
          .update(taskData);
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteTask() async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.currentTask.id)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> restoreDeletedTask() async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.currentTask.id)
          //.set(widget.currentTask.data());
          .set(widget.currentTask.data() as Map<String, dynamic>);
    } catch (e) {
      print(e);
    }
  }
}
