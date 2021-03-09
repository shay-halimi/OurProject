import 'dart:io';

import 'package:cookpoint/media/media_widget.dart';
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
                final pickedFile = await _picker.getImage(
                  source: value,
                  maxWidth: 1280,
                  maxHeight: 720,
                );

                await context
                    .read<MediaDialogCubit>()
                    .fileChanged(File(pickedFile.path));
              }
            }),
            child: BlocBuilder<MediaDialogCubit, MediaDialogState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                final aspectRatio = 3 / 1;

                if (state is MediaDialogInitial) {
                  return AspectRatio(
                    aspectRatio: aspectRatio,
                    child: const Center(child: Text('בחר תמונה')),
                  );
                } else if (state is MediaDialogError) {
                  return AspectRatio(
                    aspectRatio: aspectRatio,
                    child:
                        const Center(child: Text('שגיאה, נסה שוב מאוחר יותר')),
                  );
                } else if (state is MediaDialogLoading) {
                  return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        AspectRatio(
                          aspectRatio: aspectRatio,
                          child: Image.file(
                            state.file,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const CircularProgressIndicator(),
                      ]);
                } else if (state is MediaDialogLoaded) {
                  return AspectRatio(
                    aspectRatio: aspectRatio,
                    child: MediaWidget(media: state.photoURL),
                  );
                }

                return AspectRatio(
                  aspectRatio: aspectRatio,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
