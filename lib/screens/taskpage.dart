import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_todo/database_helper.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/models/todo.dart';
import 'package:what_todo/screens/homepage.dart';
import 'package:what_todo/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _taskTitle = "";
  int _taskId = 0;
  DatabaseHelper _dbHelper = new DatabaseHelper();
  @override
  void initState() {
    if (widget.task != null) {
      _taskTitle = widget.task.title;
      _taskId = widget.task.id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homepage(),
                                ));
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Image(
                                image: AssetImage(
                                    'assets/images/back_arrow_icon.png'),
                              )),
                        ),
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) async {
                              print("My value is $value");
                              if (value != "") {
                                if (widget.task == null) {
                                  Task _newTask = new Task(title: value);
                                  await _dbHelper.insertTask(_newTask);
                                  setState(() {});
                                  print("New task has been inserted");
                                } else {
                                  print("Update Existing tak");
                                }
                              }
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            decoration: InputDecoration(
                                hintText: "Enter task title",
                                border: InputBorder.none),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the description for your task",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 48.0)),
                    ),
                  ),
                  FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getTodoList(_taskId),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: TodoWidget(
                                text: snapshot.data[index].text,
                                isDone: snapshot.data[index].isDone == 1 ? true : false,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            width: 24,
                            height: 24,
                            margin: EdgeInsets.only(left: 32),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.grey, width: 1.5)),
                            child: Image(
                              image: AssetImage('assets/images/check_icon.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) async {
                              print("My value is $value");
                              if (value != "") {
                                if (widget.task != null) {
                                  Todo _newTodo = new Todo(
                                      text: value.toString(),
                                      isDone: 0,
                                      taskId: widget.task.id);
                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                  print("New todo has been inserted");
                                } else {
                                  print("Update Existing todo");
                                }
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Enter Todo Item",
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                width: 60.0,
                height: 60.0,
                child: GestureDetector(
                  onTap: () {
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pinkAccent, Colors.red],
                            begin: Alignment(0, -1),
                            end: Alignment(0, 1),
                          ),
                          borderRadius: BorderRadius.circular(24.0)),
                      child: Image(
                        image: AssetImage('assets/images/delete_icon.png'),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
