import 'dart:io';

import 'package:adhan_app/model/salah.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

const String dbName = "QuranAppDB.db";

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    return await openDatabase(path,
        version: 7, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Salah(number INTEGER PRIMARY KEY,"
        "name TEXT,"
        "englishName TEXT,"
        "time TEXT,"
        "isNotificationEnabled BOOLEAN,"
        "dateTime TIMESTAMP"
        ");");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS Salah");
    _onCreate(db, newVersion);
  }

  newSalah(Salah salah) async {
    final db = await database;
    try {
//      var res = await db.rawInsert("INSERT INTO Salah(name,englishName,time,isNotificationEnabled,dateTime) VALUES (\"${salah.name}\",\"${salah.englishName}\",\"${salah.time}\",${salah.isNotificationEnabled},${salah.date.toUtc().millisecondsSinceEpoch})");
     var res = await db.rawInsert('INSERT INTO Salah(name,englishName,time,isNotificationEnabled,dateTime) VALUES (?,?,?,?,?)',[salah.name,salah.englishName,salah.time,salah.isNotificationEnabled,salah.date.toUtc().microsecondsSinceEpoch]);
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Salah>> getAllSalah() async {
    final db = await database;
    var res = await db.query("Salah");
    List<Salah> list = res.isNotEmpty
        ? res.map((c) => Salah.fromJson(c)).toList()
        : [];
    return list;
  }


  deleteAll() async {
    try{
      final db = await database;
      db.rawDelete("DELETE FROM Salah");
      print('all rows has been deleted');
    } catch (e){
      print(e);
    }

  }

  updateSalahNotification(String englishName,int isNotificationEnabled) async {
    final db = await database;
    int updateCount = await db.rawUpdate('''
    UPDATE Salah 
    SET isNotificationEnabled = ?
    WHERE englishName = ?
    ''',[isNotificationEnabled, englishName]);

    print('$updateCount row updated');
  }


  findSalahByTimestamp(int timestamp) async {
    final db = await database;
    var res =
    await db.query('Salah', where: "dateTime = ?", whereArgs: [timestamp * 1000]);
    List<Salah> list =
    res.isNotEmpty ? res.map((c) => Salah.fromJson(c)).toList() : [];
    return list;
  }
}
