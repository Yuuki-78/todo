import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoViewModel extends ChangeNotifier {
  final List<Todo> _todos = [];
  TodoFilter _filter = TodoFilter.all;

  List<Todo> get todos {
    switch (_filter) {
      case TodoFilter.active:
        return _todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.completed:
        return _todos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.all:
      default:
        return _todos;
    }
  }

  TodoFilter get currentFilter => _filter;

  // Thống kê số lượng
  int get totalCount => _todos.length;
  int get activeCount => _todos.where((t) => !t.isCompleted).length;
  int get completedCount => _todos.where((t) => t.isCompleted).length;

  // Thêm công việc
  void addTodo(String title, {DateTime? dueDate}) {
    if (title.trim().isEmpty) return;
    _todos.add(Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      dueDate: dueDate,
    ));
    notifyListeners();
  }

  // Sửa nội dung công việc
  void updateTodo(String id, String newTitle, {DateTime? dueDate}) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1 && newTitle.trim().isNotEmpty) {
      _todos[index].title = newTitle.trim();
      _todos[index].dueDate = dueDate;
      notifyListeners();
    }
  }

  // Đánh dấu hoàn thành / chưa hoàn thành
  void toggleTodoStatus(String id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      notifyListeners();
    }
  }

  // Xóa công việc
  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // Lọc danh sách
  void setFilter(TodoFilter filter) {
    _filter = filter;
    notifyListeners();
  }
}