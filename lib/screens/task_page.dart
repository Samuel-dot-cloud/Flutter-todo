import 'package:flutter/material.dart';
import 'package:what_todo/classes/database_helper.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/models/todo.dart';
import 'package:what_todo/widgets/to_do.dart';

class TaskPage extends StatefulWidget {
  final Task? task;

  TaskPage({required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String _taskTitle = '';
  String _taskDescription = '';

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.task != null) {
      //set visibility to true
      _contentVisible = true;

      _taskTitle = widget.task!.title;
      _taskDescription = widget.task!.description;
      _taskId = widget.task!.id!;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
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
                        focusNode: _titleFocus,
                        onSubmitted: (value) async {
                          print('Field value : $value');
                          // Check if field is not empty
                          if (value != '') {
                            //Check if the task is null
                            if (widget.task == null) {
                              DatabaseHelper _dbHelper = DatabaseHelper();

                              Task _newTask = Task(
                                title: value,
                                description: 'No description provided.',
                              );

                              _taskId = await _dbHelper.insertTask(_newTask);
                              setState(() {
                                _contentVisible = true;
                                _taskTitle = value;
                              });
                              print('New task ID : $_taskId');
                            } else {
                              await _dbHelper.updateTaskTitle(_taskId, value);
                              print('Updated existing task');
                            }
                            _descriptionFocus.requestFocus();
                          }
                        },
                        controller: TextEditingController()..text = _taskTitle,
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
              Visibility(
                visible: _contentVisible,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12.0,
                  ),
                  child: TextField(
                    focusNode: _descriptionFocus,
                    onSubmitted: (value) async {
                      if (value != '') {
                        if (_taskId != 0) {
                          await _dbHelper.updateTaskDescription(_taskId, value);
                          _taskDescription = value;
                        }
                      }
                      _todoFocus.requestFocus();
                    },
                    controller: TextEditingController()
                      ..text = _taskDescription,
                    decoration: const InputDecoration(
                        hintText: 'Enter task description...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        )),
                  ),
                ),
              ),
              Visibility(
                visible: _contentVisible,
                child: FutureBuilder(
                  initialData: [],
                  future: _dbHelper.getTodos(_taskId),
                  builder: (context, AsyncSnapshot snapshot) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              // Switch todo completion state
                              if (snapshot.data[index].isDone == 0) {
                                await _dbHelper.updateTodoStatus(
                                    snapshot.data[index].id, 1);
                              } else {
                                await _dbHelper.updateTodoStatus(
                                    snapshot.data[index].id, 0);
                              }
                              setState(() {});
                            },
                            child: TodoWidget(
                              snapshot.data[index].isDone == 0 ? false : true,
                              text: snapshot.data[index].title,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: _contentVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20.0,
                        height: 20.0,
                        margin: const EdgeInsets.only(
                          right: 12.0,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(
                              color: const Color(0xFF86829D),
                              width: 1.5,
                            )),
                        child: const Image(
                          image: AssetImage(
                            'assets/images/check.png',
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _todoFocus,
                          onSubmitted: (value) async {
                            // Check if field is not empty
                            if (value != '') {
                              //Check if the task is null
                              if (_taskId != 0) {
                                Todo _newTodo = Todo(
                                  title: value,
                                  isDone: 0,
                                  taskId: _taskId,
                                );

                                await _dbHelper.insertTodo(_newTodo);
                                setState(() {
                                  _todoFocus.requestFocus();
                                });
                                print('Creating new todo');
                              }
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter todo item...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Visibility(
            visible: _contentVisible,
            child: Positioned(
              bottom: 24.0,
              right: 24.0,
              child: GestureDetector(
                onTap: () async {
                  if(_taskId != 0){
                    await _dbHelper.deleteTask(_taskId);
                    Navigator.pop(context);
                  }
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
          ),
        ],
      ),
    ));
  }
}
