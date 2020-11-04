// This file declares functions that manages the asset database that is compiled with the app

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:katiba/models/callbacks/katiba.dart';
import 'package:katiba/utils/constants.dart';

class SqliteAssets {
  static SqliteAssets sqliteHelper; // Singleton DatabaseHelper
  static Database appDb; // Singleton Database

  SqliteAssets._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory SqliteAssets() {
    if (sqliteHelper == null) {
      sqliteHelper = SqliteAssets
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
    //String path = join("assets", "katiba.db");
    //await rootBundle.load(join("assets", "example.db"));
    //var assetDatabase = await openDatabase("assets/katiba.db", readOnly: true);
    //return assetDatabase;
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "demo_asset_example.db");

    // Check if the database exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load(join("assets", "katiba.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);

    // open the database
    var assetDatabase = await openDatabase(path, readOnly: true);
    return assetDatabase;
  }

  Future<List<Map<String, dynamic>>> getKatibaMapList() async {
    Database db = await this.database;
    var result = db.query(LangStrings.katiba);
    return result;
  }

  Future<List<Katiba>> getKatibaList() async {
    var katibaMapList = await getKatibaMapList();
    List<Katiba> katibaList = List<Katiba>();
    for (int i = 0; i < katibaMapList.length; i++) {
      katibaList.add(Katiba.fromMapObject(katibaMapList[i]));
    }
    return katibaList;
  }
}
