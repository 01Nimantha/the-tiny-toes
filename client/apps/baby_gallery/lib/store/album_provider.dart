import 'package:baby_gallery/store/album.dart';
import 'package:flutter/material.dart';

class AlbumProvider with ChangeNotifier {
  List<Album> _albums = [];

  List<Album> get albums => _albums;

  void setAlbums(List<Album> albums) {
    _albums = albums;
    notifyListeners();
  }

  void addAlbum(Album album) {
    _albums.add(album);
    notifyListeners();
  }

  void removeAlbum(Album album) {
    _albums.remove(album);
    notifyListeners();
  }
}
