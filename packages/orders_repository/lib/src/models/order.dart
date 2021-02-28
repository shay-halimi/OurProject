import 'package:meta/meta.dart';

import '../entities/entities.dart';

@immutable
class Order {
  const Order({
    @required this.id,
  });

  factory Order.fromEntity(OrderEntity entity) {
    return Order(
      id: entity.id,
    );
  }

  final String id;

  Order copyWith({
    String id,
  }) {
    return Order(
      id: id ?? this.id,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Order{id: $id}';
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
    );
  }

  static const empty = Order(
    id: '',
  );
}
