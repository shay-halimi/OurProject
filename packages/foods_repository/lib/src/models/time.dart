import 'package:meta/meta.dart';

@immutable
class Time {
  const Time({this.timestamp});

  factory Time.fromJson(Map<String, Object> map) {
    return Time(
      timestamp: (map['timestamp'] as num)?.toInt(),
    );
  }

  /// @nullable
  final int timestamp;

  @override
  String toString() {
    return '$Time{timestamp: $timestamp}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Time &&
          runtimeType == other.runtimeType &&
          timestamp == other.timestamp;

  @override
  int get hashCode => timestamp.hashCode;

  Map<String, Object> toJson() {
    return {'timestamp': timestamp};
  }

  static const empty = Time();

  static Time now() =>
      Time(timestamp: DateTime.now().toUtc().millisecondsSinceEpoch);

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}
