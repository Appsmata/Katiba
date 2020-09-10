//This file declares the strings used throughout the app

class SharedPreferenceKeys {
  static const String Katibadb_Loaded = "katiba_database_loaded";
  static const String User = "katiba_user";
  static const String DarkMode = "katiba_dark_mode";
}

class AsProgressDialogTitles {
  static const String inProgress = "In Progress ...";
  static const String gettingReady = "Getting Ready ...";
  static const String somePatience = "Eish! ... Just a minute ...";
}

class Texts {
  static const String appName = "Kenyan Constitution";
  static const String campaign =
      "\n\n#Katiba #SeriouslyKenyan \n\nhttps://play.google.com/store/apps/details?id=com.jackson_siro.katiba ";
  static const String visawe_vya = "\n\nVisawe (synonyms) vya katiba ";
  static const String searchNow = "Search ";
  static const String katiba = 'katiba';
  static const String methali = 'methali';
  static const String misemo = 'misemo';
  static const String nahau = 'nahau';

  static const String id = 'id';
  static const String type = 'type';
  static const String refid = 'refid';
  static const String number = 'number';
  static const String title = 'title';
  static const String body = 'body';
  static const String maana = 'maana';
  static const String visawe = 'visawe';
  static const String mnyambuliko = 'mnyambuliko';
  static const String isfav = 'isfav';
  static const String views = 'views';
  static const String notes = 'notes';
}

class Tooltips {
  static const String copyThis = "Nakili kwa Clipboard";
  static const String shareThis = "Share";
}

class SnackBarText {
  static const String noInternetConnection = "No internet connection";
  static const String itemCopied = " copied to clipboard!";
  static const String itemLiked = " liked!";
  static const String itemDisliked = " disliked!";
}

class Queries {
  static const String createKatibaTable = 'CREATE TABLE ' +
      Texts.katiba +
      '(' +
      Texts.id +
      ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      Texts.type +
      ' VARCHAR(20), ' +
      Texts.refid +
      ' INTEGER NOT NULL DEFAULT 0, ' +
      Texts.number +
      ' INTEGER NOT NULL DEFAULT 0, ' +
      Texts.title +
      ' VARCHAR(100), ' +
      Texts.body +
      ' VARCHAR(2000),' +
      Texts.notes +
      ' VARCHAR(500), ' +
      Texts.isfav +
      ' INTEGER NOT NULL DEFAULT 0, ' +
      Texts.views +
      ' INTEGER NOT NULL DEFAULT 0' +
      ");";
}
