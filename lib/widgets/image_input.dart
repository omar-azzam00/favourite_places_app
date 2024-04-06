import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatelessWidget {
  const ImageInput({super.key, required this.validator, required this.onSaved});

  final String? Function(File?) validator;
  final void Function(File?) onSaved;

  void pickImage(FormFieldState<File?> field) async {
    final imagePicker = ImagePicker();

    var pickedImageXFile = await imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedImageXFile != null) {
      field.didChange(File(pickedImageXFile.path));
    }
  }

  void previewImage(BuildContext context, FormFieldState<File?> field) {
    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.file(
                field.value!,
                fit: BoxFit.contain,
                width: double.infinity,
                height: 350,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  pickImage(field);
                },
                child: const Text('Take a new image'),
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).pop();
                  field.didChange(null);
                },
                child: const Text('Remove image'),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<File>(
      builder: (field) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: field.value == null
                  ? () {
                      pickImage(field);
                    }
                  : () {
                      previewImage(context, field);
                    },
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  border: field.hasError
                      ? Border.all(
                          width: .5,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: const Color.fromARGB(255, 255, 157, 157),
                        )
                      : null,
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: field.value == null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.photo_camera,
                            size: 48,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Take an image',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ],
                      )
                    : Image.file(
                        field.value!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
            ),
            if (field.hasError) ...[
              const SizedBox(height: 8),
              Text(
                field.errorText ?? '',
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 157, 157),
                ),
              ),
            ]
          ],
        );
      },
      validator: validator,
      onSaved: onSaved,
    );
  }
}
