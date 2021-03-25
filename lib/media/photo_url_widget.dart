import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'media_dialog_cubit.dart';

class PhotoURLWidget extends StatelessWidget {
  PhotoURLWidget({
    Key key,
    @required this.photoURL,
    @required this.onPhotoURLChanged,
  }) : super(key: key);

  final String photoURL;
  final ValueChanged<String> onPhotoURLChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MediaDialogCubit(),
      child: _PhotoURLDialogView(
        onPhotoURLChanged: onPhotoURLChanged,
        photoURL: photoURL,
      ),
    );
  }
}

class _PhotoURLDialogView extends StatelessWidget {
  _PhotoURLDialogView({
    Key key,
    @required this.photoURL,
    @required this.onPhotoURLChanged,
  }) : super(key: key);

  final String photoURL;
  final ValueChanged<String> onPhotoURLChanged;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final radius = 100.0;

    return BlocConsumer<MediaDialogCubit, MediaDialogState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is MediaDialogLoaded) {
          onPhotoURLChanged(state.photoURL);
        }
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            BlocBuilder<MediaDialogCubit, MediaDialogState>(
                builder: (context, state) {
              if (state is MediaDialogInitial) {
                return photoURL.isNotEmpty
                    ? CircleAvatar(
                        radius: radius,
                        backgroundImage: CachedNetworkImageProvider(photoURL))
                    : CircleAvatar(
                        radius: radius,
                        child: const Text('בחר/י תמונת פרופיל'));
              } else if (state is MediaDialogError) {
                CircleAvatar(
                  radius: radius,
                  child: const Text('שגיאה, אמת/י המידע שהזנת ונסה/י שנית.'),
                );
              } else if (state is MediaDialogLoading) {
                return CircleAvatar(
                  radius: radius,
                  backgroundImage: FileImage(state.file),
                );
              } else if (state is MediaDialogLoaded) {
                return CircleAvatar(
                  radius: radius,
                  backgroundImage: CachedNetworkImageProvider(state.photoURL),
                );
              }

              return CircleAvatar(
                radius: radius,
              );
            }),
            BlocBuilder<MediaDialogCubit, MediaDialogState>(
                builder: (context, state) {
              if (state is MediaDialogInitial) {
                return _CircleButton(
                  onPressed: () => _pickFile(context),
                  child: photoURL.isEmpty
                      ? const Icon(Icons.camera_alt)
                      : const Icon(Icons.edit),
                );
              } else if (state is MediaDialogError) {
                return _CircleButton(
                  onPressed: () => _pickFile(context),
                  fillColor: Colors.red.withOpacity(0.9),
                  child: const Icon(Icons.error),
                );
              } else if (state is MediaDialogLoaded) {
                return _CircleButton(
                  onPressed: () => _pickFile(context),
                  child: const Icon(Icons.edit),
                );
              }

              return const _CircleButton(
                child: CircularProgressIndicator(),
              );
            }),
          ],
        );
      },
    );
  }

  void _pickFile(BuildContext context) async {
    await _showMediaDialog(context).then((value) async {
      if (value != null) {
        final pickedFile = await _picker.getImage(
          source: value,
        );

        if (pickedFile == null) return;

        final croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: const AndroidUiSettings(
            toolbarTitle: '',
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
          ),
          iosUiSettings: const IOSUiSettings(
            title: '',
            doneButtonTitle: 'המשך',
            cancelButtonTitle: 'ביטול',
            aspectRatioLockEnabled: true,
          ),
        );

        if (croppedFile == null) return;

        await context
            .read<MediaDialogCubit>()
            .fileChanged(File(croppedFile.path));
      }
    });
  }

  Future<ImageSource> _showMediaDialog(BuildContext context) {
    return showDialog<ImageSource>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('בחר/י מקור תמונה'),
            actions: <Widget>[
              TextButton(
                child: const Text('בחר/י מהגלריה'),
                onPressed: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
              TextButton(
                child: const Text('צלמ/י תמונה חדשה'),
                onPressed: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
              TextButton(
                child: const Text('ביטול'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    Key key,
    this.onPressed,
    this.child,
    this.fillColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 2.0,
      fillColor: fillColor ?? Colors.white.withOpacity(0.9),
      child: child,
      padding: const EdgeInsets.all(8.0),
      shape: const CircleBorder(),
    );
  }
}
