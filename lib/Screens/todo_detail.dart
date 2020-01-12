import 'dart:async';
import 'package:flutter/material.dart';
import 'package:etiqa/Models/todo.dart';
import 'package:etiqa/Utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class TodoDetail extends StatefulWidget {
  final String appBarTitle;
  final Todo todo;

  TodoDetail(this.todo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return TodoDetailState(this.todo, this.appBarTitle);
  }
}

const String MIN_DATETIME = '2000-01-01 00:00:00';
const String MAX_DATETIME = '2099-12-01 00:00:00';

class TodoDetailState extends State<TodoDetail> {
  String _startDateStr;
  String _endDateStr;
  final df = new DateFormat('d MMM yyyy');

  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Todo todo;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TodoDetailState(this.todo, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    setState(() {
      _startDateStr = "";
      _endDateStr = "";
    });
  }

  void showDatePicker(context, type) {
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: DateTime.now(),
      dateFormat: 'd MMM yyyy HH:mm',
      locale: _locale,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
      ),
      pickerMode: DateTimePickerMode.datetime, // show TimePicker
      onCancel: () {
        debugPrint('onCancel');
      },
      onConfirm: (dateTime, List<int> index) {
        if (type == "start") {
          setState(() {
            todo.startDate = dateTime.toString();
            _startDateStr = df.format(new DateTime.fromMicrosecondsSinceEpoch(
                dateTime.millisecondsSinceEpoch * 1000));
          });
        } else {
          setState(() {
            todo.endDate = dateTime.toString();
            _endDateStr = df.format(new DateTime.fromMicrosecondsSinceEpoch(
                dateTime.millisecondsSinceEpoch * 1000));
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    rerenderState();

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                // First Element
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child:
                                Text("Title", style: TextStyle(fontSize: 14)),
                          )),
                      TextField(
                        controller: titleController,
                        style: TextStyle(fontSize: 14),
                        maxLines: 8,
                        onChanged: (value) {
                          updateTitle();
                        },
                        decoration: InputDecoration(
                            hintText: "Please key in your To-Do title here",
                            border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
                // Second Element
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("Start Date")),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(2)),
                        child: GestureDetector(
                            onTap: () => showDatePicker(context, 'start'),
                            child: Row(
                              children: <Widget>[
                                _startDateStr != null && _startDateStr != ''
                                    ? Text(_startDateStr,
                                        style: TextStyle(color: Colors.black))
                                    : Text("Select a date",
                                        style: TextStyle(color: Colors.grey)),
                                Expanded(
                                  child: SizedBox(
                                    height: 20.0,
                                  ),
                                ),
                                Container(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("End Date")),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(2)),
                        child: GestureDetector(
                            onTap: () => showDatePicker(context, 'end'),
                            child: Row(
                              children: <Widget>[
                                _endDateStr != null && _endDateStr != ''
                                    ? Text(_endDateStr,
                                        style: TextStyle(color: Colors.black))
                                    : Text("Select a date",
                                        style: TextStyle(color: Colors.grey)),
                                Expanded(
                                  child: SizedBox(
                                    height: 20.0,
                                  ),
                                ),
                                Container(
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                ),
                // Third Element
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            child: GestureDetector(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Create Now',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1,
                    style: TextStyle(color: Colors.white),
                  )),
              onTap: () {
                //Perform validation
                if (todo.title == "" ||
                    todo.title == null ||
                    todo.startDate == "" ||
                    todo.startDate == null) {
                  return _showAlertDialog('Error', 'Please fill in the form');
                }

                var sd = new DateFormat("yyyy-MM-dd HH:mm:ss.zzz")
                    .parse(todo.startDate);
                var ed = new DateFormat("yyyy-MM-dd HH:mm:ss.zzz")
                    .parse(todo.endDate);

                if (ed.difference(sd).inMilliseconds > 0) {
                  setState(() {
                    _save();
                  });
                } else {
                  _showAlertDialog(
                      'Error', 'End Date must greater than Start Date');
                }
              },
            ),
          ),
        ));
  }

  void rerenderState() {
    if (todo.startDate != null && todo.startDate != "") {
      _startDateStr = df.format(new DateTime.fromMicrosecondsSinceEpoch(
          (DateFormat("yyyy-MM-dd HH:mm:ss.zzz").parse(todo.startDate))
                  .millisecondsSinceEpoch *
              1000));
    }

    if (todo.endDate != null && todo.endDate != "") {
      _endDateStr = df.format(new DateTime.fromMicrosecondsSinceEpoch(
          (DateFormat("yyyy-MM-dd HH:mm:ss.zzz").parse(todo.endDate))
                  .millisecondsSinceEpoch *
              1000));
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of todo object
  void updateTitle() {
    todo.title = titleController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    todo.createdDate = (DateTime.now()).toString();
    int result;
    if (todo.id != null) {
      // Case 1: Update operation
      result = await helper.updateTodo(todo);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertTodo(todo);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Todo Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Todo');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW todo i.e. he has come to
    // the detail page by pressing the FAB of todoList page.
    if (todo.id == null) {
      _showAlertDialog('Status', 'No Todo was deleted');
      return;
    }

    // Case 2: User is trying to delete the old todo that already has a valid ID.
    int result = await helper.deleteTodo(todo.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Todo Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Todo');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
