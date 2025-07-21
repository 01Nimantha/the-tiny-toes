import 'dart:convert';
import 'package:baby_gallery/pages/login_page.dart';
import 'package:baby_gallery/store/gallery.dart';
import 'package:baby_gallery/store/gallery_provider.dart';
import 'package:baby_gallery/store/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GalleryPage extends StatefulWidget {
  final String userName;
  final String albumName;
  const GalleryPage(
      {super.key, required this.userName, required this.albumName});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String _name = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    getUserName();
    fetchData();
  }

  Future<void> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('username') ?? '';
    });
  }

  Future<void> fetchData() async {
    try {
      await Future.delayed(Duration(seconds: 2)); // Optional delay
      final response = await http
          .get(Uri.parse('http://picsum.photos/v2/list?page=2&limit=100'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (!mounted) return;

        final gallery = jsonData.map((item) => Gallery.fromJson(item)).toList();
        Provider.of<GalleryProvider>(context, listen: false)
            .setGallery(gallery);

        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
      } else {
        throw Exception(
            'Failed to load albums. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: Colors.grey, thickness: 1, height: 20),
            const SizedBox(height: 30),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? _buildErrorWidget()
                      : _buildGalleryList(),
            ),
          ],
        ));
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          const Text(
            'Error loading gallery',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
              fetchData();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryList() {
    return Column(
      children: [
        Center(
          child: Text(
            widget.albumName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        const SizedBox(height: 50),
        Expanded(child: Consumer<GalleryProvider>(
          builder: (context, value, child) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: value.gallery.length,
              itemBuilder: (context, index) {
                final item = value.gallery[index];
                return GestureDetector(
                  onTap: () {
                    // Handle item tap
                  },
                  child: Column(
                    children: [
                      Image(
                          width: 100,
                          height: 100,
                          image: NetworkImage(item.downloadUrl),
                          fit: BoxFit.cover),
                      Text(item.author),
                    ],
                  ),
                );
              },
            );
          },
        ))
      ],
    );
  }
}
