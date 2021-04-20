import 'dart:io';

import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
                    title: Text(AppLocalizations.of(context).imageSourceBtn),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                            AppLocalizations.of(context).imageSourceGalleryBtn),
                        onPressed: () {
                          Navigator.of(context).pop(ImageSource.gallery);
                        },
                      ),
                      TextButton(
                        child: Text(
                            AppLocalizations.of(context).imageSourceCameraBtn),
                        onPressed: () {
                          Navigator.of(context).pop(ImageSource.camera);
                        },
                      ),
                      TextButton(
                        child: Text(AppLocalizations.of(context).cancelBtn),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }).then((value) async {
              if (value == null) return;

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
                iosUiSettings: IOSUiSettings(
                  title: '',
                  doneButtonTitle: AppLocalizations.of(context).continueBtn,
                  cancelButtonTitle: AppLocalizations.of(context).cancelBtn,
                  aspectRatioLockEnabled: true,
                ),
              );

              if (croppedFile == null) return;

              onMediaChanged(media);

              await context
                  .read<MediaDialogCubit>()
                  .fileChanged(File(croppedFile.path));
            }),
            child: AspectRatio(
              aspectRatio: MediaWidget.defaultAspectRatio,
              child: BlocBuilder<MediaDialogCubit, MediaDialogState>(
                buildWhen: (previous, current) => previous != current,
                builder: (_, state) {
                  final maxHeight = MediaQuery.of(context).size.height / 3;

                  if (state is MediaDialogInitial) {
                    return media.isEmpty
                        ? _Text(
                            AppLocalizations.of(context).pickImageBtn,
                            maxHeight: maxHeight,
                          )
                        : MediaWidget(
                            url: media.first,
                            maxHeight: maxHeight,
                          );
                  } else if (state is MediaDialogError) {
                    return _Text(
                      AppLocalizations.of(context).error,
                      maxHeight: maxHeight,
                    );
                  } else if (state is MediaDialogLoading) {
                    return Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          MediaWidget(
                            image: FileImage(state.file),
                            maxHeight: maxHeight,
                          ),
                          const CircularProgressIndicator(),
                        ]);
                  } else if (state is MediaDialogLoaded) {
                    return MediaWidget(
                      url: state.url,
                      maxHeight: maxHeight,
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

class _Text extends StatelessWidget {
  const _Text(
    this.data, {
    Key key,
    this.maxHeight = double.infinity,
  }) : super(key: key);

  final String data;

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Text(
          data,
          style: textTheme.headline6,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
