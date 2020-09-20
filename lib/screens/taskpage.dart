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
  String _taskDescription = "";
  int _taskId = 0;

  FocusNode _titleFocus;
  FocusNode _descriptionsFocus;
  FocusNode _todoFocus;

  bool contentVisible = false;

  DatabaseHelper _dbHelper = new DatabaseHelper();

  @override
  void initState() {
    if (widget.task != null) {
      contentVisible = true;
      _taskTitle = widget.task.title;
      _taskId = widget.task.id;
      _taskDescription = widget.task.description;
    }

    _titleFocus = FocusNode();
    _descriptionsFocus = FocusNode();
    _todoFocus = FocusNode();

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
                            Navigator.pop(context);
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
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              print("My value is $value");
                              if (value != "") {
                                if (widget.task == null) {
                                  Task _newTask = new Task(title: value);
                                  _taskId =
                                      await _dbHelper.insertTask(_newTask);
                                  setState(() {
                                    contentVisible = true;
                                    _taskTitle = value;
                                  });
                                  print("New task has been inserted");
                                } else {
                                  await _dbHelper.updateTaskTitle(
                                      _taskId, value);
                                  print("Update Existing tak");
                                }
                              }
                              _descriptionsFocus.requestFocus();
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
                  Visibility(
                    visible: contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        focusNode: _descriptionsFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_taskId != 0) {
                              await _dbHelper.updateTaskDescription(
                                  _taskId, value);
                              _taskDescription = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter the description for your task",
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 48.0)),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodoList(_taskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return TodoWidget(
                                text: snapshot.data[index].text,
                                todoId: snapshot.data[index].id,
                                isDone: snapshot.data[index].isDone == 1
                                    ? true
                                    : false,
                                notifyParent: () {
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 48),
                              child: TextField(
                                focusNode: _todoFocus,
                                controller: TextEditingController()..text = "",
                                onSubmitted: (value) async {
                                  print("My value is $value");
                                  if (value != "") {
                                    if (_taskId != 0) {
                                      Todo _newTodo = new Todo(
                                          text: value.toString(),
                                          isDone: 0,
                                          taskId: _taskId);
                                      await _dbHelper.insertTodo(_newTodo);
                                      setState(() {});
                                      _todoFocus.requestFocus();
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  width: 54.0,
                  height: 54.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
