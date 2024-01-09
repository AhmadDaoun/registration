import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_profile_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  static const String baseUrl = "https://ahmaddf123789.000webhostapp.com/api";
  String loginUrl;

  LoginPage() : loginUrl = '$baseUrl/login.php';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                http.post(Uri.parse(loginUrl), body: {
                  'id': userIdController.text,
                  'password': passwordController.text,
                }).then((response) {
                  final Map<String, dynamic> data = json.decode(response.body);

                  if (data['success'] == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfilePage(userId: userIdController.text),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Authentication Failed'),
                          content: Text(data['error'] ?? 'Unknown error'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                });
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
