import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:katiba/models/KatibaModel.dart';
import 'package:katiba/helpers/SqliteHelper.dart';
import 'package:katiba/screens/EeContentView.dart';
import 'package:katiba/utils/Constants.dart';
import 'package:katiba/widgets/AsProgressWidget.dart';

class AsFavorites extends StatefulWidget {
  @override
  createState() => AsFavoritesState();
}

class AsFavoritesState extends State<AsFavorites> {
  AsProgressWidget progressWidget =
      AsProgressWidget.getProgressWidget(AsProgressDialogTitles.somePatience);
  TextEditingController txtSearch = new TextEditingController(text: "");
  SqliteHelper db = SqliteHelper();

  Future<Database> dbFuture;
  List<KatibaModel> katibas;

  @override
  Widget build(BuildContext context) {
    if (katibas == null) {
      katibas = [];
      updateKatibaList();
    }
    return new Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: new AssetImage("assets/images/bg.jpg"),
              fit: BoxFit.cover)),
      child: new Stack(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: new Column(
              children: <Widget>[
                searchBox(),
                //searchCriteria(),
              ],
            ),
          ),
          Container(
            //height: MediaQuery.of(context).size.height - 150,
            height: MediaQuery.of(context).size.height - 100,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: progressWidget,
          ),
          Container(
            //height: MediaQuery.of(context).size.height - 150,
            height: MediaQuery.of(context).size.height - 100,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            //margin: EdgeInsets.only(top: 130),
            margin: EdgeInsets.only(top: 60),

            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: katibas.length,
              itemBuilder: katibaListView,
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
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: Texts.searchNow,
            hintStyle: TextStyle(fontSize: 18)),
        onChanged: (value) {
          searchKatiba();
        },
      ),
    );
  }

  Widget katibaListView(BuildContext context, int index) {
    int category = katibas[index].id;
    String katibabook = "";
    String katibaTitle = katibas[index].title;

    var verses = katibas[index].body.split("\\n\\n");
    var katibaConts = katibas[index].body.split("\\n");
    String katibaContent = katibaConts[0] + ' ' + katibaConts[1] + " ...";

    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(katibaTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(katibaContent, style: TextStyle(fontSize: 18)),
        onTap: () {
          //navigateToKatiba(katibas[index], katibaTitle,
          //    "Katiba #" + katibas[index].number.toString() + " - " + katibabook);
        },
      ),
    );
  }

  void updateKatibaList() {
    dbFuture = db.initializeDatabase();
    dbFuture.then((database) {
      Future<List<KatibaModel>> katibaListFuture = db.getFavorites();
      katibaListFuture.then((katibaList) {
        setState(() {
          katibas = katibaList;
          progressWidget.hideProgress();
        });
      });
    });
  }

  void searchKatiba() {
    String searchThis = txtSearch.text;
    if (searchThis.length > 0) {
      katibas.clear();
      dbFuture = db.initializeDatabase();
      dbFuture.then((database) {
        Future<List<KatibaModel>> katibaListFuture =
            db.getFavSearch(txtSearch.text);
        katibaListFuture.then((katibaList) {
          setState(() {
            katibas = katibaList;
          });
        });
      });
    } else
      updateKatibaList();
  }

  void navigateToKatiba(
      KatibaModel katiba, String title, String katibabook) async {
    bool haschorus = false;
    //if (katiba.maana.contains("CHORUS")) haschorus = true;
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      //return EeContentView(katiba, haschorus, title, katibabook);
    }));
  }
}
