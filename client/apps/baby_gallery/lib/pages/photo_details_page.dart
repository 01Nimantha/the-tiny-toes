import 'package:baby_gallery/pages/login_page.dart';
import 'package:baby_gallery/store/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoDetailsPage extends StatefulWidget {
  final String userName;
  final String albumName;
  final String galleryName;
  final String imageUrl;
  const PhotoDetailsPage(
      {super.key,
      required this.userName,
      required this.albumName,
      required this.galleryName,
      required this.imageUrl});

  @override
  State<PhotoDetailsPage> createState() => _PhotoDetailsPageState();
}

class _PhotoDetailsPageState extends State<PhotoDetailsPage> {
  String _name = '';

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('username') ?? '';
    });
  }

  void _logout() {
    Provider.of<LoginProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            TextButton(
              onPressed: _logout,
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(Colors.red),
                side: WidgetStatePropertyAll(BorderSide(color: Colors.red)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              child: const Text('Logout'),
            ),
            const Spacer(flex: 2),
            const Text(
              "Gallery",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
            const Spacer(),
          ],
        ),
        actions: [
          Text(
            _name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person_outline, color: Colors.blue, size: 40),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Divider(color: Colors.grey, thickness: 1, height: 20),
            const SizedBox(height: 30),
            Text(
              widget.galleryName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                width: 400,
                height: 400,
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Spacer(
              flex: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Artist: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.userName,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Album: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  widget.albumName,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
