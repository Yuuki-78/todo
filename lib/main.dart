import 'package:flutter/material.dart';
import 'viewmodels/todo_viewmodel.dart';
import 'views/todo_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final todoViewModel = TodoViewModel();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TodoListScreen(viewModel: todoViewModel),
    );
  }
}