import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'media_dialog_state.dart';

class MediaDialogCubit extends Cubit<MediaDialogState> {
  MediaDialogCubit() : super(MediaDialogInitial());

  final _uuid = Uuid();

  final _storage = FirebaseStorage.instance;

  Future<void> fileChanged(File file) async {
    final reference = _storage.ref().child('gallery/').child(_uuid.v1());

    final task = kIsWeb
        ? reference.putData(await file.readAsBytes())
        : reference.putFile(file);

    task.snapshotEvents.listen((TaskSnapshot snapshot) async {
      switch (snapshot?.state) {
        case TaskState.success:
          try {
            final url = await snapshot.ref.getDownloadURL();

            emit(MediaDialogLoaded(url));
          } on Exception {
            emit(MediaDialogError());
          }
          break;

        case TaskState.running:
          emit(MediaDialogLoading(file));
          break;

        case TaskState.paused:
        case TaskState.canceled:
        case TaskState.error:
          emit(MediaDialogError());
          break;
      }
    });
  }
}
