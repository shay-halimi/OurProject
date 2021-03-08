import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:points_repository/points_repository.dart';

part 'create_point_form_state.dart';

class PointFormCubit extends Cubit<PointFormState> {
  PointFormCubit(this._pointsRepository)
      : assert(_pointsRepository != null),
        super(const PointFormState());

  final PointsRepository _pointsRepository;

  void changeCookerId(String value) {
    final cookedIdInput = CookedIdInput.dirty(value);
    emit(state.copyWith(
      cookedIdInput: cookedIdInput,
      status: Formz.validate([
        cookedIdInput,
        state.latitudeInput,
        state.longitudeInput,
        state.relevantInput,
        state.titleInput,
        state.descriptionInput,
        state.priceInput,
        state.mediaInput,
        state.tagsInput,
      ]),
    ));
  }

  void changeLocation(double latitude, double longitude) {
    final latitudeInput = LatitudeInput.dirty(latitude);
    final longitudeInput = LongitudeInput.dirty(longitude);
    emit(state.copyWith(
      latitudeInput: latitudeInput,
      longitudeInput: longitudeInput,
      status: Formz.validate([
        state.cookedIdInput,
        latitudeInput,
        longitudeInput,
        state.relevantInput,
        state.titleInput,
        state.descriptionInput,
        state.priceInput,
        state.mediaInput,
        state.tagsInput,
      ]),
    ));
  }

  void changeRelevant(bool value) {
    final relevantInput = RelevantInput.dirty(value);
    emit(state.copyWith(
      relevantInput: relevantInput,
      status: Formz.validate([
        state.cookedIdInput,
        state.latitudeInput,
        state.longitudeInput,
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
        state.cookedIdInput,
        state.latitudeInput,
        state.longitudeInput,
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
        state.cookedIdInput,
        state.latitudeInput,
        state.longitudeInput,
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
    final priceInput = PriceInput.dirty(value);
    emit(state.copyWith(
      priceInput: priceInput,
      status: Formz.validate([
        state.cookedIdInput,
        state.latitudeInput,
        state.longitudeInput,
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
        state.cookedIdInput,
        state.latitudeInput,
        state.longitudeInput,
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
        state.cookedIdInput,
        state.latitudeInput,
        state.longitudeInput,
        state.relevantInput,
        state.titleInput,
        state.descriptionInput,
        state.priceInput,
        state.mediaInput,
        tagsInput,
      ]),
    ));
  }

  Future<void> submit() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      await _pointsRepository.add(Point.empty.copyWith(
        cookerId: state.cookedIdInput.value,
        latitude: state.latitudeInput.value,
        longitude: state.longitudeInput.value,
        relevant: state.relevantInput.value,
        title: state.titleInput.value,
        description: state.descriptionInput.value,
        price: Money(
          amount: num.parse(state.priceInput.value).toDouble(),
          currency: const Currency.nis(),
        ),
        media: state.mediaInput.value,
        tags: state.tagsInput.value,
      ));
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
