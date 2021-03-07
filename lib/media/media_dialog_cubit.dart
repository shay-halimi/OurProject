import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'media_dialog_state.dart';

class MediaDialogCubit extends Cubit<MediaDialogState> {
  MediaDialogCubit() : super(MediaDialogInitial());

  Future<void> fileChanged(File file) async {
    var reference =
        FirebaseStorage.instance.ref().child('gallery/').child(Uuid().v1());

    UploadTask task;

    if (kIsWeb) {
      task = reference.putData(await file.readAsBytes());
    } else {
      task = reference.putFile(file);
    }

    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      switch (snapshot?.state) {
        case TaskState.success:
          snapshot.ref
              .getDownloadURL()
              .then((value) => emit(MediaDialogLoaded(value)));
          break;

        case TaskState.running:
          emit(MediaDialogLoading());
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
