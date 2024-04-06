import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/places_provider.dart';
import 'package:favourite_places/screens/new_place_screen.dart';
import 'package:favourite_places/screens/place_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var places = ref.watch(placesProvider).reversed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              pushNewPlaceScreen(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: getBody(context, ref, places),
    );
  }

  Widget getBody(BuildContext context, WidgetRef ref, Iterable<Place> places) {
    if (places.isEmpty) {
      return getNoPlacesBody(context);
    }
    return getNormalBody(context, ref, places);
  }

  Widget getNoPlacesBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'No places added yet.',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          '😞',
          style: TextStyle(fontSize: 48),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget getNormalBody(
      BuildContext context, WidgetRef ref, Iterable<Place> places) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Dismissible(
          background: Container(color: Colors.red),
          key: ValueKey(places.elementAt(index).id),
          onDismissed: (direction) {
            ref
                .read(placesProvider.notifier)
                .removePlace(places.elementAt(index).id);
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: FileImage(places.elementAt(index).image),
            ),
            title: Text(
              places.elementAt(index).title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            onTap: () {
              pushPlaceScreen(context, places.elementAt(index));
            },
          ),
        );
      },
      itemCount: places.length,
    );
  }

  void pushPlaceScreen(BuildContext context, Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return PlaceScreen(place);
        },
      ),
    );
  }

  void pushNewPlaceScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const NewPlaceScreen();
        },
      ),
    );
  }
}
