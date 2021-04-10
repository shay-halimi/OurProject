import 'dart:io';

import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
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
      listener: (_, state) {
        if (state is MediaDialogLoaded) {
          onMediaChanged({state.url});
        }
      },
      child: Column(
        children: [
          InkWell(
            onTap: () => showDialog<ImageSource>(
                context: context,
                builder: (_) {
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
                }).then((value) async {
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

                onMediaChanged(media);

                await context
                    .read<MediaDialogCubit>()
                    .fileChanged(File(croppedFile.path));
              }
            }),
            child: BlocBuilder<MediaDialogCubit, MediaDialogState>(
              buildWhen: (previous, current) => previous != current,
              builder: (_, state) {
                final aspectRatio = MediaWidget.defaultAspectRatio;
                final maxHeight = MediaQuery.of(context).size.height / 3;

                if (state is MediaDialogInitial) {
                  return AspectRatio(
                    aspectRatio: aspectRatio,
                    child: media.isEmpty
                        ? Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: borderRadius,
                            ),
                            child: Center(
                              child: Text(
                                'בחר/י תמונה',
                                style: theme.textTheme.bodyText1,
                              ),
                            ),
                          )
                        : MediaWidget(
                            url: media.first,
                            aspectRatio: aspectRatio,
                            maxHeight: maxHeight,
                          ),
                  );
                } else if (state is MediaDialogError) {
                  return AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: maxHeight),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: borderRadius,
                      ),
                      child: Center(
                        child: Text(
                          'שגיאה, אמת/י המידע שהזנת ונסה/י שנית.',
                          style: theme.textTheme.bodyText1,
                        ),
                      ),
                    ),
                  );
                } else if (state is MediaDialogLoading) {
                  return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        MediaWidget(
                          image: FileImage(state.file),
                          aspectRatio: aspectRatio,
                          maxHeight: maxHeight,
                        ),
                        const CircularProgressIndicator(),
                      ]);
                } else if (state is MediaDialogLoaded) {
                  return MediaWidget(
                    url: state.url,
                    aspectRatio: aspectRatio,
                    maxHeight: maxHeight,
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
