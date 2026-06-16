enum TxType { credit, debit }

enum TxStatus { pending, success, failed }

enum TxCurrency { ngn, usd }

class AppTransaction {
  final String id;
  final TxType type;
  final TxStatus status;
  final TxCurrency currency;
  final double amount;
  final double? ngnAmount;
  final String counterpartyName;
  final String? counterpartyAccount;
  final String? bankName;
  final String? memo;
  final DateTime createdAt;

  const AppTransaction({
    required this.id,
    required this.type,
    required this.status,
    required this.currency,
    required this.amount,
    required this.counterpartyName,
    required this.createdAt,
    this.ngnAmount,
    this.counterpartyAccount,
    this.bankName,
    this.memo,
  });
}

class TransferQuote {
  final String quoteId;
  final TxCurrency currency;
  final double amount;
  final double ngnAmount;
  final double fee;
  final double total;
  final double? fxRate;
  final DateTime expiresAt;

  const TransferQuote({
    required this.quoteId,
    required this.currency,
    required this.amount,
    required this.ngnAmount,
    required this.fee,
    required this.total,
    required this.expiresAt,
    this.fxRate,
  });
}
