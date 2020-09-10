// This file declares katiba model that will be used to manage
// data from the asset database

class Katiba {
  String type;
  int refid;
  int number;
  String title;
  String body;

  Katiba({this.type, this.refid, this.number, this.title, this.body});

  Katiba.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    refid = json['refid'];
    number = json['number'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['refid'] = this.refid;
    data['number'] = this.number;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }

  //static Katiba fromMapObject(Map<String katibaMapList) {}
  Katiba.fromMapObject(Map<String, dynamic> map) {
    this.type = map['type'];
    this.refid = map['refid'];
    this.number = map['number'];
    this.title = map['title'];
    this.body = map['body'];
  }
}
