import 'dart:async';
import 'dart:io' as io;
import 'package:earth_cam/model/cams.dart';
import 'package:earth_cam/utils/constants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    await db.execute(
        "CREATE TABLE $TABLE ($CAM_ID TEXT PRIMARY KEY, $CAM_TITLE TEXT, $CAM_TYPE TEXT,$IMAGE_URL TEXT,$STREAM_URL TEXT)");
  }

  Future<Cams> save(Cams cams, BuildContext context) async {
    try {
      var dbClient = await db;
      cams.id = await dbClient.insert(TABLE, cams.toMap());
      this.successSave(context);
    } catch (e) {
      this.errorCatch(context);
    }
    return cams;
  }

  successSave(BuildContext context){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return Theme(
            data: Theme.of(context)
                .copyWith(dialogBackgroundColor: Colors.transparent),
            child: AlertDialog(
              content: Container(
                width: 100,
                height: 100,
                child: Column(
                  children: [
                    Expanded(
                      child: FlareActor(
                        "assets/flare/Favorite.flr",
                        shouldClip: false,
                        animation: "Favorite", //_animationName
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ClipRect(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.kBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Added to favourites",
                            style: GoogleFonts.roboto(
                                fontSize: 20, color: AppColor.kThemeColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  errorCatch(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return Theme(
            data: Theme.of(context).copyWith(
                dialogBackgroundColor: AppColor.kAppBarBackgroundColor),
            child: AlertDialog(
              content: Text(
                "Already Added to favourites.",
                style: TextStyle(color: AppColor.kThemeColor),
              ),
            ),
          );
        });
  }

  Future<List<Cams>> getCams() async {
    var dbClient = await db;
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
    return await dbClient
        .delete(TABLE, where: '$CAM_ID = ?', whereArgs: [camId]);
  }
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
