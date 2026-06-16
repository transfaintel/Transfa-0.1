class Wallet {
  final String id;
  final double ngnBalance;
  final double usdEquivalent;
  final String currency;

  const Wallet({
    required this.id,
    required this.ngnBalance,
    required this.usdEquivalent,
    this.currency = 'NGN',
  });
}

class DedicatedVirtualAccount {
  final String accountNumber;
  final String accountName;
  final String bankName;

  const DedicatedVirtualAccount({
    required this.accountNumber,
    required this.accountName,
    required this.bankName,
  });
}
