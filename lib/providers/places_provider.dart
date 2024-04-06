import 'dart:io';

import 'package:favourite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []) {
    setPlaces();
  }

  late final SharedPreferences prefs;
  late final Directory directory;
  late List<String>? ids;
  bool isReadyToAdd = false;

  void setPlaces() async {
    prefs = await SharedPreferences.getInstance();
    directory = await getApplicationDocumentsDirectory();

    List<Place> places = [];
    ids = prefs.getStringList('ids');
    print(ids);
    print(await directory.list().toList());

    if (ids != null) {
      for (final id in ids!) {
        final title = prefs.getString(id);
        places.add(
          Place.id(
            title!,
            File('${directory.path}/$id'),
            int.parse(id),
          ),
        );
      }
    }

    state = places;
    isReadyToAdd = true;
  }

  bool addPlace(Map<String, Object> PlaceMap) {
    if (isReadyToAdd) {
      final place = Place(PlaceMap['title'] as String, PlaceMap['img'] as File);

      final imageSavedFile = File('${directory.path}/${place.id}');
      imageSavedFile.writeAsBytes(place.image.readAsBytesSync());

      if (ids == null) {
        ids = [place.id.toString()];
      } else {
        ids!.add(place.id.toString());
      }
      prefs.setStringList('ids', ids!);

      prefs.setString(
        place.id.toString(),
        place.title,
      );

      state = [...state, place];

      return true;
    }
    return false;
  }

  void removePlace(int id) {
    ids!.remove(id.toString());
    prefs.setStringList('ids', ids!);

    prefs.remove(id.toString());

    final imageSavedFile = File('${directory.path}/$id');
    imageSavedFile.delete();

    state = state.where((place) => place.id != id).toList();
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
