import 'package:flutter/material.dart';
import 'package:sqflite_todoapp/models/task.dart';
import 'package:sqflite_todoapp/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  String? _task = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(floatingActionButton: _addTaskButton(), body: _tasksList());
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Add Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _task = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Subscribe',
                    ),
                  ),
                  SizedBox(height: 10),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('Done'),
                    onPressed: () {
                      if (_task == null || _task == '') {
                        return;
                      }
                      _databaseService.addTask(_task!);
                      setState(() {
                        _task = null;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },

      child: Icon(Icons.add),
    );
  }

  Widget _tasksList() {
    return FutureBuilder(
      future: _databaseService.getTasks(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            Task task = snapshot.data![index];
            return ListTile(
              onLongPress: () async {
                _databaseService.deleteTask(task.id, context, () {
                  setState(() {});
                });
              },
              title: Text(task.content),
              trailing: Checkbox(
                value: task.status == 1,
                onChanged: (value) {
                  _databaseService.updateTaskStatus(
                    task.id,
                    value == true ? 1 : 0,
                  );
                  setState(() {});
                },
              ),
            );
          },
        );
      },
    );
  }
}
