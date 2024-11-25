import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../models/teacher_model.dart';

class TeacherScreen extends StatefulWidget {
  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  List<TeacherModel> teachers = [];
  final DataService dataService = DataService();

  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    try {
      teachers = (await dataService.fetchTeacherModels()).cast<TeacherModel>();
      setState(() {});
    } catch (e) {
      print('Error fetching teachers: $e');
    }
  }

  Future<void> addTeacher(String name) async {
    try {
      await dataService.addTeacher(name);
      fetchTeachers();
    } catch (e) {
      print('Error adding teacher: $e');
    }
  }

  Future<void> updateTeacher(TeacherModel teacherModel) async {
    try {
      await dataService.updateTeacher(teacherModel.id.toString(), teacherModel.name);
      fetchTeachers();
    } catch (e) {
      print('Error updating teacher: $e');
    }
  }

  Future<void> deleteTeacher(int id) async {
    try {
      await dataService.deleteTeacher(id.toString());
      fetchTeachers();
    } catch (e) {
      print('Error deleting teacher: $e');
    }
  }

  void _showTeacherDialog({TeacherModel? teacherModel}) {
    String teacherName = teacherModel?.name ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(teacherModel == null ? 'Add Teacher' : 'Edit Teacher',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: TextField(
          onChanged: (value) => teacherName = value,
          decoration: InputDecoration(labelText: 'Teacher Name'),
          controller: TextEditingController(text: teacherName),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (teacherModel == null) {
                await addTeacher(teacherName);
              } else {
                teacherModel.name = teacherName; // Update the name field
                await updateTeacher(teacherModel);
              }
              Navigator.of(context).pop();
            },
            child: Text('Save', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers', style: GoogleFonts.poppins()),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            final teacherModel = teachers[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(teacherModel.name,
                    style: GoogleFonts.poppins(fontSize: 18)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showTeacherDialog(teacherModel: teacherModel),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteTeacher(teacherModel.id),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTeacherDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}