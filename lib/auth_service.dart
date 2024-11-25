import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl =
      'http://localhost:3000'; // Change this to your JSON server URL

  Future<bool> signup(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    return response.statusCode == 201; // Created
  }

  Future<bool> login(String username, String password) async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      List<dynamic> users = json.decode(response.body);

      for (var user in users) {
        if (user['username'] == username && user['password'] == password) {
          return true; // Login successful
        }
      }
    }

    return false; // Login failed
  }
}
