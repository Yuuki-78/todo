import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewmodels/todo_viewmodel.dart';
import '../widgets/todo_filter.dart';
import '../widgets/todo_item.dart';

class TodoListScreen extends StatefulWidget {
  final TodoViewModel viewModel;

  const TodoListScreen({super.key, required this.viewModel});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _textController = TextEditingController();
  DateTime? _selectedDueDate;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTodo() {
    if (_textController.text.isNotEmpty) {
      widget.viewModel.addTodo(_textController.text, dueDate: _selectedDueDate);
      _textController.clear();
      setState(() => _selectedDueDate = null);
    }
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDueDate ?? DateTime.now()),
      );
      if (time != null) {
        setState(() {
          _selectedDueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Danh Sách Công Việc'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Thống kê số lượng công việc
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Tổng: ${widget.viewModel.totalCount}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Chưa xong: ${widget.viewModel.activeCount}',
                        style: const TextStyle(color: Colors.orange)),
                    Text('Đã xong: ${widget.viewModel.completedCount}',
                        style: const TextStyle(color: Colors.green)),
                  ],
                ),
              ),

              // Bộ lọc trạng thái
              TodoFilterWidget(viewModel: widget.viewModel),

              // Ô nhập công việc mới
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: const InputDecoration(
                              hintText: 'Nhập công việc mới...',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => _addTodo(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addTodo,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    if (_selectedDueDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Hạn: ${DateFormat('dd/MM/yyyy HH:mm').format(_selectedDueDate!)}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => setState(() => _selectedDueDate = null),
                              child: const Text('Xóa'),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: OutlinedButton.icon(
                        onPressed: _selectDueDate,
                        icon: const Icon(Icons.access_time),
                        label: Text(
                          _selectedDueDate == null
                              ? 'Thêm hạn hoàn thành'
                              : 'Đổi hạn hoàn thành',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Danh sách Todo
              Expanded(
                child: widget.viewModel.todos.isEmpty
                    ? const Center(child: Text('Không có công việc nào!'))
                    : ListView.builder(
                        itemCount: widget.viewModel.todos.length,
                        itemBuilder: (context, index) {
                          final todo = widget.viewModel.todos[index];
                          return TodoItemWidget(
                            key: ValueKey(todo.id),
                            todo: todo,
                            viewModel: widget.viewModel,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}