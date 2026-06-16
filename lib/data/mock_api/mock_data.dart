import '../models/transaction.dart';
import '../models/user.dart';
import '../models/wallet.dart';

/// Seed fixtures for the mock API.
class MockData {
  MockData._();

  static const AppUser currentUser = AppUser(
    id: 'usr_001',
    fullName: 'Magic',
    email: 'adaeze@transfa.app',
    phone: '+2348012345678',
    isVerified: true,
  );

  static const Wallet wallet = Wallet(
    id: 'wlt_001',
    ngnBalance: 25000.50,
    usdEquivalent: 285.20,
  );

  static const DedicatedVirtualAccount dva = DedicatedVirtualAccount(
    accountNumber: '703 208 4888',
    accountName: 'Adaeze Okafor / Transfa',
    bankName: 'Flutterwave / Wema',
  );

  /// Sample reference rate; the real backend resolves this dynamically.
  static const double usdToNgnRate = 1490.0;

  static final List<AppTransaction> transactions = [
    AppTransaction(
      id: 'tx_101',
      type: TxType.credit,
      status: TxStatus.success,
      currency: TxCurrency.ngn,
      amount: 150000,
      counterpartyName: 'Wallet funding',
      bankName: 'Flutterwave DVA',
      memo: 'Top-up',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AppTransaction(
      id: 'tx_102',
      type: TxType.debit,
      status: TxStatus.success,
      currency: TxCurrency.ngn,
      amount: 25500,
      counterpartyName: 'Tunde Bello',
      counterpartyAccount: '0123456789',
      bankName: 'GTBank',
      memo: 'Rent split',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),
    AppTransaction(
      id: 'tx_103',
      type: TxType.debit,
      status: TxStatus.success,
      currency: TxCurrency.usd,
      amount: 120,
      ngnAmount: 178800,
      counterpartyName: 'Sarah Mensah',
      counterpartyAccount: 'USDC ●●●● 4f2a',
      bankName: 'CashDrop USD',
      memo: 'Freelance pay',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    AppTransaction(
      id: 'tx_104',
      type: TxType.debit,
      status: TxStatus.pending,
      currency: TxCurrency.ngn,
      amount: 5000,
      counterpartyName: 'MTN Recharge',
      memo: 'Airtime',
      createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
    ),
    AppTransaction(
      id: 'tx_105',
      type: TxType.credit,
      status: TxStatus.success,
      currency: TxCurrency.ngn,
      amount: 50000,
      counterpartyName: 'Chidinma Eze',
      counterpartyAccount: '9988776655',
      bankName: 'Access Bank',
      memo: 'Refund',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
}
