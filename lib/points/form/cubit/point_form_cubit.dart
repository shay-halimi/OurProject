import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/points/points.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'point_form_state.dart';

class PointFormCubit extends Cubit<PointFormState> {
  PointFormCubit({
    @required Point point,
    @required PointsBloc pointsBloc,
  })  : assert(point != null),
        assert(pointsBloc != null),
        _point = point,
        _pointsBloc = pointsBloc,
        super(const PointFormState()) {
    if (_point.isNotEmpty) {
      emit(state.copyWith(
        titleInput: TitleInput.dirty(point.title),
        descriptionInput: DescriptionInput.dirty(point.description),
        priceInput: PriceInput.dirty(point.price),
        mediaInput: MediaInput.dirty(point.media),
        tagsInput: TagsInput.dirty(point.tags),
      ));
    }
  }

  final Point _point;
  final PointsBloc _pointsBloc;

  Future<void> save() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final point = _point.copyWith(
        title: state.titleInput.value,
        description: state.descriptionInput.value,
        price: state.priceInput.value,
        media: state.mediaInput.value,
        tags: state.tagsInput.value,
      );

      _pointsBloc.add(
          _point.isEmpty ? PointCreatedEvent(point) : PointUpdatedEvent(point));

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void changeTitle(String value) {
    final titleInput = TitleInput.dirty(value);
    emit(state.copyWith(
      titleInput: titleInput,
      status: Formz.validate([
        titleInput,
        state.descriptionInput,
        state.priceInput,
        state.mediaInput,
        state.tagsInput,
      ]),
    ));
  }

  void changeDescription(String value) {
    final descriptionInput = DescriptionInput.dirty(value);
    emit(state.copyWith(
      descriptionInput: descriptionInput,
      status: Formz.validate([
        state.titleInput,
        descriptionInput,
        state.priceInput,
        state.mediaInput,
        state.tagsInput,
      ]),
    ));
  }

  void changePrice(String value) {
    final priceInput = PriceInput.dirty(Money(
      amount: (num.tryParse(value) ?? -1).toDouble(),
      currency: const Currency.nis(),
    ));

    emit(state.copyWith(
      priceInput: priceInput,
      status: Formz.validate([
        state.titleInput,
        state.descriptionInput,
        priceInput,
        state.mediaInput,
        state.tagsInput,
      ]),
    ));
  }

  void changeMedia(Set<String> value) {
    final mediaInput = MediaInput.dirty(value);
    emit(state.copyWith(
      mediaInput: mediaInput,
      status: Formz.validate([
        state.titleInput,
        state.descriptionInput,
        state.priceInput,
        mediaInput,
        state.tagsInput,
      ]),
    ));
  }

  void toggleTag(String value) {
    var tags = {...state.tagsInput.value};

    if (tags.contains(value)) {
      tags.remove(value);
    } else {
      tags.add(value);
    }

    final tagsInput = TagsInput.dirty(tags);

    emit(state.copyWith(
      tagsInput: tagsInput,
      status: Formz.validate([
        state.titleInput,
        state.descriptionInput,
        state.priceInput,
        state.mediaInput,
        tagsInput,
      ]),
    ));
  }
}
