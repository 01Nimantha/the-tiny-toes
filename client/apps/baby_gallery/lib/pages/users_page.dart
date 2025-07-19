import 'package:baby_gallery/pages/login_page.dart';
import 'package:baby_gallery/store/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Provider.of<LoginProvider>(context, listen: false).logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text('Logout'),
            ),
            SizedBox(
              width: 80,
            ),
            Text(
              "Users",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ],
        ),
        actions: [
          Text("user"),
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
            child: Icon(Icons.person_pin),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Center(
        child: Text("Welcome"),
      ),
    );
  }
}
