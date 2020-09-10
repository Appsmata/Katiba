import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:katiba/models/KatibaModel.dart';
import 'package:katiba/helpers/SqliteHelper.dart';
import 'package:katiba/screens/EeContentView.dart';
import 'package:katiba/utils/Constants.dart';
import 'package:katiba/widgets/AsProgressWidget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class AsSearch extends StatefulWidget {
  AsSearch();

  @override
  createState() => AsSearchState();

  static Widget getList() {
    return new AsSearch();
  }
}

class AsSearchState extends State<AsSearch> {
  AsProgressWidget progressWidget =
      AsProgressWidget.getProgressWidget(AsProgressDialogTitles.somePatience);
  TextEditingController txtSearch = new TextEditingController(text: "");
  SqliteHelper db = SqliteHelper();

  AsSearchState();
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
      updateSearchList();
    }

    return new Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.1,
              0.4,
              0.6,
              0.9
            ],
            colors: [
              Colors.black,
              Colors.green[900],
              Colors.green,
              Colors.green[200]
            ]),
      ),
      child: new Stack(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: new Column(
              children: <Widget>[
                searchBox(),
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
            height: MediaQuery.of(context).size.height - 200,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: progressWidget,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: 110),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: results.length,
              itemBuilder: listView,
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return new Card(
      elevation: 2,
      child: new TextField(
        controller: txtSearch,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.clear),
            hintText: Texts.searchNow,
            hintStyle: TextStyle(fontSize: 18)),
        onChanged: (value) {
          searchNow();
        },
      ),
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
    String strContent = "<b>" + results[index].title + "</b>";
    String strMeaning = results[index].body;

    try {
      if (strMeaning.length == 0) {
        return Container();
      } else {
        strMeaning = strMeaning.replaceAll("\\u201c", "");
        strMeaning = strMeaning.replaceAll("\\", "");
        strMeaning = strMeaning.replaceAll('"', '');

        strContent = strContent + '<ul>';
        var strContents = strMeaning.split("|");

        if (strContents.length > 1) {
          try {
            for (int i = 0; i < strContents.length; i++) {
              var strExtra = strContents[i].split(":");
              strContent = strContent + "<li>" + strExtra[0] + "</li>";
            }
          } catch (Exception) {}
        } else {
          var strExtra = strContents[0].split(":");
          strContent = strContent + "<li>" + strExtra[0] + "</li>";
        }
        strContent = strContent + '</ul>';
        /*if (results[index].visawe.length > 1)
          strContent = strContent +
              "<br><p><b>Visawe:</b> <i>" +
              results[index].visawe +
              "</i></p>";*/

        return Card(
          elevation: 2,
          child: GestureDetector(
            child: Html(
              data: strContent,
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
        Future<List<KatibaModel>> katibaListFuture =
            db.getKatibaSearch(txtSearch.text);
        katibaListFuture.then((resultList) {
          setState(() {
            results = resultList;
          });
        });
      });
    } else {
      updateSearchList();
    }
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
