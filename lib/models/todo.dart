class Todo {
  final String id;
  String title;
  bool isCompleted;
  DateTime? dueDate; // Thêm hạn hoàn thành

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
  });

  // Kiểm tra có quá hạn không
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  // Kiểm tra sắp hết hạn (trong 24h)
  bool get isDueSoon {
    if (dueDate == null || isCompleted) return false;
    final now = DateTime.now();
    final diff = dueDate!.difference(now);
    return diff.inHours <= 24 && diff.inHours > 0;
  }

  // Lấy text hiển thị thời gian còn lại
  String get dueDateText {
    if (dueDate == null) return '';
    
    final now = DateTime.now();
    final diff = dueDate!.difference(now);
    
    if (isCompleted) {
      return 'Đã hoàn thành';
    } else if (diff.isNegative) {
      final absDiff = now.difference(dueDate!);
      if (absDiff.inDays > 0) {
        return 'Quá hạn ${absDiff.inDays} ngày';
      } else if (absDiff.inHours > 0) {
        return 'Quá hạn ${absDiff.inHours} giờ';
      } else {
        return 'Quá hạn ${absDiff.inMinutes} phút';
      }
    } else {
      if (diff.inDays > 0) {
        return 'Còn ${diff.inDays} ngày';
      } else if (diff.inHours > 0) {
        return 'Còn ${diff.inHours} giờ';
      } else {
        return 'Còn ${diff.inMinutes} phút';
      }
    }
  }
}

enum TodoFilter { all, active, completed }