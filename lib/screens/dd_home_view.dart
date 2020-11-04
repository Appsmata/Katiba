import 'dart:async';
import 'package:flutter/material.dart';
import 'package:katiba/utils/colors.dart';
import 'package:katiba/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:katiba/models/katiba_model.dart';
import 'package:katiba/helpers/sqlite_helper.dart';
import 'package:katiba/screens/ee_content_view.dart';
import 'package:katiba/widgets/as_progress.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:katiba/helpers/app_settings.dart';

class DdHomeView extends StatefulWidget {
  DdHomeView();

  @override
  createState() => DdHomeViewState();

  static Widget getList() {
    return new DdHomeView();
  }
}

class DdHomeViewState extends State<DdHomeView> {
  AsProgress progressWidget = AsProgress.getProgressWidget(LangStrings.somePatience);
  TextEditingController txtSearch = new TextEditingController(text: "");
  SqliteHelper db = SqliteHelper();
  bool isSearching;

  DdHomeViewState();
  Future<Database> dbFuture;
  List<KatibaModel> results;
  List<String> blocks = [
    'Preamble',
    'Chapters',
    'Articles',
    'Schedules',
  ];
  String letterSearch;

  @override
  Widget build(BuildContext context) {
    if (results == null) {
      results = [];
      isSearching = false;
      updateSearchList();
    }
    
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: ColorUtils.white),
        title: Center(
          child: searchBox(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => settingsDialog()
              );
            },
          ),
        ],
      ),
      body: mainBody(),
    );
  }

  Widget settingsDialog() {
    return new AlertDialog(
      title: new Text(
        LangStrings.DisplaySettings,
        style: new TextStyle(color: ColorUtils.baseColor, fontSize: 25),
      ),
      content: new Container(
        height: 50,
        width: double.maxFinite,
        child: ListView(children: <Widget>[
          Consumer<AppSettings>(builder: (context, AppSettings settings, _) {
            return ListTile(
              onTap: () {},
              leading: Icon(settings.isDarkMode
                  ? Icons.brightness_4
                  : Icons.brightness_7),
              title: Text(LangStrings.DarkMode),
              trailing: Switch(
                onChanged: (bool value) => settings.setDarkMode(value),
                value: settings.isDarkMode,
              ),
            );
          }),
          Divider(),
        ]),
      ),
      actions: <Widget>[
        new Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            child:
                Text(LangStrings.OkayDone, style: new TextStyle(fontSize: 20)),
            color: ColorUtils.baseColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget mainBody() {
    return new Container(
      decoration: Provider.of<AppSettings>(context).isDarkMode
          ? BoxDecoration()
          : BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.4, 0.6, 0.9],
            colors: [ColorUtils.black, ColorUtils.baseColor, ColorUtils.primaryColor, ColorUtils.lightColor]
          ),
      ),
      child: new Stack(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: new Column(
              children: <Widget>[
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: blocks.length,
                    itemBuilder: blocksView,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 50,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: 50),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: results.length,
              itemBuilder: listView,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: progressWidget,
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    //isSearching
    return new Stack(
      children: <Widget>[
        //Text(LangStrings.appName),
        TextField(
          controller: txtSearch,
          style: TextStyle(fontSize: 20, color: ColorUtils.white),
          decoration: InputDecoration(
            hintText: LangStrings.appName,
            hintStyle: TextStyle(fontSize: 18, color: ColorUtils.white),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            searchNow();
          },
          onTap: () {
            //print('hello');
          },
        ),
      ]
    );

  }

  Widget blocksView(BuildContext context, int index) {
    return Container(
      width: 120,
      child: GestureDetector(
        onTap: () {
          setSearchingLetter(blocks[index]);
        },
        child: Card(
          elevation: 5,
          child: Hero(
            tag: blocks[index],
            child: Container(
              padding: const EdgeInsets.all(2),
              child: Center(
                child: Text(
                  blocks[index],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listView(BuildContext context, int index) {
    String strText = "<b>" + results[index].title + "</b>";
    String strContent = results[index].body;

    try {
      if (strContent.length == 0) {
        return Container();
      } else {
        strContent = strContent.replaceAll("\\u201c", "");
        strContent = strContent.replaceAll("\\u00a0", "");
        strContent = strContent.replaceAll("\\u2013", "");
        strContent = strContent.replaceAll("\\u2014", "");
        strContent = strContent.replaceAll("\\r", " ");
        strContent = strContent.replaceAll("\\n", " ");
        strContent = strContent.replaceAll('  ', ' ');
        strContent = strContent.replaceAll("\\", "");
        strContent = strContent.replaceAll('"', '');

        strText = strText + ' ' + (strContent.length > 50 ? strContent.substring(0, 50) + ' ...' : strContent);
        
        return Card(
          elevation: 2,
          child: GestureDetector(
            child: Html(
              data: strText,
              style: {
                "html": Style(
                  fontSize: FontSize(20.0),
                ),
                "ul": Style(
                  fontSize: FontSize(18.0),
                ),
                "p": Style(
                  fontSize: FontSize(18.0),
                  margin: EdgeInsets.only(left: 25, top: 10),
                ),
              },
            ),
            onTap: () {
              navigateToKatiba(results[index]);
            },
          ),
        );
      }
    } catch (Exception) {
      return Container();
    }
  }

  void updateSearchList() {
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<KatibaModel>> katibaListFuture = db.getKatibaList();
      katibaListFuture.then((resultList) {
        setState(() {
          results = resultList;
          progressWidget.hideProgress();
        });
      });
    });
  }

  void searchNow() {
    String searchThis = txtSearch.text;
    if (searchThis.length > 0) {
      results.clear();
      dbFuture = db.initializeDatabase();
      dbFuture.then((database) {
        Future<List<KatibaModel>> katibaListFuture = db.getKatibaSearch(txtSearch.text);
        katibaListFuture.then((resultList) {
          setState(() {
            results = resultList;
          });
        });
      });
    } else updateSearchList();
  }

  void setSearchingLetter(String _letter) {
    letterSearch = _letter;
    results.clear();
    updateSearchList();
  }

  void navigateToKatiba(KatibaModel katiba) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EeContentView(katiba);
    }));
  }
}

class BookItem<T> {
  bool isSelected = false;
  T data;
  BookItem(this.data);
}
