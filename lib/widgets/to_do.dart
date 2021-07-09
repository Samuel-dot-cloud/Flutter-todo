import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;

  TodoWidget(this.isDone, {this.text = '(Unnamed Todo)'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 20.0,
            height: 20.0,
            margin: const EdgeInsets.only(
              right: 12.0,
            ),
            decoration: BoxDecoration(
              color: isDone ? const Color(0xFFFC0377) : Colors.blue,
              borderRadius: BorderRadius.circular(6.0),
              border: isDone ? null : Border.all(
                color: const Color(0xFF86829D),
                width: 1.5,
              )
            ),
            child: const Image(
              image: AssetImage(
                'assets/images/check.png',
              ) ,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: isDone ? const Color(0xFF211551) : const Color(0xFF86829D),
              fontSize: 16.0,
              fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
