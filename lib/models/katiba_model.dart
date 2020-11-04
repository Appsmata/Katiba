// This file declares katiba model that will be used to manage
// data from the live database

class KatibaModel {
  int _id;
  String _type;
  int _refid;
  int _number;
  String _title;
  String _body;
  int _views;
  int _isfav;

  KatibaModel(this._type, this._refid, this._number, this._title, this._body);

  int get id => _id;
  String get type => _type;
  int get refid => _refid;
  int get number => _number;
  String get title => _title;
  String get body => _body;
  int get views => _views;
  int get isfav => _isfav;

  set id(int newId) {
    this._id = newId;
  }

  set type(String newtype) {
    this._type = newtype;
  }

  set refid(int newrefid) {
    this._refid = newrefid;
  }

  set number(int newnumber) {
    this._number = newnumber;
  }

  set title(String newtitle) {
    this._title = newtitle;
  }

  set body(String newbody) {
    this._body = newbody;
  }

  set views(int newViews) {
    this._views = newViews;
  }

  set isfav(int newIsfav) {
    this._isfav = newIsfav;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['type'] = _type;
    map['refid'] = _refid;
    map['number'] = _number;
    map['title'] = _title;
    map['body'] = _body;
    map['views'] = _views;
    map['isfav'] = _isfav;

    return map;
  }

  // Extract a Note object from a Map object
  KatibaModel.fromMapObject(Map<String, dynamic> map) {
    this._type = map['type'];
    this._refid = map['refid'];
    this._number = map['number'];
    this._title = map['title'];
    this._body = map['body'];
    this._views = map['views'];
    this._isfav = map['isfav'];
  }
}
