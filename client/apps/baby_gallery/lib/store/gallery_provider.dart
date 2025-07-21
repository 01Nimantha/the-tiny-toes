import 'package:baby_gallery/store/gallery.dart';
import 'package:flutter/material.dart';

class GalleryProvider with ChangeNotifier {
  List<Gallery> _gallery = [];

  List<Gallery> get gallery => _gallery;

  void setGallery(List<Gallery> galleries) {
    _gallery = galleries;
    notifyListeners();
  }

  void addGallery(Gallery gallery) {
    _gallery.add(gallery);
    notifyListeners();
  }

  void removeGallery(String id) {
    _gallery.removeWhere((gallery) => gallery.id == id);
    notifyListeners();
  }
}
