import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/foods/foods.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'food_form_state.dart';

class FoodFormCubit extends Cubit<FoodFormState> {
  FoodFormCubit({
    @required Food food,
    @required FoodsBloc foodsBloc,
  })  : assert(food != null),
        assert(foodsBloc != null),
        _food = food,
        _foodsBloc = foodsBloc,
        super(const FoodFormState()) {
    if (_food.isNotEmpty) {
      emit(state.copyWith(
        titleInput: TitleInput.dirty(food.title),
        descriptionInput: DescriptionInput.dirty(food.description),
        priceInput: PriceInput.dirty(food.price),
        mediaInput: MediaInput.dirty(food.media),
        tagsInput: TagsInput.dirty(food.tags),
        deleteAtInput: DeleteAtInput.dirty(food.deletedAt),
      ));
    }
  }

  final Food _food;

  final FoodsBloc _foodsBloc;

  Future<void> save() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final food = _food.copyWith(
        title: state.titleInput.value,
        description: state.descriptionInput.value,
        price: state.priceInput.value,
        media: state.mediaInput.value,
        tags: state.tagsInput.value,
        deletedAt: state.deleteAtInput.value,
      );

      _foodsBloc
          .add(_food.isEmpty ? FoodCreatedEvent(food) : FoodUpdatedEvent(food));

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void changeTitle(String value) {
    final titleInput = TitleInput.dirty(value.trim());

    emit(state.copyWith(
      titleInput: titleInput,
      status: Formz.validate([
        titleInput,
        state.descriptionInput,
        state.priceInput,
        state.mediaInput,
        state.tagsInput,
        state.deleteAtInput,
      ]),
    ));
  }

  void changeDescription(String value) {
    final descriptionInput = DescriptionInput.dirty(value.trim());

    emit(state.copyWith(
      descriptionInput: descriptionInput,
      status: Formz.validate([
        state.titleInput,
        descriptionInput,
        state.priceInput,
        state.mediaInput,
        state.tagsInput,
        state.deleteAtInput,
      ]),
    ));
  }

  void changePrice(String value) {
    final priceInput = PriceInput.dirty(Money(
      amount: (num.tryParse(value.trim()) ?? -1).toDouble(),
      currency: Currency.ils,
    ));

    emit(state.copyWith(
      priceInput: priceInput,
      status: Formz.validate([
        state.titleInput,
        state.descriptionInput,
        priceInput,
        state.mediaInput,
        state.tagsInput,
        state.deleteAtInput,
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
        state.deleteAtInput,
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
        state.deleteAtInput,
      ]),
    ));
  }

  void changeAvailable(bool value) {
    final deleteAt = value
        ? Time.empty
        : (_food.deletedAt.isEmpty ? Time.now() : _food.deletedAt);

    final deletedAtInput = DeleteAtInput.dirty(deleteAt);

    emit(state.copyWith(
      deleteAtInput: deletedAtInput,
      status: Formz.validate([
        state.titleInput,
        state.descriptionInput,
        state.priceInput,
        state.mediaInput,
        state.tagsInput,
        deletedAtInput,
      ]),
    ));
  }
}
