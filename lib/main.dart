import 'dart:convert';
import 'package:emploi/models/class_model.dart';
import 'package:emploi/screens/room_secreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/room_model.dart';
import 'screens/class_screen.dart';
import 'screens/teacher_secreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Timetable',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Timetable'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClassScreen()),
                    );
                  },
                  child: Text('Classes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoomScreen()),
                    );
                  },
                  child: Text('Rooms'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TeacherScreen()),
                    );
                  },
                  child: Text('Teachers'),
                ),
              ],
            ),
          ),
        Expanded(
        child: Timetable(),
        ),
        ],
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
  Future<List<ClassModel>> fetchClassModels() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/classes'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((item) => ClassModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load classes');
      }
    } catch (e) {
      print('Error fetching classes: $e');
      return [];
    }
  }
  Future<List<ClassModel>> fetchTeacherModels() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/teachers'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((item) => ClassModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load teachers');
      }
    } catch (e) {
      print('Error fetching teachers: $e');
      return [];
    }
  }
  Future<List<Object>> fetchRoomModels() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/rooms'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((item) => RoomModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load rooms');
      }
    } catch (e) {
      print('Error fetching rooms: $e');
      return [];
    }
  }
Future<void> addTeacher(String name) async {
  final data = {"name": name};

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/teachers'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      print("Teacher added successfully!");
    } else {
      throw Exception('Failed to add teacher');
    }
  } catch (e) {
    print('Error adding teacher: $e');
  }
}

Future<void> updateTeacher(String id, String name) async {
  final data = {"name": name};

  try {
    final response = await http.put(
      Uri.parse('$baseUrl/teachers/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Teacher updated successfully!");
    } else {
      throw Exception('Failed to update teacher');
    }
  } catch (e) {
    print('Error updating teacher: $e');
  }
}

Future<void> deleteTeacher(String id) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/teachers/$id'),
    );

    if (response.statusCode == 200) {
      print("Teacher deleted successfully!");
    } else {
      throw Exception('Failed to delete teacher');
    }
  } catch (e) {
    print('Error deleting teacher: $e');
  }
}
Future<void> createClass(String name) async {
  final data = {"name": name};

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/classes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      print("Class created successfully!");
    } else {
      throw Exception('Failed to create class');
    }
  } catch (e) {
    print('Error creating class: $e');
  }
}

Future<void> addClass(String name) async {
  final data = {"name": name};

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/classes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      print("Class added successfully!");
    } else {
      throw Exception('Failed to add class');
    }
  } catch (e) {
    print('Error adding class: $e');
  }
}

Future<void> updateClass(String id, String name) async {
  final data = {"name": name};

  try {
    final response = await http.put(
      Uri.parse('$baseUrl/classes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Class updated successfully!");
    } else {
      throw Exception('Failed to update class');
    }
  } catch (e) {
    print('Error updating class: $e');
  }
}

Future<void> deleteClass(String id) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/classes/$id'),
    );

    if (response.statusCode == 200) {
      print("Class deleted successfully!");
    } else {
      throw Exception('Failed to delete class');
    }
  } catch (e) {
    print('Error deleting class: $e');
  }
}

Future<void> addRoom(String name) async {
  final data = {"name": name};

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/rooms'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      print("Room added successfully!");
    } else {
      throw Exception('Failed to add room');
    }
  } catch (e) {
    print('Error adding room: $e');
  }
}

Future<void> updateRoom(String id, String name) async {
  final data = {"name": name};

  try {
    final response = await http.put(
      Uri.parse('$baseUrl/rooms/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Room updated successfully!");
    } else {
      throw Exception('Failed to update room');
    }
  } catch (e) {
    print('Error updating room: $e');
  }
}

Future<void> deleteRoom(String id) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/rooms/$id'),
    );

    if (response.statusCode == 200) {
      print("Room deleted successfully!");
    } else {
      throw Exception('Failed to delete room');
    }
  } catch (e) {
    print('Error deleting room: $e');
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
