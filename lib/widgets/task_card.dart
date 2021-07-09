import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String desc;

  TaskCardWidget({this.title = '(Unnamed task)', this.desc = 'No description provided.'});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 32.0,
          horizontal: 24.0,
        ),
        margin: const EdgeInsets.only(
          bottom: 20.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF211551),
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: Text(
                desc,
                style: const TextStyle(
                  color: Color(0xFF86829D),
                  fontSize: 16.0,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ));
  }
}



