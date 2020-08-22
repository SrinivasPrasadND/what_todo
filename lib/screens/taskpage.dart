import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_todo/screens/homepage.dart';
import 'package:what_todo/widgets.dart';

class Taskpage extends StatefulWidget {
  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
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
                        MaterialPageRoute(builder: (context) => Taskpage()));
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
