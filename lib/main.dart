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

class DataService {
  static const String baseUrl = 'http://localhost:3000';

  Future<List<String>> fetchClasses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/classes'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((item) => item['name'].toString()).toList();
      } else {
        throw Exception('Failed to load classes');
      }
    } catch (e) {
      print('Error fetching classes: $e');
      return [];
    }
  }

  Future<List<String>> fetchTeachers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/teachers'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((item) => item['name'].toString()).toList();
      } else {
        throw Exception('Failed to load teachers');
      }
    } catch (e) {
      print('Error fetching teachers: $e');
      return [];
    }
  }

  Future<List<String>> fetchRooms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rooms'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((item) => item['name'].toString()).toList();
      } else {
        throw Exception('Failed to load rooms');
      }
    } catch (e) {
      print('Error fetching rooms: $e');
      return [];
    }
  }

  Future<void> saveSessionData(String cellKey, String className, String teacherName, String roomName) async {
    final data = {
      "daySession": cellKey,
      "class": className,
      "teacher": teacherName,
      "room": roomName
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/timetable'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print("Data saved successfully!");
      } else {
        throw Exception('Failed to save data');
      }
    } catch (e) {
      print('Error saving data: $e');
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
  bool isLoading = true;

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
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

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
    String? selectedClass;
    String? selectedTeacher;
    String? selectedRoom;

    final selectedData = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
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

      // Save data to JSON server
      await dataService.saveSessionData(
        cellKey,
        selectedData['class']!,
        selectedData['teacher']!,
        selectedData['room']!,
      );
    }
  }
}
