import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:baby_gallery/pages/login_page.dart';
import 'package:baby_gallery/store/album.dart';
import 'package:baby_gallery/store/album_provider.dart';
import 'package:baby_gallery/store/login_provider.dart';

class AlbumPage extends StatefulWidget {
  final String userName;
  const AlbumPage({super.key, required this.userName});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
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
          .get(Uri.parse('http://jsonplaceholder.typicode.com/albums'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (!mounted) return;

        final albums = jsonData.map((album) => Album.fromJson(album)).toList();
        Provider.of<AlbumProvider>(context, listen: false).setAlbums(albums);

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
              "Album",
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
                    : _buildAlbumList(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          const Text(
            'Error loading albums',
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

  Widget _buildAlbumList() {
    return Column(
      children: [
        Center(
          child: Text(
            widget.userName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        const SizedBox(height: 50),
        Expanded(
          child: Consumer<AlbumProvider>(
            builder: (context, value, child) {
              final albums = value.albums;
              return ListView.builder(
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        Positioned(
                          top: 9,
                          child: Stack(
                            children: [
                              Container(
                                width: 390,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 100), // Reserve space to the left
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      album.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 90,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              album.id.toString(),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
