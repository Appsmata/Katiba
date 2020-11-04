// This file declares the content view screen

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:katiba/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:katiba/helpers/app_settings.dart';
import 'package:katiba/helpers/sqlite_helper.dart';
import 'package:katiba/models/katiba_model.dart';
import 'package:share/share.dart';
import 'package:katiba/utils/constants.dart';
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
  List<String> meanings, synonyms;
  List<KatibaModel> katibas;

  @override
  Widget build(BuildContext context) {
    curKatiba = katiba.id;
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
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(LangStrings.appName),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                isFavourited(katiba.isfav) ? Icons.star : Icons.star_border,
              ),
              onPressed: () => favoriteThis(),
            ),
          ],
        ),
        body: mainBody(),
        floatingActionButton: AnimatedFloatingActionButton(
          fabButtons: floatingButtons(),
          animatedIconData: AnimatedIcons.menu_close,
        ),
      ),
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
    String katibaBody = katiba.body;
    katibaBody = katibaBody.replaceAll("\\u201c", "");
    katibaBody = katibaBody.replaceAll("\\", "");
    katibaBody = katibaBody.replaceAll('"', '');
    
    return Container(
      decoration: Provider.of<AppSettings>(context).isDarkMode
          ? BoxDecoration()
          : BoxDecoration(
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
              ColorUtils.black,
              ColorUtils.baseColor,
              ColorUtils.primaryColor,
              ColorUtils.lightColor
            ]
        ),
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
                  color: ColorUtils.white),
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.only(top: 60),
            child: Card(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  katibaBody,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Container(),
        ],
      ),
    );
  }

  List<Widget> floatingButtons() {
    return <Widget>[
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.content_copy),
        tooltip: LangStrings.copyThis,
        onPressed: copyItem,
      ),
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.share),
        tooltip: LangStrings.shareThis,
        onPressed: shareItem,
      ),
      FloatingActionButton(
        heroTag: null,
        child: Icon(Icons.settings),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => settingsDialog()
          );
        },
      )
    ];
  }

  void copyItem() {
    //Clipboard.setData(ClipboardData(text: katibaContent + LangStrings.campaign));
    /*globalKey.currentState.showSnackBar(new SnackBar(
      content: new Text(LangStrings.katibaCopied),
    ));*/
  }

  void shareItem() {
    /*Share.share(
      //katibaContent + LangStrings.campaign,
      subject: "Share this: " + katiba.title,
    );*/
  }

  void favoriteThis() {
    if (katiba.isfav == 1)
      db.favouriteKatiba(katiba, false);
    else
      db.favouriteKatiba(katiba, true);
    /*globalKey.currentState.showSnackBar(new SnackBar(
      content: new Text(katiba.title + " " + LangStrings.katibaLiked),
    ));*/
    //notifyListeners();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void processData() async {
    //katibaContent = katiba.title;
    meanings = [];
    synonyms = [];

    /*try {
      String strMeaning = katiba.maana;
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
    if (katiba.visawe.length > 1) meanings.add(katiba.visawe);

    try {
      var strSynonyms = katiba.maana.split("|");

      if (strSynonyms.length > 1) {
        for (int i = 0; i < strSynonyms.length; i++) {
          synonyms.add(strSynonyms[i]);
        }
      } else {
        synonyms.add(strSynonyms[0]);
      }
    } catch (Exception) {}*/
  }
}
