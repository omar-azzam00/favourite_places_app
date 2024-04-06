import 'dart:io';
import 'package:favourite_places/providers/places_provider.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlaceScreen extends ConsumerWidget {
  const NewPlaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

    String? enteredTitle;
    File? enteredImage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'the title of the place',
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                maxLength: 40,
                validator: (title) {
                  if (title == null || title.trim().isEmpty) {
                    return 'there is no title entered';
                  }
                  return null;
                },
                onSaved: (title) {
                  enteredTitle = title!;
                },
              ),
              const SizedBox(height: 12),
              ImageInput(
                validator: (imageFile) {
                  if (imageFile == null) {
                    return 'There is no image taken';
                  }
                  return null;
                },
                onSaved: (imageFile) {
                  enteredImage = imageFile;
                },
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (ref.read(placesProvider.notifier).addPlace(
                      {
                        'title': enteredTitle!,
                        'img': enteredImage!,
                      },
                    )) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                label: const Text('Add place'),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
