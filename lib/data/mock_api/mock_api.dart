import 'dart:async';
import 'dart:math';

import '../models/transaction.dart';
import '../models/user.dart';
import '../models/wallet.dart';
import 'mock_data.dart';

/// Mock implementation of the API endpoints in API_REQUIREMENTS.md.
/// Adds realistic latency and produces stable, demo-friendly responses.
class MockApi {
  MockApi._();
  static final MockApi instance = MockApi._();

  final _rng = Random();
  final List<AppTransaction> _transactions = [...MockData.transactions];
  Wallet _wallet = MockData.wallet;

  Future<T> _delay<T>(T value, {int min = 350, int max = 900}) {
    final ms = min + _rng.nextInt(max - min);
    return Future.delayed(Duration(milliseconds: ms), () => value);
  }

  // ---------- AUTH ----------
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) =>
      _delay(AppUser(
        id: 'usr_${_rng.nextInt(99999)}',
        fullName: fullName,
        email: email,
        phone: phone,
        isVerified: false,
      ));

  Future<AppUser> login({required String email, required String password}) =>
      _delay(MockData.currentUser);

  Future<bool> verifyOtp({required String otp}) => _delay(otp.length == 6);

  Future<bool> createPin(String pin) => _delay(pin.length == 4 || pin.length == 6);

  // ---------- WALLET ----------
  Future<Wallet> getWallet() => _delay(_wallet);

  Future<DedicatedVirtualAccount> getDva() => _delay(MockData.dva);

  // ---------- TRANSFERS ----------
  Future<TransferQuote> quoteNgnTransfer({required double amount}) {
    final fee = amount < 5000 ? 10.0 : (amount < 50000 ? 25.0 : 50.0);
    return _delay(TransferQuote(
      quoteId: 'qte_${_rng.nextInt(99999)}',
      currency: TxCurrency.ngn,
      amount: amount,
      ngnAmount: amount,
      fee: fee,
      total: amount + fee,
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    ));
  }

  Future<TransferQuote> quoteUsdTransfer({required double usdAmount}) {
    final ngn = usdAmount * MockData.usdToNgnRate;
    final fee = ngn * 0.012;
    return _delay(TransferQuote(
      quoteId: 'qte_${_rng.nextInt(99999)}',
      currency: TxCurrency.usd,
      amount: usdAmount,
      ngnAmount: ngn,
      fee: fee,
      total: ngn + fee,
      fxRate: MockData.usdToNgnRate,
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    ));
  }

  Future<AppTransaction> confirmTransfer({
    required TransferQuote quote,
    required String recipientName,
    String? recipientAccount,
    String? bankName,
    String? memo,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final tx = AppTransaction(
      id: 'tx_${_rng.nextInt(99999)}',
      type: TxType.debit,
      status: TxStatus.success,
      currency: quote.currency,
      amount: quote.amount,
      ngnAmount: quote.ngnAmount,
      counterpartyName: recipientName,
      counterpartyAccount: recipientAccount,
      bankName: bankName,
      memo: memo,
      createdAt: DateTime.now(),
    );
    _transactions.insert(0, tx);
    _wallet = Wallet(
      id: _wallet.id,
      ngnBalance: _wallet.ngnBalance - quote.total,
      usdEquivalent: (_wallet.ngnBalance - quote.total) / MockData.usdToNgnRate,
    );
    return tx;
  }

  // ---------- TRANSACTIONS ----------
  Future<List<AppTransaction>> listTransactions() => _delay(List.unmodifiable(_transactions));

  Future<AppTransaction?> getTransaction(String id) =>
      _delay(_transactions.where((t) => t.id == id).cast<AppTransaction?>().firstOrNull);
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
