import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../viewmodels/todo_viewmodel.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final TodoViewModel viewModel;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.viewModel,
  });

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: todo.title);
    DateTime? selectedDate = todo.dueDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Sửa công việc'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Tên công việc'),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  selectedDate != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(selectedDate!)
                      : 'Chọn hạn hoàn thành',
                ),
                trailing: selectedDate != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => selectedDate = null);
                        },
                      )
                    : null,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        selectedDate ?? DateTime.now(),
                      ),
                    );
                    if (time != null) {
                      setState(() {
                        selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                viewModel.updateTodo(
                  todo.id,
                  controller.text,
                  dueDate: selectedDate,
                );
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCardColor() {
    if (todo.isCompleted) return Colors.grey.shade100;
    if (todo.isOverdue) return Colors.red.shade50;
    if (todo.isDueSoon) return Colors.orange.shade50;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      color: _getCardColor(),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => viewModel.toggleTodoStatus(todo.id),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: todo.dueDate != null
            ? Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: todo.isOverdue
                        ? Colors.red
                        : todo.isDueSoon
                            ? Colors.orange
                            : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${DateFormat('dd/MM/yyyy HH:mm').format(todo.dueDate!)} • ${todo.dueDateText}',
                    style: TextStyle(
                      fontSize: 12,
                      color: todo.isOverdue
                          ? Colors.red
                          : todo.isDueSoon
                              ? Colors.orange
                              : Colors.grey.shade600,
                      fontWeight: todo.isOverdue || todo.isDueSoon
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => viewModel.deleteTodo(todo.id),
            ),
          ],
        ),
      ),
    );
  }
}