import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'media_dialog_cubit.dart';

class MediaDialog extends StatelessWidget {
  MediaDialog({
    Key key,
    @required this.onMediaCreated,
  }) : super(key: key);

  final ImagePicker _picker = ImagePicker();

  final ValueChanged<String> onMediaCreated;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MediaDialogCubit, MediaDialogState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is MediaDialogLoaded) {
          onMediaCreated(state.photoURL);
        }
      },
      child: Column(
        children: [
          InkWell(
            onTap: () => showDialog<ImageSource>(
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
                }).then((value) async {
              if (value != null) {
                await _picker.getImage(source: value).then((value) async {
                  await context
                      .read<MediaDialogCubit>()
                      .fileChanged(File(value.path));
                });
              }
            }),
            child: AspectRatio(
              aspectRatio: 3 / 1,
              child: BlocBuilder<MediaDialogCubit, MediaDialogState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  if (state is MediaDialogInitial) {
                    return const Center(child: Text('בחר תמונה'));
                  }

                  if (state is MediaDialogLoaded) {
                    return Image.network(
                      state.photoURL,
                      fit: BoxFit.cover,
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
