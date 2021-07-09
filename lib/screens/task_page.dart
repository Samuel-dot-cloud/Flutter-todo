import 'package:flutter/material.dart';
import 'package:what_todo/classes/database_helper.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/widgets/to_do.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 6.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Image(
                            image: AssetImage('assets/images/back.png'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          onSubmitted: (value) async {
                            print('Field value : $value');
                            if(value != ''){
                              DatabaseHelper _dbHelper = DatabaseHelper();

                              Task _newTask = Task(
                                title: value,
                                description: '',
                              );

                              await _dbHelper.insertTask(_newTask);
                              print('New task has been saved');
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter Task Title',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF211551),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: 12.0,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter task description...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        )),
                  ),
                ),
                TodoWidget(
                  true,
                  text: 'Created first todo',
                ),
                TodoWidget(false),
                TodoWidget(true),
                TodoWidget(false),
                TodoWidget(true),
              ],
            ),
            Positioned(
              bottom: 24.0,
              right: 24.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TaskPage()),
                  );
                },
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: const Color(0xFFFE3577),
                  ),
                  child: const Image(
                    image: AssetImage(
                      'assets/images/delete.png',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
