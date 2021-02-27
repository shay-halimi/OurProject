part of 'create_cubit.dart';

class CreateProductState extends Equatable {
  const CreateProductState({
    this.description = const Description.pure(),
    this.price = const Price.pure(),
    this.tags = const Tags.pure(),
    this.title = const Title.pure(),
    this.status = FormzStatus.pure,
    this.media = const {},
  });

  final Description description;
  final Price price;
  final Tags tags;
  final Set<String> media;
  final Title title;

  final FormzStatus status;

  @override
  List<Object> get props => [description, price, tags, title, status, media];

  CreateProductState copyWith({
    Description description,
    Price price,
    Tags tags,
    Set<String> media,
    Title title,
    FormzStatus status,
  }) {
    return CreateProductState(
      description: description ?? this.description,
      price: price ?? this.price,
      tags: tags ?? this.tags,
      media: media ?? this.media,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }
}
