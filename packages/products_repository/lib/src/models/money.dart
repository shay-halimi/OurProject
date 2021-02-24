import 'package:meta/meta.dart';

@immutable
class Money {
  final double amount;
  final String currency;

  const Money({
    @required this.amount,
    @required this.currency,
  });

  Money copyWith({
    double amount,
    String currency,
  }) {
    if ((amount == null || identical(amount, this.amount)) &&
        (currency == null || identical(currency, this.currency))) {
      return this;
    }

    return new Money(
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

  factory Money.fromJson(Map<String, Object> map) {
    return new Money(
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
    );
  }

  Map<String, Object> toJson() {
    return {
      'amount': this.amount,
      'currency': this.currency,
    };
  }

  static const empty = Money(amount: 0, currency: CURRENCY_UNKNOWN);

  static const CURRENCY_UNKNOWN = 'XXX';
  static const CURRENCY_NIS = 'NIS';
}
