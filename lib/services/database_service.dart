import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_todoapp/models/task.dart';

class DatabaseService {
  static Database? _db;

  static final DatabaseService instance = DatabaseService._constructor();

  final String _tasksTableName = "tasks";
  final String _tasksIdColumnName = "id";
  final String _tasksContentColumnName = "content";
  final String _tasksStatusColumnName = "status";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(
      databaseDirPath,
      'master_db.db',
    ); // our database name is: master_db.db

    // sqflite to open our database

    // till now no schema for db so, not useful till now

    // datatypes in sqflite: integer, real(decimal numbers), blob(Uint8List), text(string)

    // bool is not supported
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
      CREATE TABLE $_tasksTableName (
      $_tasksIdColumnName INTEGER PRIMARY KEY, 
      $_tasksContentColumnName TEXT NOT NULL,
      $_tasksStatusColumnName INTEGER NOT NULL
      
      )
''');
      },
    );
    return database;
  }

  void addTask(String content) async {
    final db = await database;
    await db.insert(_tasksTableName, {
      _tasksContentColumnName: content,
      _tasksStatusColumnName: 0,
    });
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final data = await db.query(_tasksTableName);
    List<Task> tasks =
        data
            .map(
              (e) => Task(
                id: e['id'] as int,
                status: e['status'] as int,
                content: e['content'] as String,
              ),
            )
            .toList();
    return tasks;
  }

  void updateTaskStatus(int id, int status) async {
    final db = await database;
    await db.update(
      _tasksTableName,
      {_tasksStatusColumnName: status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(
    int id,
    BuildContext context,
    VoidCallback onDeleted,
  ) async {
    int result = 0;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Selected Task? '),
          actions: [
            TextButton(
              onPressed: () async {
                final db = await database;
                await db.delete(
                  _tasksTableName,
                  where: 'id =?',
                  whereArgs: [id],
                );
                Navigator.pop(context);
                onDeleted();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
          ],
        );
      },
    );
    return result;
  }
}
