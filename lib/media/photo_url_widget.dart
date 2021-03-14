import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        radius: radius, backgroundImage: NetworkImage(photoURL))
                    : CircleAvatar(
                        radius: radius, child: Text('בחר.י תמונת פרופיל'));
              } else if (state is MediaDialogError) {
                CircleAvatar(radius: radius, child: Text('שגיאה'));
              } else if (state is MediaDialogLoading) {
                return CircleAvatar(
                  radius: radius,
                  backgroundImage: FileImage(state.file),
                );
              } else if (state is MediaDialogLoaded) {
                return CircleAvatar(
                  radius: radius,
                  backgroundImage: NetworkImage(state.photoURL),
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
                  onPressed: () async => await _pickFile(context),
                  child: photoURL.isEmpty
                      ? Icon(Icons.camera_alt)
                      : Icon(Icons.edit),
                );
              } else if (state is MediaDialogError) {
                return _CircleButton(
                  onPressed: () async => await _pickFile(context),
                  fillColor: Colors.red.withOpacity(0.9),
                  child: Icon(Icons.error),
                );
              } else if (state is MediaDialogLoaded) {
                return _CircleButton(
                  onPressed: () async => await _pickFile(context),
                  child: Icon(Icons.edit),
                );
              }

              return _CircleButton(
                child: CircularProgressIndicator(),
              );
            }),
          ],
        );
      },
    );
  }

  _pickFile(BuildContext context) async {
    _showMediaDialog(context).then((value) async {
      if (value != null) {
        final pickedFile = await _picker.getImage(
          source: value,
          maxWidth: 1280,
          maxHeight: 720,
        );

        await context
            .read<MediaDialogCubit>()
            .fileChanged(File(pickedFile.path));
      }
    });
  }

  Future<ImageSource> _showMediaDialog(BuildContext context) {
    return showDialog<ImageSource>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('בחר מקור תמונה'),
            actions: <Widget>[
              TextButton(
                child: const Text('בחירה מהגלריה'),
                onPressed: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
              TextButton(
                child: const Text('צלם תמונה חדשה'),
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
      padding: EdgeInsets.all(8.0),
      shape: CircleBorder(),
    );
  }
}
