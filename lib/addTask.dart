import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
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
  List<bool> weeklyDaysSelection = [false, false, false, false, false, false, false];
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        unselectedWidgetColor: navBackgroundColor, // Set unselected color of checkboxes and switches
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text('Add Task', style: TextStyle(color: fontColor)),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task',
                style: TextStyle(color: fontColor, fontSize: 16.0, fontFamily: 'Roboto'),
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
                style: TextStyle(color: fontColor, fontSize: 16.0, fontFamily: 'Roboto'),
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
                style: TextStyle(color: fontColor, fontSize: 16.0, fontFamily: 'Roboto'),
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
                      dateController.text = '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
                    });
                  }
                },
                child: AbsorbPointer(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0), // Adjusted padding
                    decoration: BoxDecoration(
                      color: navBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: dateController,
                      style: TextStyle(color: fontColor),
                      cursorColor: fontColor,
                      decoration: InputDecoration(
                        border: InputBorder.none, // Set the border to none to make it transparent
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent), // Set the border color to transparent
                        ),
                        suffixIcon: Icon(Icons.calendar_today, color: fontColor),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  SizedBox(width: 0.0),
                  Text('Recurring:', style: TextStyle(color: fontColor, fontSize: 16.0, fontFamily: 'Roboto')),
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
                  title: Text('Repeat Daily', style: TextStyle(color: fontColor, fontSize: 16.0, fontFamily: 'Roboto')),
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
                  title: Text('Repeat Weekly', style: TextStyle(color: fontColor, fontSize: 16.0, fontFamily: 'Roboto')),
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
                  Text('Choose Day(s):', style: TextStyle(color: fontColor, fontSize: 16.0, fontFamily: 'Roboto')),
                  Wrap(
                    spacing: 8.0,
                    children: List.generate(
                      7,
                      (index) => FilterChip(
                        label: Text(
                          _getDayOfWeek(index),
                          style: TextStyle(color: weeklyDaysSelection[index] ? fontColor : fontColor, fontSize: 16.0),
                        ),
                        selected: weeklyDaysSelection[index],
                        onSelected: (selected) {
                          setState(() {
                            weeklyDaysSelection[index] = selected;
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
            onPressed: () {
              // when clicked, should save input to database
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(navBackgroundColor),
            ),
            child: Text(
              'Add',
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
}
