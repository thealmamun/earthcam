import 'dart:async';
import 'dart:io' as io;
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/pages/live_videos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;

  static const String ID = 'id';
  static const String CAM_ID = 'camId';
  static const String CAM_TITLE = 'camTitle';
  static const String CAM_TYPE = 'camType';
  static const String IMAGE_URL = 'imageUrl';
  static const String STREAM_URL = 'streamUrl';

  static const String TABLE = 'favourites';
  static const String DB_NAME = 'camera_world.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($CAM_ID TEXT PRIMARY KEY, $CAM_TITLE TEXT, $CAM_TYPE TEXT,$IMAGE_URL TEXT,$STREAM_URL TEXT)");
  }

  Future<Cams> save(Cams cams,BuildContext context) async {
    try{
      var dbClient = await db;
      cams.id = await dbClient.insert(TABLE, cams.toMap());
      SnackBar snackBar = SnackBar(
          content: Text('Added to Favourites'));
      WidgetsBinding.instance.addPostFrameCallback((_) => scaffoldKey.currentState.showSnackBar(snackBar));
    }catch(e){
      SnackBar snackBar = SnackBar(
          content: Text('Already Added'));
      WidgetsBinding.instance.addPostFrameCallback((_) => scaffoldKey.currentState.showSnackBar(snackBar));
    }
    return cams;

    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  Future<List<Cams>> getCams() async {
    var dbClient = await db;
//    List<Map> maps = await dbClient.query(TABLE, columns: [ID, CAM_ID,CAM_TITLE,CAM_TYPE,IMAGE_URL,STREAM_URL]);
    List<Map> maps = await dbClient.rawQuery("SELECT DISTINCT * FROM $TABLE");
    List<Cams> cams = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        cams.add(Cams.fromMap(maps[i]));
      }
    }
    return cams;
  }

  Future<int> delete(String camId) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$CAM_ID = ?', whereArgs: [camId]);
  }
//
//  Future<int> update(Employee employee) async {
//    var dbClient = await db;
//    return await dbClient.update(TABLE, employee.toMap(),
//        where: '$ID = ?', whereArgs: [employee.id]);
//  }
//
//  Future close() async {
//    var dbClient = await db;
//    dbClient.close();
//  }
}