import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  const User({
    @required this.id,
    this.phoneNumber = '',
  }) : assert(id != null);

  final String id;

  final String phoneNumber;

  static const empty = User(
    id: '',
    phoneNumber: '',
  );

  @override
  List<Object> get props => [id, phoneNumber];

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}
