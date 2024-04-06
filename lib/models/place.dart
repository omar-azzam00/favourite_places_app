import 'dart:io';

class Place {
  static int currentId = 0;

  Place(this.title, this.image) : id = currentId++;
  Place.id(this.title, this.image, this.id) {
    currentId = id + 1;
  }

  final String title;
  final int id;
  File image;
}
