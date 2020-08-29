import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_todo/database_helper.dart';
import 'package:what_todo/screens/taskpage.dart';
import 'package:what_todo/widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var _dbHelper = new DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 48.0,
        ),
        color: Color(0xFFF6F6F6),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage('assets/images/logo.png'),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 24.0),
                ),
                Expanded(
                  child: FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getTasks(),
                    builder: (context, snapshot) {
                      return ScrollConfiguration(
                        behavior: NoGlowBehaviour(),
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return TaskCard(
                              title: snapshot.data[index].title,
                            );
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              width: 60.0,
              height: 60.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TaskPage()))
                      .then((value) {
                    setState(() {});
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.indigo],
                          begin: Alignment(0, -1),
                          end: Alignment(0, 1),
                        ),
                        borderRadius: BorderRadius.circular(24.0)),
                    child: Image(
                      image: AssetImage('assets/images/add_icon.png'),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
