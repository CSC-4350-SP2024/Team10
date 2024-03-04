import 'package:flutter/material.dart';

class ExtendedTaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Tasks'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with the actual number of items
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Task $index'),
            subtitle: Text('Task description'),
            onTap: () {
              // Handle item tap
            },
          );
        },
      ),
    );
  }
}
