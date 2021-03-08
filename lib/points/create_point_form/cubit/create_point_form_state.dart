part of 'create_point_form_cubit.dart';

class PointFormState extends Equatable {
  const PointFormState({
    this.cookedIdInput = const CookedIdInput.pure(),
    this.latitudeInput = const LatitudeInput.pure(),
    this.longitudeInput = const LongitudeInput.pure(),
    this.relevantInput = const RelevantInput.pure(),
    this.titleInput = const TitleInput.pure(),
    this.descriptionInput = const DescriptionInput.pure(),
    this.priceInput = const PriceInput.pure(),
    this.mediaInput = const MediaInput.pure(),
    this.tagsInput = const TagsInput.pure(),
    this.status = FormzStatus.pure,
  });

  final CookedIdInput cookedIdInput;
  final LatitudeInput latitudeInput;
  final LongitudeInput longitudeInput;
  final RelevantInput relevantInput;
  final TitleInput titleInput;
  final DescriptionInput descriptionInput;
  final PriceInput priceInput;
  final MediaInput mediaInput;
  final TagsInput tagsInput;

  final FormzStatus status;

  @override
  List<Object> get props => [
        cookedIdInput,
        latitudeInput,
        longitudeInput,
        relevantInput,
        titleInput,
        descriptionInput,
        priceInput,
        mediaInput,
        tagsInput,
        status,
      ];

  PointFormState copyWith({
    CookedIdInput cookedIdInput,
    LatitudeInput latitudeInput,
    LongitudeInput longitudeInput,
    RelevantInput relevantInput,
    TitleInput titleInput,
    DescriptionInput descriptionInput,
    PriceInput priceInput,
    MediaInput mediaInput,
    TagsInput tagsInput,
    FormzStatus status,
  }) {
    return PointFormState(
      cookedIdInput: cookedIdInput ?? this.cookedIdInput,
      latitudeInput: latitudeInput ?? this.latitudeInput,
      longitudeInput: longitudeInput ?? this.longitudeInput,
      relevantInput: relevantInput ?? this.relevantInput,
      titleInput: titleInput ?? this.titleInput,
      descriptionInput: descriptionInput ?? this.descriptionInput,
      priceInput: priceInput ?? this.priceInput,
      mediaInput: mediaInput ?? this.mediaInput,
      tagsInput: tagsInput ?? this.tagsInput,
      status: status ?? this.status,
    );
  }
}

enum CookedIdInputValidationError { invalid }

class CookedIdInput extends FormzInput<String, CookedIdInputValidationError> {
  const CookedIdInput.pure() : super.pure('');

  const CookedIdInput.dirty([String value = '']) : super.dirty(value);

  @override
  CookedIdInputValidationError validator(String value) {
    return value != null ? null : CookedIdInputValidationError.invalid;
  }
}

enum LatitudeInputValidationError { invalid }

class LatitudeInput extends FormzInput<double, LatitudeInputValidationError> {
  const LatitudeInput.pure() : super.pure(0.0);

  const LatitudeInput.dirty([double value = 0.0]) : super.dirty(value);

  @override
  LatitudeInputValidationError validator(double value) {
    return value != null ? null : LatitudeInputValidationError.invalid;
  }
}

enum LongitudeInputValidationError { invalid }

class LongitudeInput extends FormzInput<double, LongitudeInputValidationError> {
  const LongitudeInput.pure() : super.pure(0.0);

  const LongitudeInput.dirty([double value = 0.0]) : super.dirty(value);

  @override
  LongitudeInputValidationError validator(double value) {
    return value != null ? null : LongitudeInputValidationError.invalid;
  }
}

enum RelevantInputValidationError { invalid }

class RelevantInput extends FormzInput<bool, RelevantInputValidationError> {
  const RelevantInput.pure() : super.pure(true);

  const RelevantInput.dirty([bool value = true]) : super.dirty(value);

  @override
  RelevantInputValidationError validator(bool value) {
    return value != null ? null : RelevantInputValidationError.invalid;
  }
}

enum TitleValidationError { invalid }

class TitleInput extends FormzInput<String, TitleValidationError> {
  const TitleInput.pure() : super.pure('');

  const TitleInput.dirty([String value = '']) : super.dirty(value);

  @override
  TitleValidationError validator(String value) {
    return value.length < 60 && !value.contains('\n')
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
    return value.length < 1000 ? null : DescriptionInputValidationError.invalid;
  }
}

enum PriceInputValidationError { invalid }

class PriceInput extends FormzInput<String, PriceInputValidationError> {
  const PriceInput.pure() : super.pure('');

  const PriceInput.dirty([String value = '']) : super.dirty(value);

  @override
  PriceInputValidationError validator(String value) {
    var val = num.tryParse(value);

    return val != null && val >= 0 ? null : PriceInputValidationError.invalid;
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
    return value != null ? null : TagsInputValidationError.invalid;
  }
}
