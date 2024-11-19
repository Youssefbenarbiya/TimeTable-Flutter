import 'package:flutter/material.dart';

import '../main.dart';
import '../models/room_model.dart';

class RoomScreen extends StatefulWidget {
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  List<RoomModel> rooms = [];
  final DataService dataService = DataService();

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    try {
      rooms = (await dataService.fetchRoomModels()).cast<RoomModel>();
      setState(() {});
    } catch (e) {
      print('Error fetching rooms: $e');
    }
  }

  Future<void> addRoom(String name) async {
    try {
      await dataService.addRoom(name);
      fetchRooms();
    } catch (e) {
      print('Error adding room: $e');
    }
  }

  Future<void> updateRoom(RoomModel roomModel) async {
    try {
      await dataService.updateRoom(roomModel.id.toString(), roomModel.name);
      fetchRooms();
    } catch (e) {
      print('Error updating room: $e');
    }
  }

  Future<void> deleteRoom(int id) async {
    try {
      await dataService.deleteRoom(id.toString());
      fetchRooms();
    } catch (e) {
      print('Error deleting room: $e');
    }
  }

  void _showRoomDialog({RoomModel? roomModel}) {
    String roomName = roomModel?.name ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(roomModel == null ? 'Add Room' : 'Edit Room'),
        content: TextField(
          onChanged: (value) => roomName = value,
          decoration: InputDecoration(labelText: 'Room Name'),
          controller: TextEditingController(text: roomName),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (roomModel == null) {
                await addRoom(roomName);
              } else {
                roomModel.name = roomName; // Update the name field
                await updateRoom(roomModel);
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
        title: Text('Rooms'),
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final roomModel = rooms[index];
          return ListTile(
            title: Text(roomModel.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showRoomDialog(roomModel: roomModel),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteRoom(roomModel.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRoomDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}