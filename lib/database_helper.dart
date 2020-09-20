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
  Future<int> insertTask(Task task) async {
    int taskId = 0;
    var _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

  // Inserting Todo_data
  Future<void> insertTodo(Todo todo) async {
    var _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTaskTitle(int id, String title) async {
    var _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = $id");
  }

  Future<void> updateTaskDescription(int id, String desc) async {
    var _db = await database();
    await _db
        .rawUpdate("UPDATE tasks SET description = '$desc' WHERE id = $id");
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
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          text: todoMap[index]['text'],
          isDone: todoMap[index]['isDone'],
          taskId: todoMap[index]['taskId']);
    });
  }

  Future<void> updateTodoIsDone(int id, int status) async {
    var _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = $status WHERE id = $id");
  }

  Future<void> clearTodoIsDone(int taskId) async {
    var _db = await database();
    await _db.rawUpdate("DELETE FROM todo WHERE taskId = $taskId");
  }

  Future<void> deleteTask(int taskId) async {
    var _db = await database();
    await _db.rawUpdate("DELETE FROM todo WHERE taskId = $taskId");
    await _db.rawUpdate("DELETE FROM tasks WHERE id = $taskId");
  }

  Future<void> deleteTodo(int id) async {
    var _db = await database();
    await _db.rawUpdate("DELETE FROM todo WHERE id = $id");
  }
}
