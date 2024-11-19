import 'package:flutter/material.dart';
import '../main.dart';
import '../models/class_model.dart';

class ClassScreen extends StatefulWidget {
  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  List<ClassModel> classes = [];
  final DataService dataService = DataService();

  @override
  void initState() {
    super.initState();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    try {
      classes = await dataService.fetchClassModels();
      setState(() {});
    } catch (e) {
      print('Error fetching classes: $e');
    }
  }

  Future<void> addClass(String name) async {
    try {
      await dataService.addClass(name);
      fetchClasses();
    } catch (e) {
      print('Error adding class: $e');
    }
  }

  Future<void> updateClass(ClassModel classModel) async {
    try {
      await dataService.updateClass(classModel.id.toString(), classModel.name);
      fetchClasses();
    } catch (e) {
      print('Error updating class: $e');
    }
  }

  Future<void> deleteClass(int id) async {
    try {
      await dataService.deleteClass(id.toString());
      fetchClasses();
    } catch (e) {
      print('Error deleting class: $e');
    }
  }

  void _showClassDialog({ClassModel? classModel}) {
    String className = classModel?.name ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(classModel == null ? 'Add Class' : 'Edit Class'),
        content: TextField(
          onChanged: (value) => className = value,
          decoration: InputDecoration(labelText: 'Class Name'),
          controller: TextEditingController(text: className),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (classModel == null) {
                await addClass(className);
              } else {
                classModel.name = className; // Update the name field
                await updateClass(classModel);
              }
              Navigator.of(context).pop();
            },
            child: Text('Save'),
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
        title: Text('Classes'),
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final classModel = classes[index];
          return ListTile(
            title: Text(classModel.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showClassDialog(classModel: classModel),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteClass(classModel.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showClassDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
