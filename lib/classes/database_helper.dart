import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:what_todo/models/task.dart';

class DatabaseHelper{

  Future<Database> database() async {
    return openDatabase(
        join(await getDatabasesPath(), 'todo.db'),

        onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
          return db.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
          );
        },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertTask(Task task) async{
    Database _db = await database();
    await _db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async{
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index){
      return Task(id: taskMap[index]['id'], title: taskMap[index]['title'], description: taskMap[index]['description']);
    });
  }
}