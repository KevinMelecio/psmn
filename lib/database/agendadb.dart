import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pmsn20232/models/favmovie_model.dart';
import 'package:pmsn20232/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

class AgendaDB {
  static final nameDB = "AGENDADB";
  static final versionDB = 1;

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(pathDB, version: versionDB, onCreate: _createTables);
  }

  FutureOr<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tblTareas(
      idTask INTEGER PRIMARY KEY, 
      nameTask VARCHAR(50), 
      dscTask VARCHAR(50), 
      sttTask BYTE);
    ''');

    await db.execute('''
      CREATE TABLE Favoritos(
        idFav INTEGER PRIMARY KEY,
        pelicula INTEGER);
    ''');
  }

  Future<int> INSERT(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.insert(tblName, data);
  }

  Future<int> UPDATE(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.update(tblName, data,
        where: 'idTask = ?', whereArgs: [data['idTask']]);
  }

  Future<int> DELETE(String tblName, int idTask) async {
    var conexion = await database;
    return conexion!.delete(tblName, where: 'idTask = ?', whereArgs: [idTask]);
  }

  Future<List<TaskModel>> GETALLTASK() async {
    var conexion = await database;
    var result = await conexion!.query('tblTareas');
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

    Future<List<FavMoviesModel>> GETALLFAVORITES() async {
    var conexion = await database;
    var result = await conexion!.query('Favoritos');
    return result.map((task) => FavMoviesModel.fromMap(task)).toList();
  }

  
  Future<int> DELETE_FAV(int id) async {
    var conexion = await database;
    return conexion!.delete('Favoritos', where: 'pelicula = ?', whereArgs: [id]);
  }
}
