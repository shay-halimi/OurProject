import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Verification extends Equatable {
  const Verification({
    @required this.id,
  }) : assert(id != null);

  final String id;

  static const empty = Verification(id: '');

  @override
  List<Object> get props => [id];

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}
