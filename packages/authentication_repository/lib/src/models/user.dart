import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    @required this.id,
    @required this.phoneNumber,
  })  : assert(phoneNumber != null),
        assert(id != null);

  /// The current user's id.
  final String id;

  /// The current user's phone number.
  final String phoneNumber;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '', phoneNumber: '');

  @override
  List<Object> get props => [id, phoneNumber];
}
