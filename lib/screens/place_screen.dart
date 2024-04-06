import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';

class PlaceScreen extends StatelessWidget {
  const PlaceScreen(this.place, {super.key});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          // the image is a background
          Image.file(
            place.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // the container is an overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.background.withOpacity(.9),
            // here is the real content
            child: Center(
              child: Text(
                place.title,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
