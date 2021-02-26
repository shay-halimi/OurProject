import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// [User.empty] represents an unauthenticated user.
class User extends Equatable {
  const User({
    @required this.id,
    this.displayName = '',
    this.photoURL = '',
    this.phoneNumber = '',
  }) : assert(id != null);

  final String id;
  final String displayName;
  final String photoURL;
  final String phoneNumber;

  static const empty = User(id: '');

  @override
  List<Object> get props => [id, displayName, photoURL, phoneNumber];
}
