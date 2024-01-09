import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfilePage extends StatefulWidget {
  final String userId;

  UserProfilePage({required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  List<Map<String, dynamic>> registeredCourses = [];
  List<Map<String, dynamic>> allCourses = [];

  @override
  void initState() {
    super.initState();
    _fetchRegisteredCourses();
    _fetchAllCourses();
  }

  Future<void> _fetchRegisteredCourses() async {
    final String getRegisteredCoursesUrl = "https://ahmaddf123789.000webhostapp.com/api/get_registered_courses.php";
    final Map<String, String> postData = {'id': widget.userId};

    final http.Response response = await http.post(Uri.parse(getRegisteredCoursesUrl), body: postData);

    final Map<String, dynamic> data = json.decode(response.body);

    if (data['success'] == true) {
      setState(() {
        registeredCourses = List<Map<String, dynamic>>.from(data['courses']);
      });
    } else {
      // Handle error
      print("Error: ${data['error']}");
    }
  }

  Future<void> _fetchAllCourses() async {
    final String getAllCoursesUrl = "https://ahmaddf123789.000webhostapp.com/api/get_all_courses.php";

    final http.Response response = await http.get(Uri.parse(getAllCoursesUrl));

    final Map<String, dynamic> data = json.decode(response.body);

    if (data['success'] == true) {
      setState(() {
        allCourses = List<Map<String, dynamic>>.from(data['courses']);
      });
    } else {
      // Handle error
      print("Error: ${data['error']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: ${widget.userId}'),
            SizedBox(height: 16.0),
            Text('Registered Courses:'),
            _buildRegisteredCoursesList(),
            SizedBox(height: 16.0),
            Text('All Courses:'),
            _buildAllCoursesTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisteredCoursesList() {
    if (registeredCourses.isEmpty) {
      return Text('No registered courses');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: registeredCourses.map((course) {
        return Text('- ${course['name']}');
      }).toList(),
    );
  }

  Widget _buildAllCoursesTable() {
    if (allCourses.isEmpty) {
      return Text('No courses available');
    }

    return DataTable(
      columns: [
        DataColumn(label: Text('Code')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Description')),
        DataColumn(label: Text('Actions')),
      ],
      rows: allCourses.map((course) {
        bool isRegistered = registeredCourses.any((rc) => rc['code'] == course['code']);

        return DataRow(cells: [
          DataCell(Text(course['code'])),
          DataCell(Text(course['name'])),
          DataCell(Text(course['description'])),
          DataCell(
            ElevatedButton(
              onPressed: () {
                if (!isRegistered) {
                  _registerForCourse(course['code']);
                }
              },
              child: Text(isRegistered ? 'Registered' : 'Register'),
            ),
          ),
        ]);
      }).toList(),
    );
  }

  Future<void> _registerForCourse(String courseCode) async {
    final String registerCourseUrl = "https://ahmaddf123789.000webhostapp.com/api/register_course.php";
    final Map<String, String> postData = {'id': widget.userId, 'code': courseCode};

    final http.Response response = await http.post(Uri.parse(registerCourseUrl), body: postData);

    final Map<String, dynamic> data = json.decode(response.body);

    if (data['success'] == true) {
      // Refresh the registered courses list
      _fetchRegisteredCourses();
    } else {
      // Handle error
      print("Error: ${data['error']}");
    }
  }
}

