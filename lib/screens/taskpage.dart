import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_todo/database_helper.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/screens/homepage.dart';
import 'package:what_todo/widgets.dart';

class TaskPage extends StatefulWidget {
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
                              if(value != ""){
                                DatabaseHelper _dbHelper = new DatabaseHelper();
                                Task _newTask = new Task(
                                  title: value
                                );
                                
                                await _dbHelper.insertTask(_newTask);
                                print("New task has been inserted");

                              }


                            },
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
                  TodoWidget(
                    text: "Create your first Todo",
                    isDone: false,
                  ),
                  TodoWidget(
                    text: "create another task as well",
                    isDone: true,
                  ),
                  TodoWidget(
                    text: "just an another Todo",
                    isDone: false,
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TaskPage()));
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
