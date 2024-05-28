import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expandable List with Checkboxes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExpandableListPage(),
    );
  }
}

class ExpandableListPage extends StatefulWidget {
  @override
  _ExpandableListPageState createState() => _ExpandableListPageState();
}

class _ExpandableListPageState extends State<ExpandableListPage> {
  final List<ClassItem> classes = [
    ClassItem(
      className: 'Class A',
      classId: 101,
      students: [
        Student(studentId: 1, name: 'Student 1', grade: 'A', isChecked: false),
        Student(studentId: 2, name: 'Student 2', grade: 'B', isChecked: false),
        Student(studentId: 3, name: 'Student 3', grade: 'A', isChecked: false),
      ],
    ),
    ClassItem(
      className: 'Class B',
      classId: 102,
      students: [
        Student(studentId: 4, name: 'Student 4', grade: 'C', isChecked: false),
        Student(studentId: 5, name: 'Student 5', grade: 'B', isChecked: false),
        Student(studentId: 6, name: 'Student 6', grade: 'A', isChecked: false),
      ],
    ),
    ClassItem(
      className: 'Class C',
      classId: 103,
      students: [
        Student(studentId: 7, name: 'Student 7', grade: 'B', isChecked: false),
        Student(studentId: 8, name: 'Student 8', grade: 'A', isChecked: false),
        Student(studentId: 9, name: 'Student 9', grade: 'C', isChecked: false),
      ],
    ),
    ClassItem(
      className: 'Class D',
      classId: 104,
      students: [
        Student(studentId: 10, name: 'Student 10', grade: 'B', isChecked: false),
        Student(studentId: 11, name: 'Student 11', grade: 'A', isChecked: false),
        Student(studentId: 12, name: 'Student 12', grade: 'C', isChecked: false),
      ],
    ),
  ];

  List<List<int>> selectedData = [];
  List<List<dynamic>> allStudentsData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expandable List with Checkboxes'),
      ),
      body: ListView(
        children: [
          ...classes.map((classItem) {
            return ExpansionTile(
              title: Text(classItem.className),
              children: classItem.students.map((student) {
                return CheckboxListTile(
                  title: Text(student.name),
                  subtitle: Text('Grade: ${student.grade}'),
                  value: student.isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      student.isChecked = value!;
                    });
                  },
                );
              }).toList(),
            );
          }).toList(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              selectedData = [];
              for (var classItem in classes) {
                List<int> selectedStudents = [];
                for (var student in classItem.students) {
                  if (student.isChecked) {
                    selectedStudents.add(student.studentId);
                  }
                }
                if (selectedStudents.isNotEmpty) {
                  selectedData.add([classItem.classId, ...selectedStudents]);
                }
              }

              print(selectedData);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Selected Data'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectedData.map((data) {
                        return Text('${data[0]}: ${data.sublist(1).join(', ')}');
                      }).toList(),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.check),
            tooltip: 'Show Selected Data',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              allStudentsData = [];
              for (var classItem in classes) {
                for (var student in classItem.students) {
                  allStudentsData.add([student.name, student.studentId]);
                }
              }

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('All Students Data'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: allStudentsData.map((data) {
                        return Text('${data[0]} (ID: ${data[1]})');
                      }).toList(),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.list),
            tooltip: 'Show All Students Data',
          ),
        ],
      ),
    );
  }
}

class ClassItem {
  final String className;
  final int classId;
  final List<Student> students;

  ClassItem({
    required this.className,
    required this.classId,
    required this.students,
  });
}

class Student {
  final int studentId;
  final String name;
  final String grade;
  bool isChecked;

  Student({
    required this.studentId,
    required this.name,
    required this.grade,
    required this.isChecked,
  });
}
