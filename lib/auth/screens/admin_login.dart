import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rental_platform/screens/admin_dashboard.dart';

class AdminLogin extends StatefulWidget {
  static const String routeName = "/admin-login"; // Define route name

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isAdminLoggedIn = false; // Track login status

  final String adminUsername = "admin";
  final String adminPassword = "admin123";

  void _login() {
    if (_usernameController.text == adminUsername &&
        _passwordController.text == adminPassword) {
      setState(() {
        isAdminLoggedIn = true; // Set admin as logged in
      });

      Navigator.pushNamed(context, AdminDashboard.routeName);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid admin credentials")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Admin Username"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Admin Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: Text("Login as Admin"),
            )
          ],
        ),
      ),
    );
  }
}
