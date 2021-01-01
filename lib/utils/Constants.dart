//This file declares the strings used throughout the app

class SharedPreferenceKeys {
  static const String Katibadb_Loaded = "katiba_database_loaded";
  static const String User = "katiba_user";
  static const String DarkMode = "katiba_dark_mode";
}

class LangStrings {
  static const String DarkMode = "Dark Mode";
  static const String DisplaySettings = "Display Preferences";
  static const String OkayDone = "OKAY, DONE";
  static const String OkayGotIt = "OKAY, GOT IT";
  static const String GoBack = "GO BACK";
  static const String DoneSelecting = "Done with selecting?";
  static const String inProgress = "In Progress ...";
  static const String gettingReady = "Getting Ready ...";
  static const String somePatience = "Eish! ... Just a minute ...";
  static const String appName = "Kenyan Constitution";
  static const String campaign =
      "\n\n#Katiba #SeriouslyKenyan \n\nhttps://play.google.com/store/apps/details?id=com.appsmata.katiba ";
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
  static const String isfav = 'isfav';
  static const String views = 'views';
  static const String notes = 'notes';
  static const String copyThis = "Copy to Clipboard";
  static const String shareThis = "Share";

  static const String noInternetConnection = "No internet connection";
  static const String itemCopied = " copied to clipboard!";
  static const String itemLiked = " liked!";
  static const String itemDisliked = " disliked!";
}

class Queries {
  static const String createKatibaTable = 'CREATE TABLE ' +
      LangStrings.katiba +
      '(' +
      LangStrings.id +
      ' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
      LangStrings.type +
      ' VARCHAR(20), ' +
      LangStrings.refid +
      ' INTEGER NOT NULL DEFAULT 0, ' +
      LangStrings.number +
      ' INTEGER NOT NULL DEFAULT 0, ' +
      LangStrings.title +
      ' VARCHAR(100), ' +
      LangStrings.body +
      ' VARCHAR(2000),' +
      LangStrings.notes +
      ' VARCHAR(500), ' +
      LangStrings.isfav +
      ' INTEGER NOT NULL DEFAULT 0, ' +
      LangStrings.views +
      ' INTEGER NOT NULL DEFAULT 0' +
      ");";
}
