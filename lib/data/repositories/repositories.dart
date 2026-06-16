import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock_api/mock_api.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../models/wallet.dart';

/// Thin Riverpod-friendly wrappers around MockApi. These mirror the
/// endpoint list in API_REQUIREMENTS.md so swapping in a real backend
/// later is a single-file change.

final mockApiProvider = Provider<MockApi>((_) => MockApi.instance);

// --- AUTH ---
class AuthRepository {
  AuthRepository(this._api);
  final MockApi _api;

  Future<AppUser> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) =>
      _api.register(fullName: fullName, email: email, phone: phone, password: password);

  Future<AppUser> login(String email, String password) => _api.login(email: email, password: password);
  Future<bool> verifyOtp(String otp) => _api.verifyOtp(otp: otp);
  Future<bool> createPin(String pin) => _api.createPin(pin);
}

final authRepositoryProvider = Provider((ref) => AuthRepository(ref.watch(mockApiProvider)));

/// Currently-authenticated user (null when signed out).
final currentUserProvider = StateProvider<AppUser?>((_) => null);

// --- WALLET ---
class WalletRepository {
  WalletRepository(this._api);
  final MockApi _api;
  Future<Wallet> get() => _api.getWallet();
  Future<DedicatedVirtualAccount> dva() => _api.getDva();
}

final walletRepositoryProvider = Provider((ref) => WalletRepository(ref.watch(mockApiProvider)));
final walletProvider = FutureProvider<Wallet>((ref) => ref.watch(walletRepositoryProvider).get());
final dvaProvider = FutureProvider<DedicatedVirtualAccount>((ref) => ref.watch(walletRepositoryProvider).dva());

// --- TRANSFERS ---
class TransferRepository {
  TransferRepository(this._api);
  final MockApi _api;
  Future<TransferQuote> quoteNgn(double amount) => _api.quoteNgnTransfer(amount: amount);
  Future<TransferQuote> quoteUsd(double usdAmount) => _api.quoteUsdTransfer(usdAmount: usdAmount);
  Future<AppTransaction> confirm({
    required TransferQuote quote,
    required String recipientName,
    String? recipientAccount,
    String? bankName,
    String? memo,
  }) =>
      _api.confirmTransfer(
        quote: quote,
        recipientName: recipientName,
        recipientAccount: recipientAccount,
        bankName: bankName,
        memo: memo,
      );
}

final transferRepositoryProvider = Provider((ref) => TransferRepository(ref.watch(mockApiProvider)));

// --- TRANSACTIONS ---
class TransactionRepository {
  TransactionRepository(this._api);
  final MockApi _api;
  Future<List<AppTransaction>> list() => _api.listTransactions();
  Future<AppTransaction?> get(String id) => _api.getTransaction(id);
}

final transactionRepositoryProvider = Provider((ref) => TransactionRepository(ref.watch(mockApiProvider)));
final transactionsProvider =
    FutureProvider<List<AppTransaction>>((ref) => ref.watch(transactionRepositoryProvider).list());
