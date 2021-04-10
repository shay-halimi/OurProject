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

  String toHumanString() {
    /// @TODO(Matan) find a better place for this.
    /// @TODO(Matan) different currencies have different print format.
    return '${amount.toStringAsFixed(2)} ${currency.symbol}';
  }

  static const empty = Money(amount: 0, currency: Currency.unknown());

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}

class Currency {
  const Currency._({
    @required this.value,
    this.symbol = '',
  }) : assert(value != null);

  const Currency.unknown() : this._(value: 'XXX');

  const Currency.nis() : this._(value: 'NIS', symbol: '₪');

  const Currency.fromString(String value) : this._(value: value);

  final String value;

  final String symbol;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          symbol == other.symbol;

  @override
  int get hashCode => value.hashCode ^ symbol.hashCode;

  @override
  String toString() {
    return value;
  }
}
