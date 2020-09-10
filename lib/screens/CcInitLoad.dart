// This file declares the database initialization screen

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:katiba/models/KatibaModel.dart';
import 'package:katiba/models/callbacks/Katiba.dart';
import 'package:katiba/utils/Constants.dart';
import 'package:katiba/utils/Preferences.dart';
import 'package:katiba/helpers/SqliteAssets.dart';
import 'package:katiba/helpers/SqliteHelper.dart';
import 'package:katiba/screens/AppStart.dart';
import 'package:katiba/widgets/AsTextView.dart';
import 'package:katiba/widgets/AsLineProgress.dart';
import 'package:sqflite/sqflite.dart';

class CcInitLoad extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CcInitLoadState();
  }
}

class CcInitLoadState extends State<CcInitLoad> {
  AsTextView textIndicator =
      AsTextView.setUp(AsProgressDialogTitles.gettingReady, 25, true);
  AsTextView textProgress = AsTextView.setUp("", 25, true);
  AsLineProgress lineProgress = AsLineProgress.setUp(300, 0);
  final globalKey = new GlobalKey<ScaffoldState>();

  SqliteHelper db = SqliteHelper();
  SqliteAssets adb = SqliteAssets();

  List<Katiba> katibas;

  Future<Database> dbAssets;
  Future<Database> dbFuture;

  @override
  Widget build(BuildContext context) {
    if (katibas == null) {
      katibas = List<Katiba>();
      requestData();
    }

    return Scaffold(
      key: globalKey,
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          child: new Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  _appIcon(),
                  _appLoading(),
                ],
              ),
              _appLabel(),
              Stack(
                children: <Widget>[
                  _appProgress(),
                  _appProgressText(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appIcon() {
    return new Center(
      child: new Container(
        child: new Image(
          image: new AssetImage("assets/images/appicon.png"),
          height: 450,
          width: 300,
        ),
        margin: EdgeInsets.only(top: 75),
      ),
    );
  }

  Widget _appLoading() {
    return new Center(
      child: new Container(
        child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation(Colors.green)),
        margin: EdgeInsets.only(top: 270),
      ),
    );
  }

  Widget _appLabel() {
    return new Center(
      child: new Container(
        height: 100,
        width: 350,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.green),
            boxShadow: [BoxShadow(blurRadius: 5)],
            borderRadius: new BorderRadius.all(new Radius.circular(10))),
        child: new Stack(
          children: <Widget>[
            new Center(child: new Container(width: 300, height: 120)),
            new Center(
              child: new Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: textIndicator,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appProgress() {
    return new Center(
      child: new Container(
        height: 100,
        width: 350,
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: new Stack(
          children: <Widget>[
            new Center(
              child: lineProgress,
            )
          ],
        ),
      ),
    );
  }

  Widget _appProgressText() {
    return new Center(
      child: new Container(
        height: 100,
        width: 350,
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: new Stack(
          children: <Widget>[
            new Center(
              child: textProgress,
            )
          ],
        ),
      ),
    );
  }

  void requestData() async {
    dbAssets = adb.initializeDatabase();
    dbAssets.then((database) {
      Future<List<Katiba>> katibaListAsset = adb.getKatibaList();
      katibaListAsset.then((katibaList) {
        setState(() {
          katibas = katibaList;
          _goToNextScreen();
        });
      });
    });
  }

  Future<void> saveMakatibaData() async {
    for (int i = 0; i < katibas.length; i++) {
      int progress = (i / katibas.length * 100).toInt();
      String progresStr = (progress / 100).toStringAsFixed(1);

      textProgress.setText(progress.toString() + " %");
      lineProgress.setProgress(double.parse(progresStr));

      switch (progress) {
        case 1:
          textIndicator.setText("Loading data ...");
          break;
        case 20:
          textIndicator.setText("Be patient ...");
          break;
        case 40:
          textIndicator.setText("Because patience pays ...");
          break;
        case 75:
          textIndicator.setText("Thanks for your patience!");
          break;
        case 85:
          textIndicator.setText("Finally!");
          break;
        case 95:
          textIndicator.setText("Almost done");
          break;
      }

      Katiba item = katibas[i];

      KatibaModel katiba = new KatibaModel(
          item.type, item.refid, item.number, item.title, item.body);
      await db.insertKatiba(katiba);
    }
  }

  Future<void> _goToNextScreen() async {
    await saveMakatibaData();

    Preferences.setKatibadbLoaded(true);
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new AppStart()));
  }
}
