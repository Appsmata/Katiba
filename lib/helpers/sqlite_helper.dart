// This file declares functions that manages the database that is created in the app
// when the app is installed for the first time

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:katiba/models/katiba_model.dart';
import 'package:katiba/utils/constants.dart';

class SqliteHelper {
  static SqliteHelper sqliteHelper; // Singleton DatabaseHelper
  static Database appDb; // Singleton Database

  SqliteHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory SqliteHelper() {
    if (sqliteHelper == null) {
      sqliteHelper = SqliteHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return sqliteHelper;
  }

  Future<Database> get database async {
    if (appDb == null) {
      appDb = await initializeDatabase();
    }
    return appDb;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory docsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docsDirectory.path, "Katiba.db");

    // Open/create the database at a given path
    var vsbDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return vsbDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(Queries.createKatibaTable);
  }

  //QUERIES FOR KATIBA
  Future<int> insertKatiba(KatibaModel katiba) async {
    Database db = await this.database;
    katiba.isfav = katiba.views = 0;

    var result = await db.insert(LangStrings.katiba, katiba.toMap());
    return result;
  }

  Future<int> favouriteKatiba(KatibaModel katiba, bool isFavorited) async {
    var db = await this.database;
    if (isFavorited)
      katiba.isfav = 1;
    else
      katiba.isfav = 0;
    var result = await db.rawUpdate('UPDATE ' +
        LangStrings.katiba +
        ' SET ' +
        LangStrings.isfav +
        '=' +
        katiba.isfav.toString() +
        ' WHERE ' +
        LangStrings.id +
        '=' +
        katiba.id.toString());
    return result;
  }

  Future<int> getKatibaCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from ' + LangStrings.katiba);
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //KATIBA LISTS
  Future<List<Map<String, dynamic>>> getKatibaMapList() async {
    Database db = await this.database;
    var result = db.query(LangStrings.katiba);
    return result;
  }

  Future<List<KatibaModel>> getKatibaList() async {
    var katibaMapList = await getKatibaMapList();
    List<KatibaModel> katibaList = List<KatibaModel>();
    for (int i = 0; i < katibaMapList.length; i++) {
      katibaList.add(KatibaModel.fromMapObject(katibaMapList[i]));
    }
    return katibaList;
  }

  //KATIBA SEARCH
  Future<List<Map<String, dynamic>>> getKatibaSearchMapList(
      String searchThis) async {
    Database db = await this.database;
    String sqlQuery = LangStrings.title + ' LIKE "%' + searchThis + '%"' +
        ' OR ' + LangStrings.body + ' LIKE "%' + searchThis + '%"';

    var result = db.query(LangStrings.katiba, where: sqlQuery);
    return result;
  }

  Future<List<KatibaModel>> getKatibaSearch(String searchThis) async {
    var katibaMapList = await getKatibaSearchMapList(searchThis);

    List<KatibaModel> katibaList = List<KatibaModel>();
    // For loop to create a 'katiba List' from a 'Map List'
    for (int i = 0; i < katibaMapList.length; i++) {
      katibaList.add(KatibaModel.fromMapObject(katibaMapList[i]));
    }
    return katibaList;
  }

  //FAVOURITES LISTS
  Future<List<Map<String, dynamic>>> getFavoritesList() async {
    Database db = await this.database;
    var result = db.query(LangStrings.katiba, where: LangStrings.isfav + '=1');
    return result;
  }

  Future<List<KatibaModel>> getFavorites() async {
    var katibaMapList = await getFavoritesList();

    List<KatibaModel> katibaList = List<KatibaModel>();
    for (int i = 0; i < katibaMapList.length; i++) {
      katibaList.add(KatibaModel.fromMapObject(katibaMapList[i]));
    }

    return katibaList;
  }

  //FAVORITE SEARCH
  Future<List<Map<String, dynamic>>> getFavSearchMapList(
      String searchThis) async {
    Database db = await this.database;
    String extraQuery = 'AND ' + LangStrings.isfav + '=1 ';
    String sqlQuery = LangStrings.title + ' LIKE "%' + searchThis + '%" ' + extraQuery +
        'OR ' + LangStrings.body + ' LIKE "%' + searchThis + '%" ' + extraQuery;

    var result = db.query(LangStrings.katiba, where: sqlQuery);
    return result;
  }

  Future<List<KatibaModel>> getFavSearch(String searchThis) async {
    var katibaMapList = await getFavSearchMapList(searchThis);

    List<KatibaModel> katibaList = List<KatibaModel>();
    // For loop to create a 'katiba List' from a 'Map List'
    for (int i = 0; i < katibaMapList.length; i++) {
      katibaList.add(KatibaModel.fromMapObject(katibaMapList[i]));
    }
    return katibaList;
  }
}
