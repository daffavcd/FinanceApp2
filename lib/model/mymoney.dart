class Mymoney {
  int _id;
  String _desc;
  int _categoryId;
  String _type;
  int _amount;

  int get id => this._id;

  set id(int value) => this._id = value;

  String get desc => this._desc;

  set desc(String value) => this._desc = value;

  int get categoryId => this._categoryId;

  set categoryId(int value) => this._categoryId = value;

  String get type => this._type;

  set type(String value) => this._type = value;

  int get amount => this._amount;

  set amount(int value) => this._amount = value;

  Mymoney(this._id, this._desc, this._categoryId, this._type, this._amount);

  Mymoney.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._desc = map['desc'];
    this._categoryId = map['categoryId'];
    this._type = map['type'];
    this._amount = map['amount'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['desc'] = desc;
    map['categoryId'] = categoryId;
    map['type'] = type;
    map['amount'] = amount;
    return map;
  }
}
