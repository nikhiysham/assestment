class Todo {
  int _id;
  String _title;
  String _description;
  String _startDate;
  String _endDate;
  String _createdDate;

  Todo(this._title, this._startDate, this._endDate, this._createdDate);

  Todo.withId(
      this._id, this._title, this._startDate, this._endDate, this._createdDate);

  int get id => _id;

  String get title => _title;

  String get startDate => _startDate;

  String get endDate => _endDate;

  String get createdDate => _createdDate;

  set title(String newTitle) {
    // if (newTitle.length <= 255) {
    this._title = newTitle;
    // }
  }

  set startDate(String newDate) {
    this._startDate = newDate;
  }

  set endDate(String newDate) {
    this._endDate = newDate;
  }

  set createdDate(String newDate) {
    this._createdDate = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['startDate'] = _startDate;
    map['endDate'] = _endDate;
    map['createdDate'] = _description;

    return map;
  }

  // Extract a Note object from a Map object
  Todo.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._startDate = map['startDate'];
    this._endDate = map['endDate'];
    this._createdDate = map['createdDate'];
  }
}
