import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class OrderEntity extends Equatable {
  const OrderEntity({
    @required this.id,
  });

  factory OrderEntity.fromJson(Map<String, Object> json) {
    return OrderEntity(
      id: json['id'] as String,
    );
  }

  factory OrderEntity.fromSnapshot(DocumentSnapshot snap) {
    return OrderEntity(
      id: snap.id,
    );
  }

  final String id;

  @override
  List<Object> get props => [id];

  @override
  String toString() {
    return 'OrderEntity{id: $id}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
    };
  }

  Map<String, Object> toDocument() {
    return {};
  }
}
