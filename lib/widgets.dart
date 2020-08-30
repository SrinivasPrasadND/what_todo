import 'package:flutter/material.dart';

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

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;

  TodoWidget({this.text, @required this.isDone});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      child: Row(
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
                color: isDone ? Colors.indigo : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border:
                    isDone ? null : Border.all(color: Colors.grey, width: 1.5)),
            child: Image(
              image: AssetImage('assets/images/check_icon.png'),
            ),
          ),
          Text(
            text ?? "(Unnamed Todo)",
            style: TextStyle(
                fontSize: 16,
                fontWeight: isDone ? FontWeight.bold : FontWeight.normal),
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
