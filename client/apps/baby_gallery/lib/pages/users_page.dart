import 'package:baby_gallery/custom_widget/custom_app_bar_widget.dart';
import 'package:baby_gallery/pages/album_page.dart';
import 'package:baby_gallery/store/users.dart';
import 'package:baby_gallery/store/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String _name = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    getUserName();
    fetchData();
  }

  void getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('username');
    setState(() {
      _name = userName ?? '';
    });
  }

  void fetchData() async {
    try {
      await Future.delayed(Duration(seconds: 2)); // Optional delay
      final response = await http
          .get(Uri.parse('http://jsonplaceholder.typicode.com/users'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        if (!mounted) return;
        List<User> users = jsonData.map((user) => User.fromJson(user)).toList();
        Provider.of<UsersProvider>(context, listen: false).setUsers(users);

        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
      } else {
        throw Exception('Failed to load users. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(userName: _name, pageName: "Users"),
      body: Column(
        children: [
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 20,
          ),
          SizedBox(height: 40),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 40),
                            SizedBox(height: 10),
                            Text(
                              'Error loading users',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                _errorMessage!,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                  _errorMessage = null;
                                });
                                fetchData();
                              },
                              child: Text("Retry"),
                            ),
                          ],
                        ),
                      )
                    : Consumer<UsersProvider>(
                        builder: (context, usersProvider, _) {
                          final users = usersProvider.users;
                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  title: Text(user.name),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AlbumPage(userName: user.name),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
