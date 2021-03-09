import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:points_repository/points_repository.dart';

part 'create_point_form_state.dart';

class PointFormCubit extends Cubit<PointFormState> {
  PointFormCubit({
    @required Point point,
    @required PointsRepository pointsRepository,
  })  : assert(point != null),
        assert(pointsRepository != null),
        _point = point,
        _pointsRepository = pointsRepository,
        super(const PointFormState()) {
    emit(state.copyWith(
      relevantInput: RelevantInput.dirty(point.relevant),
      titleInput: TitleInput.dirty(point.title),
      descriptionInput: DescriptionInput.dirty(point.description),
      priceInput: PriceInput.dirty(point.price),
      mediaInput: MediaInput.dirty(point.media),
      tagsInput: TagsInput.dirty(point.tags),
    ));
  }

  final Point _point;
  final PointsRepository _pointsRepository;

  Future<void> submit() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final point = _point.copyWith(
        relevant: state.relevantInput.value,
        title: state.titleInput.value,
        description: state.descriptionInput.value,
        price: state.priceInput.value,
        media: state.mediaInput.value,
        tags: state.tagsInput.value,
      );

      if (point.id.isEmpty) {
        await _pointsRepository.add(point);
      } else {
        await _pointsRepository.update(point);
      }

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void changeRelevant(bool value) {
    final relevantInput = RelevantInput.dirty(value);
    emit(state.copyWith(
      relevantInput: relevantInput,
      status: Formz.validate([
        relevantInput,
        state.titleInput,
        state.descriptionInput,
        state.priceInput,
        state.mediaInput,
        state.tagsInput,
      ]),
    ));
  }

  void changeTitle(String value) {
    final titleInput = TitleInput.dirty(value);
    emit(state.copyWith(
      titleInput: titleInput,
      status: Formz.validate([
        state.relevantInput,
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
        state.relevantInput,
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
        state.relevantInput,
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
        state.relevantInput,
        state.titleInput,
        state.descriptionInput,
        state.priceInput,
        mediaInput,
        state.tagsInput,
      ]),
    ));
  }

  void toggledTag(String value) {
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
        state.relevantInput,
        state.titleInput,
        state.descriptionInput,
        state.priceInput,
        state.mediaInput,
        tagsInput,
      ]),
    ));
  }
}
