// TODO - add floating button property to 'Update' button in editTask as seen in 'Add' button in addTask
// TODO - automatically dismiss keyboard after inputs into editTask

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return Theme(
      data: ThemeData(
        unselectedWidgetColor:
            navBackgroundColor, // Set unselected color of checkboxes and switches
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text("Edit ${widget.currentTask['name']}",
              style: TextStyle(color: fontColor)),
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
                  cursorColor: fontColor,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
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
                  cursorColor: fontColor,
                  maxLines: null, // Allow multiple lines
                  decoration: const InputDecoration(
                    border: InputBorder.none,
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
                      cursorColor: fontColor,
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
                  title: Text('Repeat Daily',
                      style: TextStyle(
                          color: fontColor,
                          fontSize: 16.0,
                          fontFamily: 'Roboto')),
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
                  title: Text('Repeat Weekly',
                      style: TextStyle(
                          color: fontColor,
                          fontSize: 16.0,
                          fontFamily: 'Roboto')),
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
                  Text('Choose Day(s):',
                      style: TextStyle(
                          color: fontColor,
                          fontSize: 16.0,
                          fontFamily: 'Roboto')),
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
                        selected:
                            weeklyDaysSelection.contains(_getDayOfWeek(index)),
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
          child: ElevatedButton(
            onPressed: () async {
              await updateTask();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(navBackgroundColor),
            ),
            child: Text(
              'Update',
              style: TextStyle(color: fontColor),
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
}
