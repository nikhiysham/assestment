import 'dart:async';
import 'package:flutter/material.dart';
import 'package:etiqa/Models/todo.dart';
import 'package:etiqa/Utils/database_helper.dart';
import 'package:etiqa/Screens/todo_detail.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class CustomTextStyle {
  static TextStyle title(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .title
        .copyWith(fontWeight: FontWeight.bold, fontSize: 16);
  }

  static TextStyle label(BuildContext context, double size) {
    return Theme.of(context)
        .textTheme
        .title
        .copyWith(color: Colors.grey, fontSize: size ?? 12);
  }

  static TextStyle value(BuildContext context, double size) {
    return Theme.of(context).textTheme.title.copyWith(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: size ?? 12);
  }
}

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  int count = 0;
  final df = new DateFormat('d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: getTodoListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Todo('', '', '', ''), 'Add Todo');
        },
        elevation: 20,
        tooltip: 'Add Todo',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red[500],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        // print(
        //     "##this.todoList[position].isCompleted: ${this.todoList[position].isCompleted}");
        return GestureDetector(
            onTap: () {
              navigateToDetail(this.todoList[position], 'Edit Todo');
            },
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  // side: BorderSide()
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              this.todoList[position].title,
                              style: CustomTextStyle.title(context),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Start Date",
                                      style: CustomTextStyle.label(context, 12),
                                    ),
                                    Text(
                                        getDate(
                                            this.todoList[position].startDate,
                                            position),
                                        style:
                                            CustomTextStyle.value(context, 12))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "End Date",
                                      style: CustomTextStyle.label(context, 12),
                                    ),
                                    Text(
                                        getDate(this.todoList[position].endDate,
                                            position),
                                        style:
                                            CustomTextStyle.value(context, 12))
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Time Left",
                                    style: CustomTextStyle.label(context, 12),
                                  ),
                                  Text(getDateDiff(this.todoList[position]),
                                      style: CustomTextStyle.value(context, 12))
                                ],
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        // color: Colors.grey[200],
                        color: Color.fromARGB(255, 237, 230, 217),
                        borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: const Radius.circular(15.0))),
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Text("Status",
                                      style:
                                          CustomTextStyle.label(context, 10)),
                                ),
                                Text("INCOMPLETE",
                                    style: CustomTextStyle.value(context, 10)),
                              ],
                            )),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Text("Tick if completed",
                                      style:
                                          CustomTextStyle.label(context, 10)),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      _delete(context, this.todoList[position]);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          shape: BoxShape.rectangle,
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.check_box_outline_blank,
                                          size: 10.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ))
                              ],
                            )
                          ],
                        )),
                  )
                ],
              ),
            ));
      },
    );
  }

  getDate(String dateTime, position) {
    var sd = new DateFormat("yyyy-MM-dd HH:mm:ss.zzz").parse(dateTime);
    return df.format(new DateTime.fromMicrosecondsSinceEpoch(
        sd.millisecondsSinceEpoch * 1000));
  }

  getDateDiff(Todo todo) {
    if (todo != null && todo != "") {
      var sd = new DateFormat("yyyy-MM-dd HH:mm:ss.zzz").parse(todo.startDate);
      var ed = new DateFormat("yyyy-MM-dd HH:mm:ss.zzz").parse(todo.endDate);

      var hours = (ed.difference(sd).inMilliseconds / 1000 / 60 / 60).floor();
      var minuteHours = (ed.difference(sd).inMilliseconds / 60 / 60).floor();
      var minutes = (ed.difference(sd).inMilliseconds / 60).floor();

      var diffInMinutes = minutes - (minuteHours * 60);

      if (diffInMinutes == '' || diffInMinutes == 0) {
        return '${hours} hrs';
      } else {
        return '${hours} hrs ${diffInMinutes} minutes';
      }
    }
    return "";
  }

  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Todo Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Todo todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetail(todo, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }
}
