part of 'media_dialog_cubit.dart';

@immutable
abstract class MediaDialogState {}

class MediaDialogInitial extends MediaDialogState {}

class MediaDialogLoaded extends MediaDialogState {
  MediaDialogLoaded(this.photoURL);

  final String photoURL;
}

class MediaDialogLoading extends MediaDialogState {}

class MediaDialogError extends MediaDialogState {}
