import 'package:flutter/material.dart';

import 'database_helper.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;

  TaskCard({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title ?? "Unknown Card",
              style: TextStyle(
                color: Color(0xFF212423),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.0),
            ),
            Text(
              description ??
                  "No Description found. Please add some description to define your TODO",
              style:
                  TextStyle(color: Colors.black, height: 1.5, fontSize: 16.0),
            )
          ],
        ));
  }
}

class TodoWidget extends StatefulWidget {
  final String text;
  Function notifyParent;
  bool isDone;
  final int todoId;

  TodoWidget(
      {this.text,
      @required this.isDone,
      @required this.todoId,
      @required this.notifyParent});

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  var _dbHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 48, right: 16),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              await _dbHelper.updateTodoIsDone(
                  widget.todoId, widget.isDone == true ? 0 : 1);
              widget.notifyParent();
              /*setState(() {
                widget.isDone = widget.isDone == true ? false: true;
              });*/
            },
            child: Container(
              width: 24,
              height: 24,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  color: widget.isDone ? Colors.indigo : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: widget.isDone
                      ? null
                      : Border.all(color: Colors.grey, width: 1.5)),
              child: Image(
                image: AssetImage('assets/images/check_icon.png'),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Text(
              widget.text ?? "(Unnamed Todo)",
              style: TextStyle(
                  color: widget.isDone ? Colors.grey : Colors.black,
                  fontSize: 16,
                  fontWeight:
                      !widget.isDone ? FontWeight.bold : FontWeight.normal,
                  decoration: !widget.isDone
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
          ),
          Visibility(
            visible: !widget.isDone,
            child: GestureDetector(
              onTap: () async {
                await _dbHelper.deleteTodo(widget.todoId);
                widget.notifyParent();
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.only(left: 24),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewPortChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
