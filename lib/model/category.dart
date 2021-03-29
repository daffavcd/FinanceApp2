class Category {
  int _categoryId;
  String _categoryName;

  int get categoryId => this._categoryId;

  set categoryId(int value) => this._categoryId = value;

  get categoryName => this._categoryName;

  set categoryName(value) => this._categoryName = value;

  Category(this._categoryId, this._categoryName);

  Category.fromMap(Map<String, dynamic> map) {
    this._categoryId = map['categoryId'];
    this._categoryName = map['categoryName'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['categoryId'] = this._categoryId;
    map['categoryName'] = categoryName;
    return map;
  }
}
