import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Interactive Timetable'),
        ),
        body: Timetable(),
      ),
    );
  }
}

// Data Service to fetch data from JSON server
class DataService {
  static const String baseUrl = 'http://localhost:3000';

  Future<List<String>> fetchClasses() async {
    final response = await http.get(Uri.parse('$baseUrl/classes'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => item['name'].toString()).toList();
    } else {
      throw Exception('Failed to load classes');
    }
  }

  Future<List<String>> fetchTeachers() async {
    final response = await http.get(Uri.parse('$baseUrl/teachers'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => item['name'].toString()).toList();
    } else {
      throw Exception('Failed to load teachers');
    }
  }

  Future<List<String>> fetchRooms() async {
    final response = await http.get(Uri.parse('$baseUrl/rooms'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => item['name'].toString()).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }
}

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  final List<String> sessions = ["Session 1", "Session 2", "Session 3", "Session 4"];
  
  final Map<String, String> timetableData = {};
  final DataService dataService = DataService();

  List<String> classes = [];
  List<String> teachers = [];
  List<String> rooms = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final fetchedClasses = await dataService.fetchClasses();
      final fetchedTeachers = await dataService.fetchTeachers();
      final fetchedRooms = await dataService.fetchRooms();
      setState(() {
        classes = fetchedClasses;
        teachers = fetchedTeachers;
        rooms = fetchedRooms;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        border: TableBorder.all(),
        columnWidths: {
          0: FixedColumnWidth(80.0),
        },
        children: [
          TableRow(
            children: [
              TableCell(child: Center(child: Text("Days/Sessions"))),
              ...sessions.map((session) => Center(child: Text(session))),
            ],
          ),
          for (var day in days)
            TableRow(
              children: [
                TableCell(child: Center(child: Text(day))),
                ...sessions.map((session) {
                  final cellKey = "$day-$session";
                  return GestureDetector(
                    onTap: () => _showCellDialog(context, cellKey),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      color: Colors.grey[200],
                      child: Text(
                        timetableData[cellKey] ?? "Select",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }

  void _showCellDialog(BuildContext context, String cellKey) async {
    final selectedData = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        String? selectedClass;
        String? selectedTeacher;
        String? selectedRoom;

        return AlertDialog(
          title: Text("Select Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Class'),
                items: classes.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => selectedClass = value,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Teacher'),
                items: teachers.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => selectedTeacher = value,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Room'),
                items: rooms.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => selectedRoom = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'class': selectedClass ?? '',
                  'teacher': selectedTeacher ?? '',
                  'room': selectedRoom ?? '',
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (selectedData != null) {
      setState(() {
        timetableData[cellKey] =
            "${selectedData['class']}, ${selectedData['teacher']}, ${selectedData['room']}";
      });
    }
  }
}
