part of 'point_form_cubit.dart';

class PointFormState extends Equatable {
  const PointFormState({
    this.titleInput = const TitleInput.pure(),
    this.descriptionInput = const DescriptionInput.pure(),
    this.priceInput = const PriceInput.pure(),
    this.mediaInput = const MediaInput.pure(),
    this.tagsInput = const TagsInput.pure(),
    this.availableInput = const AvailableInput.pure(),
    this.status = FormzStatus.pure,
  });

  final TitleInput titleInput;
  final DescriptionInput descriptionInput;
  final PriceInput priceInput;
  final MediaInput mediaInput;
  final TagsInput tagsInput;
  final AvailableInput availableInput;

  final FormzStatus status;

  @override
  List<Object> get props => [
        titleInput,
        descriptionInput,
        priceInput,
        mediaInput,
        tagsInput,
        availableInput,
        status,
      ];

  PointFormState copyWith({
    TitleInput titleInput,
    DescriptionInput descriptionInput,
    PriceInput priceInput,
    MediaInput mediaInput,
    TagsInput tagsInput,
    AvailableInput availableInput,
    FormzStatus status,
  }) {
    return PointFormState(
      titleInput: titleInput ?? this.titleInput,
      descriptionInput: descriptionInput ?? this.descriptionInput,
      priceInput: priceInput ?? this.priceInput,
      mediaInput: mediaInput ?? this.mediaInput,
      tagsInput: tagsInput ?? this.tagsInput,
      availableInput: availableInput ?? this.availableInput,
      status: status ?? this.status,
    );
  }
}

enum AvailableInputValidationError { invalid }

class AvailableInput extends FormzInput<bool, AvailableInputValidationError> {
  const AvailableInput.pure() : super.pure(false);

  const AvailableInput.dirty([bool value = false]) : super.dirty(value);

  @override
  AvailableInputValidationError validator(bool value) {
    return null;
  }
}

enum TitleValidationError { invalid }

class TitleInput extends FormzInput<String, TitleValidationError> {
  const TitleInput.pure() : super.pure('');

  const TitleInput.dirty([String value = '']) : super.dirty(value);

  @override
  TitleValidationError validator(String value) {
    return value.length > 3 && value.length < 60 && !value.contains('\n')
        ? null
        : TitleValidationError.invalid;
  }
}

enum DescriptionInputValidationError { invalid }

class DescriptionInput
    extends FormzInput<String, DescriptionInputValidationError> {
  const DescriptionInput.pure() : super.pure('');

  const DescriptionInput.dirty([String value = '']) : super.dirty(value);

  @override
  DescriptionInputValidationError validator(String value) {
    return value.length > 0 && value.length < 1000
        ? null
        : DescriptionInputValidationError.invalid;
  }
}

enum PriceInputValidationError { invalid }

class PriceInput extends FormzInput<Money, PriceInputValidationError> {
  const PriceInput.pure() : super.pure(Money.empty);

  const PriceInput.dirty([Money value = Money.empty]) : super.dirty(value);

  @override
  PriceInputValidationError validator(Money value) {
    return value.amount > 0 ? null : PriceInputValidationError.invalid;
  }
}

enum MediaInputValidationError { invalid }

class MediaInput extends FormzInput<Set<String>, MediaInputValidationError> {
  const MediaInput.pure() : super.pure(const {});

  const MediaInput.dirty([Set<String> value = const {}]) : super.dirty(value);

  @override
  MediaInputValidationError validator(Set<String> value) {
    return value.length == 1 ? null : MediaInputValidationError.invalid;
  }
}

enum TagsInputValidationError { invalid }

class TagsInput extends FormzInput<Set<String>, TagsInputValidationError> {
  const TagsInput.pure() : super.pure(const {});

  const TagsInput.dirty([Set<String> value = const {}]) : super.dirty(value);

  @override
  TagsInputValidationError validator(Set<String> value) {
    return null;
  }
}
