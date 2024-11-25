import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Text(roomModel == null ? 'Add Room' : 'Edit Room',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
        title: Text('Rooms', style: GoogleFonts.poppins()),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final roomModel = rooms[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(roomModel.name,
                    style: GoogleFonts.poppins(fontSize: 18)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showRoomDialog(roomModel: roomModel),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteRoom(roomModel.id),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRoomDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
