import 'package:flutter/material.dart';
import '../main.dart';
import '../models/teacher_model.dart';
// Import your DataService

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
      teachers = (await dataService.fetchTeacherModels()).cast<TeacherModel>(); // Fetching teacher models
      setState(() {}); // Update UI
    } catch (e) {
      print('Error fetching teachers: $e');
    }
  }

  Future<void> addTeacher(String name) async {
    try {
      await dataService.addTeacher(name); // Add teacher via DataService
      fetchTeachers(); // Refresh the list after adding
    } catch (e) {
      print('Error adding teacher: $e');
    }
  }

  Future<void> updateTeacher(TeacherModel teacherModel) async {
    try {
      await dataService.updateTeacher(teacherModel.id.toString(),
          teacherModel.name); // Update teacher via DataService
      fetchTeachers(); // Refresh the list after updating
    } catch (e) {
      print('Error updating teacher: $e');
    }
    
      @override
      Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
      }}
        @override
        dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
      }