// This file declares the content view screen

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:katiba/helpers/SqliteHelper.dart';
import 'package:katiba/models/KatibaModel.dart';
import 'package:backdrop/backdrop.dart';
import 'package:katiba/screens/FfSettingsQuick.dart';
import 'package:share/share.dart';
import 'package:katiba/utils/Constants.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class EeContentView extends StatefulWidget {
  final KatibaModel katiba;

  EeContentView(this.katiba);

  @override
  State<StatefulWidget> createState() {
    return EeContentViewState(this.katiba);
  }
}

class EeContentViewState extends State<EeContentView> {
  EeContentViewState(this.katiba);
  final globalKey = new GlobalKey<ScaffoldState>();
  SqliteHelper db = SqliteHelper();

  var appBar = AppBar(), katibaVerses;
  KatibaModel katiba;
  int curKatiba = 0;
  String katibaContent;
  List<String> meanings, synonyms;
  List<KatibaModel> katibas;

  @override
  Widget build(BuildContext context) {
    curKatiba = katiba.id;
    katibaContent = katiba.title + " ni katiba la Kiswahili lenye maana:";
    bool isFavourited(int favorite) => favorite == 1 ?? false;

    if (meanings == null) {
      meanings = List<String>();
      synonyms = List<String>();
      processData();
    }

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: BackdropScaffold(
        title: Text(Texts.appName),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              isFavourited(katiba.isfav) ? Icons.star : Icons.star_border,
            ),
            onPressed: () => favoriteThis(),
          )
        ],
        iconPosition: BackdropIconPosition.action,
        headerHeight: 120,
        frontLayer: Center(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Scaffold(
              key: globalKey,
              body: mainBody(),
              floatingActionButton: AnimatedFloatingActionButton(
                fabButtons: floatingButtons(),
                colorStartAnimation: Colors.greenAccent,
                colorEndAnimation: Colors.green,
                animatedIconData: AnimatedIcons.menu_close,
              ),
            ),
          ),
        ),
        backLayer: FfSettingsQuick(),
      ),
    );
  }

  Widget mainBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.cyan, Colors.indigo]),
      ),
      child: new Stack(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Html(
              data: "<h3>" + katiba.title + "</h3>",
              style: {
                "h3": Style(
                  fontSize: FontSize(30.0),
                ),
              },
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 100,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: 60),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: meanings.length,
              itemBuilder: listView,
            ),
          ),
        ],
      ),
    );
  }

  Widget listView(BuildContext context, int index) {
    if (katiba.body == meanings[index]) {
      katibaContent = katibaContent +
          Texts.visawe_vya +
          katiba.title +
          " ni: " +
          katiba.type;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Html(
          data: "<p><b>Visawe:</b> <i>" + katiba.type + "</i></p>",
          style: {
            "p": Style(
              fontSize: FontSize(25.0),
            ),
          },
        ),
      );
    } else {
      var strContents = meanings[index].split(":");
      String strContent = meanings[index];

      if (strContents.length > 1) {
        strContent = strContents[0] + "<br>";
        strContent = strContent +
            "<p><b>Kwa mfano:</b> <i>" +
            strContents[1] +
            "</i></p>";

        katibaContent =
            katibaContent + "\n- " + strContents[0] + " kwa mfano: ";
        katibaContent = katibaContent + strContents[1];
      } else
        katibaContent = katibaContent + "\n - " + meanings[index];

      return Card(
        elevation: 2,
        child: GestureDetector(
          child: Html(
            data: "<ul><li>" + strContent + "</li></ul>",
            style: {
              "li": Style(
                fontSize: FontSize(25.0),
              ),
              "p": Style(
                fontSize: FontSize(22.0),
              ),
            },
          ),
        ),
      );
    }
  }

  List<Widget> floatingButtons() {
    return <Widget>[
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.content_copy),
        tooltip: Tooltips.copyThis,
        onPressed: copyItem,
      ),
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.share),
        tooltip: Tooltips.shareThis,
        onPressed: shareItem,
      ),
    ];
  }

  void copyItem() {
    Clipboard.setData(ClipboardData(text: katibaContent + Texts.campaign));
    globalKey.currentState.showSnackBar(new SnackBar(
      content: new Text(SnackBarText.itemCopied),
    ));
  }

  void shareItem() {
    Share.share(
      katibaContent + Texts.campaign,
      subject: "Shiriki katiba: " + katiba.title,
    );
  }

  void favoriteThis() {
    if (katiba.isfav == 1)
      db.favouriteKatiba(katiba, false);
    else
      db.favouriteKatiba(katiba, true);
    globalKey.currentState.showSnackBar(new SnackBar(
      content: new Text(katiba.title + " " + SnackBarText.itemLiked),
    ));
    //notifyListeners();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void processData() async {
    katibaContent = katiba.title;
    meanings = [];
    synonyms = [];

    try {
      String strMeaning = katiba.body;
      strMeaning = strMeaning.replaceAll("\\u201c", "");
      strMeaning = strMeaning.replaceAll("\\", "");
      strMeaning = strMeaning.replaceAll('"', '');

      var strMeanings = strMeaning.split("|");

      if (strMeanings.length > 1) {
        for (int i = 0; i < strMeanings.length; i++) {
          meanings.add(strMeanings[i]);
        }
      } else {
        meanings.add(strMeanings[0]);
      }
    } catch (Exception) {}
    //if (katiba.visawe.length > 1) meanings.add(katiba.visawe);

    try {
      var strSynonyms = katiba.body.split("|");

      if (strSynonyms.length > 1) {
        for (int i = 0; i < strSynonyms.length; i++) {
          synonyms.add(strSynonyms[i]);
        }
      } else {
        synonyms.add(strSynonyms[0]);
      }
    } catch (Exception) {}
  }
}
