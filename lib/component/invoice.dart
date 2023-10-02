class Invoice {
  final Student student;
  const Invoice({
    required this.student,
  });
}

class Student {
  final String name;
  final String course;
  final String transaction;
  final String date;
  final String level;

  const Student({
    required this.name,
    required this.date,
    required this.course,
    required this.transaction,
    required this.level,
  });
}
