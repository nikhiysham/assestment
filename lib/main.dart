import 'package:flutter/material.dart';
import 'package:etiqa/Screens/todo_list.dart';
import 'package:etiqa/Models/todo.dart';
import 'package:etiqa/Screens/todo_detail.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TodoList',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.orange),
        home: TodoList()
        // home: TodoDetail(Todo('', '', '', ''), 'Add new To-Do List'),
        );
  }
}
