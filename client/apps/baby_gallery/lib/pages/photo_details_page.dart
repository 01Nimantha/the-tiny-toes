import 'package:baby_gallery/custom_widget/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(userName: _name, pageName: "Gallery"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
