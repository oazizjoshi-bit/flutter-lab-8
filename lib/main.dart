import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Client-side Data Management (Web)',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StudentListPage(),
    );
  }
}

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  List<dynamic> students = [];

  @override
  void initState() {
    super.initState();
    loadStudentData();
  }

  Future<void> loadStudentData() async {
    final jsonString = await rootBundle.loadString('assets/students.json');
    final List data = json.decode(jsonString);
    setState(() {
      students = data;
    });
  }

  void addStudent() {
    setState(() {
      students.add({"id": students.length + 1, "name": "New Student", "age": 20});
    });
  }

  void updateFirstStudent() {
    if (students.isNotEmpty) {
      setState(() {
        students[0]['name'] = "${students[0]['name']} (Updated)";
      });
    }
  }

  void deleteLastStudent() {
    if (students.isNotEmpty) {
      setState(() {
        students.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student Data (JSON)")),
      body: students.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: DataTable(
                border: TableBorder.all(color: Colors.grey.shade400),
                columns: const [
                  DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Age', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: students.map((s) {
                  return DataRow(cells: [
                    DataCell(Text('${s['id']}')),
                    DataCell(Text('${s['name']}')),
                    DataCell(Text('${s['age']}')),
                  ]);
                }).toList(),
              ),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: addStudent,
            heroTag: 'add',
            child: Icon(Icons.add),
            tooltip: 'Add Student',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: updateFirstStudent,
            heroTag: 'update',
            child: Icon(Icons.update),
            tooltip: 'Update First Student',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: deleteLastStudent,
            heroTag: 'delete',
            child: Icon(Icons.delete),
            tooltip: 'Delete Last Student',
          ),
        ],
      ),
    );
  }
}




