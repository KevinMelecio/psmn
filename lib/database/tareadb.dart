import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pmsn20232/models/carrera_model.dart';
import 'package:pmsn20232/models/profesor_model.dart';
import 'package:pmsn20232/models/tarea_model.dart';
import 'package:sqflite/sqflite.dart';

class TareaDB {
  static final nameDB = "TAREADB";
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
      CREATE TABLE Tarea(
        idTarea INTEGER PRIMARY KEY,
        nomTarea  VARCHAR(50),
        fecExpiracion INTEGER,
        fecRecordatorio INTEGER,
        desTarea  VARCHAR(100),
        realizada INTEGER,
        idProfe INTEGER,
        FOREIGN KEY (idProfe) REFERENCES Profesor(idProfe)
      );
    ''');

    await db.execute('''
      CREATE TABLE Profesor(
        idProfe INTEGER PRIMARY KEY,
        nomProfe  VARCHAR(50),
        idCarrera INTEGER,
        email  VARCHAR(50),
        FOREIGN KEY (idCarrera) REFERENCES Carrera(idCarrera)
      );
    ''');

    await db.execute('''
      CREATE TABLE Carrera(
        idCarrera INTEGER PRIMARY KEY,
        nomCarrera  VARCHAR(50)
      );
    ''');
  }

  Future<int> INSERT(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.insert(tblName, data);
  }

  Future<int> UPDATE_CARRERA(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.update(tblName, data,
        where: 'idCarrera = ?', whereArgs: [data['idCarrera']]);
  }

  Future<int> UPDATE_PROFESOR(String tblName, Map<String, dynamic> data) async {
    var conexion = await database;
    return conexion!.update(tblName, data,
        where: 'idProfe = ?', whereArgs: [data['idProfe']]);
  }

  Future<int> DELETE_CARRERA(String tblName, int idCarrera) async {
    var conexion = await database;
    return conexion!
        .delete(tblName, where: 'idCarrera = ?', whereArgs: [idCarrera]);
  }

    Future<int> DELETE_PROFESOR(String tblName, int idProfe) async {
    var conexion = await database;
    return conexion!
        .delete(tblName, where: 'idProfe = ?', whereArgs: [idProfe]);
  }


  Future<List<TareaModel>> GETALLTAREAS() async {
    var conexion = await database;
    var result = await conexion!.query('Tarea');
    return result.map((task) => TareaModel.fromMap(task)).toList();
  }

  Future<List<ProfesorModel>> GETALLPROFESOR() async {
    var db = await database;
    var result = await db!.rawQuery('''
    SELECT Profesor.*, Carrera.nomCarrera
    FROM Profesor
    INNER JOIN Carrera ON Profesor.idCarrera = Carrera.idCarrera
  ''');
    List<ProfesorModel> profesores = [];
    for (final Map<String, dynamic> row in result) {
      final profesor = ProfesorModel.fromMap(row);
      profesores.add(profesor);
    }
    return profesores;
  }

  Future<int?> GETCARRERAID(String nomCarrera) async {
    final db = await database;
    if (db != null) {
      final result = await db.rawQuery(
        'SELECT idCarrera FROM Carrera WHERE nomCarrera = ?',
        [nomCarrera],
      );
      if (result.isNotEmpty) {
        return result.first['idCarrera'] as int?;
      }
    }
    // Si no se encuentra ninguna carrera con el nombre dado o db es nulo, se retorna null
    return null;
  }

  Future<List<CarreraModel>> GETALLCARRERA() async {
    var conexion = await database;
    var result = await conexion!.query('Carrera');
    return result.map((carrera) => CarreraModel.fromMap(carrera)).toList();
  }
}
