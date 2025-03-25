import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminDashboard extends StatefulWidget {
  static const String routeName = "/admin_dashboard"; // Define route name
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Fetch users from backend
  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse("http://127.0.0.1:3000/admin/users"));

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    } else {
      print("Error fetching users");
    }
  }

  // Delete user function
  Future<void> deleteUser(String id) async {
    final response = await http.delete(Uri.parse("http://127.0.0.1:3000/admin/users/$id"));

    if (response.statusCode == 200) {
      setState(() {
        users.removeWhere((user) => user["_id"] == id);
      });
    } else {
      print("Error deleting user");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user["name"]),
            subtitle: Text(user["email"]),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteUser(user["_id"]),
            ),
          );
        },
      ),
    );
  }
}
