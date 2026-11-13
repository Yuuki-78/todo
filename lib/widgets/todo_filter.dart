import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../viewmodels/todo_viewmodel.dart';

class TodoFilterWidget extends StatelessWidget {
  final TodoViewModel viewModel;

  const TodoFilterWidget({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SegmentedButton<TodoFilter>(
        segments: const [
          ButtonSegment(
            value: TodoFilter.all,
            label: Text('Tất cả'),
          ),
          ButtonSegment(
            value: TodoFilter.active,
            label: Text('Đang làm'),
          ),
          ButtonSegment(
            value: TodoFilter.completed,
            label: Text('Đã xong'),
          ),
        ],
        selected: {viewModel.currentFilter},
        onSelectionChanged: (Set<TodoFilter> newSelection) {
          viewModel.setFilter(newSelection.first);
        },
      ),
    );
  }
}