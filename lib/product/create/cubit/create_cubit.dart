import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/product/product.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:products_repository/products_repository.dart';

part 'create_state.dart';

class CreateCubit extends Cubit<CreateState> {
  final ProductsRepository _productsRepository;

  CreateCubit(this._productsRepository)
      : assert(_productsRepository != null),
        super(const CreateState());

  Future<void> confirmPhoneNumber() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      await _productsRepository.add(
        Product.empty.copyWith(
          supplierId: "todo", // todo
          title: state.title.value,
          description: state.description.value,
          price: Money(
            amount: num.parse(state.price.value).toDouble(),
            currency: Money.CURRENCY_NIS,
          ),
          media: state.media,
          tags: state.tags.value.split(',').toSet(),
        ),
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
