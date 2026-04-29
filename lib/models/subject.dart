class Subject {
  final String code;
  final String title;
  final String department;

  Subject({required this.code, required this.title, required this.department});
}

final List<Subject> mockSubjects = [
  Subject(code: 'CSE-3101', title: 'Operating Systems', department: 'CSE'),
  Subject(code: 'CSE-3103', title: 'Software Engineering', department: 'CSE'),
  Subject(code: 'CSE-3121', title: 'Database Management Systems', department: 'CSE'),
  Subject(code: 'CSE-3100', title: 'SD Project II', department: 'CSE'),
  Subject(code: 'EEE-2205', title: 'Electrical Machines', department: 'EEE'),
  Subject(code: 'EEE-3101', title: 'Digital Signal Processing', department: 'EEE'),
  Subject(code: 'ME-1201', title: 'Thermodynamics', department: 'ME'),
  Subject(code: 'CE-2101', title: 'Engineering Geology', department: 'CE'),
  Subject(code: 'BBA-1101', title: 'Principles of Accounting', department: 'BBA'),
  Subject(code: 'GED-2101', title: 'Bangladesh Studies', department: 'GED'),
];
