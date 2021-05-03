import 'package:meta/meta.dart';

@immutable
class Money {
  const Money({
    @required this.amount,
    @required this.currency,
  })  : assert(amount != null),
        assert(currency != null);

  factory Money.fromJson(Map<String, Object> map) {
    return Money(
      amount: (map['amount'] as num).toDouble(),
      currency: Currency.fromString(map['currency'] as String),
    );
  }

  final double amount;

  final Currency currency;

  Money copyWith({
    double amount,
    Currency currency,
  }) {
    return Money(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          currency == other.currency;

  @override
  int get hashCode => amount.hashCode ^ currency.hashCode;

  @override
  String toString() {
    return 'Money{amount: $amount, currency: $currency}';
  }

  Map<String, Object> toJson() {
    return {
      'amount': amount,
      'currency': currency.toString(),
    };
  }

  static const empty = Money(amount: 0, currency: Currency.unknown);

  bool get isEmpty => amount.floor() == 0;

  bool get isNotEmpty => !isEmpty;
}

/// @TODO(Matan) follow ISO 4217
/// @TODO(Matan) see https://www.currency-iso.org/dam/downloads/lists/list_one.xml .
class Currency {
  const Currency._({
    @required this.value,
  }) : assert(value != null);

  const Currency.fromString(String value) : this._(value: value);

  static const Currency unknown = Currency.fromString('XXX');

  static const Currency ils = Currency.fromString('ILS');

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return value;
  }
}
