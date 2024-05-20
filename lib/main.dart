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
  
  RangeValues _values = RangeValues(0.0, 100.0);
  final List<Course> courses = [
    Course(
      name: 'Course 1',
      details: [
        DetailItem(
          classItem: ClassItem(
            className: 'Class A',
            classId: 101,
            students: [
              Student(studentId: 1, name: 'Student 1', grade: 'A', isChecked: false),
              Student(studentId: 2, name: 'Student 2', grade: 'B', isChecked: false),
              Student(studentId: 3, name: 'Student 3', grade: 'A', isChecked: false),
            ],
          ),
        ),
        DetailItem(
          classItem: ClassItem(
            className: 'Class B',
            classId: 102,
            students: [
              Student(studentId: 4, name: 'Student 4', grade: 'C', isChecked: false),
              Student(studentId: 5, name: 'Student 5', grade: 'B', isChecked: false),
              Student(studentId: 6, name: 'Student 6', grade: 'A', isChecked: false),
            ],
          ),
        ),
      ],
    ),
    Course(
      name: 'Course 2',
      details: [
        DetailItem(
          classItem: ClassItem(
            className: 'Class C',
            classId: 103,
            students: [
              Student(studentId: 7, name: 'Student 7', grade: 'B', isChecked: false),
              Student(studentId: 8, name: 'Student 8', grade: 'A', isChecked: false),
              Student(studentId: 9, name: 'Student 9', grade: 'C', isChecked: false),
            ],
          ),
        ),
        DetailItem(
          classItem: ClassItem(
            className: 'Class D',
            classId: 104,
            students: [
              Student(studentId: 10, name: 'Student 10', grade: 'B', isChecked: false),
              Student(studentId: 11, name: 'Student 11', grade: 'A', isChecked: false),
              Student(studentId: 12, name: 'Student 12', grade: 'C', isChecked: false),
            ],
          ),
        ),
      ],
    ),
  ];

  List<List<int>> selectedData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expandable List with Checkboxes'),
      ),
      body: ListView(
        children: courses.map((course) {
          return Column(
            children: [
              Padding(
          padding: EdgeInsets.all(16.0),
          child: SliderTheme(
  data: SliderTheme.of(context).copyWith(
    activeTrackColor: Colors.red[700],
    inactiveTrackColor: Colors.red[100],
    trackShape: RoundedRectSliderTrackShape(),
    trackHeight: 4.0,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
    thumbColor: Colors.redAccent,
    overlayColor: Colors.red.withAlpha(32),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
    tickMarkShape: RoundSliderTickMarkShape(),
    activeTickMarkColor: Colors.red[700],
    inactiveTickMarkColor: Colors.red[100],
    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
    valueIndicatorColor: Colors.redAccent,
    valueIndicatorTextStyle: TextStyle(
      color: Colors.white,
    ),
  ),
  child:  RangeSlider(
              values: _values,
              min: 0.0,
              max: 100.0,
              onChanged: (values) {
                setState(() {
                  _values = values;
                });
              },
              divisions: 10,
              labels: RangeLabels(
                _values.start.toString(),
                _values.end.toString(),
              ),
            ),
          ),
),
              ExpansionTile(
                title: Text(course.name),
                children: course.details.map((detail) {
                  if (detail.classItem != null) {
                    return ExpansionTile(
                      title: Text(detail.classItem!.className),
                      children: detail.classItem!.students.map((student) {
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
                  } else {
                    return SizedBox.shrink();
                  }
                }).toList(),
              ),
            ],
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectedData = [];
          for (var course in courses) {
            for (var detail in course.details) {
              if (detail.classItem != null) {
                List<int> selectedStudents = [];
                for (var student in detail.classItem!.students) {
                  if (student.isChecked) {
                    selectedStudents.add(student.studentId);
                  }
                }
                if (selectedStudents.isNotEmpty) {
                  selectedData.add([detail.classItem!.classId, ...selectedStudents]);
                }
              }
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
      ),
    );
  }
}

class Course {
  final String name;
  final List<DetailItem> details;

  Course({required this.name, required this.details});
}

class DetailItem {
  final ClassItem? classItem;

  DetailItem({this.classItem});
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
