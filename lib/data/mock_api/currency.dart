enum AmountCurrency {
  ngn(symbol: '₦', code: 'NGN', label: 'Nigerian Naira'),
  usd(symbol: '\$', code: 'USD', label: 'U.S. Dollar'),
  cny(symbol: '¥', code: 'CNY', label: 'Chinese Yuan');

  final String symbol;
  final String code;
  final String label;
  const AmountCurrency({
    required this.symbol,
    required this.code,
    required this.label,
  });
}
