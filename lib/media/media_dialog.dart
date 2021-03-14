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
    @required this.media,
    @required this.onMediaChanged,
  }) : super(key: key);

  final Set<String> media;
  final ValueChanged<Set<String>> onMediaChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MediaDialogCubit(),
      child: MediaDialogView(onMediaChanged: onMediaChanged, media: media),
    );
  }
}

class MediaDialogView extends StatelessWidget {
  MediaDialogView({
    Key key,
    @required this.onMediaChanged,
    @required this.media,
  }) : super(key: key);

  final ValueChanged<Set<String>> onMediaChanged;
  final ImagePicker _picker = ImagePicker();
  final Set<String> media;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MediaDialogCubit, MediaDialogState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is MediaDialogLoaded) {
          onMediaChanged({state.photoURL});
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
                final aspectRatio = 1280 / 720;

                if (state is MediaDialogInitial) {
                  return AspectRatio(
                    aspectRatio: aspectRatio,
                    child: media.isEmpty
                        ? const Center(child: Text('בחר תמונה'))
                        : Image.network(
                            media.first,
                            fit: BoxFit.cover,
                          ),
                  );
                } else if (state is MediaDialogError) {
                  return AspectRatio(
                    aspectRatio: aspectRatio,
                    child: const Center(
                        child: Text('שגיאה, אמת.י המידע שהזנת ונסה.י שנית.')),
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
