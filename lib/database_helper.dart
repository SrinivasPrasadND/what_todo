import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_todo/models/task.dart';
import 'dart:async';

class DatabaseHelper {
  // Database initialization and table creation
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        return db;
      },
      version: 1,
    );
  }

  // Inserting Task
  Future<void> insertTask(Task task) async {
    var _db = await database();
    await _db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieving all the task information
  Future<List<Task>> getTasks() async {
    var _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          description: taskMap[index]['description'],
          title: taskMap[index]['title']);
    });
  }
}
