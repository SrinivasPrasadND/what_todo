import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_todo/models/task.dart';
import 'dart:async';

import 'package:what_todo/models/todo.dart';

class DatabaseHelper {
  // Database initialization and table creation
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        await db.execute(
            "CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, text TEXT, isDone INTEGER)");
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

  // Inserting Todo_data
  Future<void> insertTodo(Todo todo) async {
    var _db = await database();
    await _db.insert('todo', todo.toMap(),
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

  Future<List<Todo>> getTodoList(int taskId) async {
    var _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          text: todoMap[index]['text'],
          isDone: todoMap[index]['isDone'],
          taskId: todoMap[index]['taskId']);
    });
  }
}
