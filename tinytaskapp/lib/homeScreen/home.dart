import 'package:flutter/material.dart';

class HomeContentScreen extends StatefulWidget {
  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  Color fontColor = Color.fromARGB(255, 255, 255,
      255); // Styles for the app are stored in variables. Could be used for app preferences. Will replace with theme later.
  Color backgroundColor = Color.fromARGB(255, 26, 33, 41);
  Color navBackgroundColor = Color.fromARGB(255, 37, 55, 73);

  final List<String> incompleteTasks = <String>[
    // Prototype home will features list of tasks stored locally
    'Throw out the trash',
    'Feed cat',
    'Cloud Computing HW Due',
    'Clip digital coupons',
    'Drink 2 liters of water',
  ];

  final List<String> completeTasks = <String>[
    // Prototype home will features list of tasks stored locally
    'Cut hair',
    'Go to gym',
    'Get a good nap in before class',
  ];

  List<bool> taskCompletionStatus = List.filled(5,
      false); // Initial completion status for each task. They are not finished until user does them.
  Icon checkOff = const Icon(Icons.check_circle_rounded, color: Colors.green);
  Icon checkOn =
      const Icon(Icons.radio_button_unchecked_rounded, color: Colors.green);

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
              child: ListView.builder(
                // ListView.builder is used to create a list of tasks dynamically based on the length of the tasks list
                itemCount: incompleteTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(
                        bottom: 20), // The space between each task.
                    decoration: BoxDecoration(
                      color: navBackgroundColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      title: Text(
                        incompleteTasks[index],
                        style: TextStyle(color: fontColor),
                      ),
                      leading: GestureDetector(
                        onTap: () {
                          setState(() {
                            taskCompletionStatus[index] =
                                !taskCompletionStatus[index];
                          });
                        },
                        child: taskCompletionStatus[index]
                            ? checkOff
                            : checkOn, // Change icon based on completion status
                      ),
                      trailing: Icon(
                        Icons.more_vert,
                        color: fontColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
