class Subject {
  final String code;
  final String title;
  final String department;

  Subject({required this.code, required this.title, required this.department});
}

final List<Subject> mockSubjects = [
  Subject(code: 'CSE-3101', title: 'Operating Systems', department: 'CSE'),
  Subject(code: 'CSE-3103', title: 'Software Engineering', department: 'CSE'),
  Subject(code: 'CSE-3100', title: 'SD Project II', department: 'CSE'),
  Subject(code: 'EEE-2205', title: 'Electrical Machines', department: 'EEE'),
  Subject(code: 'ME-1201', title: 'Thermodynamics', department: 'ME'),
];
