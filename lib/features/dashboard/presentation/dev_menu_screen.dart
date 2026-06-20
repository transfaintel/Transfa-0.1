import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transfa/features/pop-ups/multiple_banks_popup.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

// POP UP IMPORTS FOR DEV TESTING
import '../../../features/pop-ups/stampDuty_popup.dart';
import '../../../features/pop-ups/swiftCode_popup.dart';
import '../../../features/pop-ups/insufficientBalance_popup.dart';
import '../../../features/pop-ups/businessBanking_popup.dart';
import '../../../features/pop-ups/transfaAccountPreview_popup.dart';
import '../../../features/pop-ups/personalBanking_popup.dart';
import '../../../features/pop-ups/chooseBank_popup.dart';
import '../../../features/pop-ups/transfaStatus_popup.dart';
import '../../../features/pop-ups/transfaStatusProgress_popup.dart';
import '../../../features/pop-ups/transfaStatusUnavailable_popup.dart';
import '../../../features/pop-ups/transfaBankPrivacy_popup.dart';
import '../../../features/pop-ups/transfaIdPrivacy_popup copy.dart';
// import '../../../features/pop-ups/transfaAccountFound_popup.dart';
import '../../../features/pop-ups/transfaDone_popup.dart';
import '../../../features/pop-ups/checkYourNumber_popup.dart';
import '../../../features/pop-ups/enterCorrectCode_popup.dart';
import '../../../core/constants/assets.dart';
import '../../../features/pop-ups/currency_popup.dart';
import '../../../features/pop-ups/bank_unavailable_popup.dart';
import '../../../features/pop-ups/no_internet_popup.dart';
import '../../../features/pop-ups/cashdrop_popup.dart';

// BOTTOM SHEET IMPORTS FOR DEV TESTING
import '../../../features/bottom_sheets/pay_bottomsheet.dart';
import '../../../features/bottom_sheets/insufficientMoneySheet.dart';
import '../../../features/bottom_sheets/dollarAccountSheet.dart';
import '../../../features/bottom_sheets/multipleAccountsSheet.dart';
import '../../../features/bottom_sheets/convertCurrencySheet.dart';
import '../../../features/bottom_sheets/sendDollarsSheet.dart';
import '../../../features/bottom_sheets/summaryNotesSheet.dart';
import '../../../data/mock_api/currency.dart';

/// Debug-only screen that lists every route in the app so you can jump
/// directly to any screen during development. Reach it from the home
/// dashboard by long-pressing the "Home" title, or via the `/dev` route.
class DevMenuScreen extends StatefulWidget {
  const DevMenuScreen({super.key});

  @override
  State<DevMenuScreen> createState() => _DevMenuScreenState();
}

class _DevMenuScreenState extends State<DevMenuScreen> {
  // State variables for PaySheet testing
  String _paySheetMemo = '';
  String _paySheetAmount = '10,500.00';
  AmountCurrency _paySheetCurrency = AmountCurrency.ngn;

  // State variables for InsufficientMoneySheet testing
  String _insufficientSheetMemo = 'Tactical Technology Grant';
  String _insufficientSheetAmount = '10,500.00';
  AmountCurrency _insufficientSheetCurrency = AmountCurrency.ngn;
  String _insufficientSheetRecipientName = 'Obi Amadioha';
  String _insufficientSheetAccountNumber = '207 922 3313';
  String _insufficientSheetBankName = 'OPay';
  String _insufficientSheetBankLogo = Assets.bankOpay;
  double _insufficientSheetTransactionFee = 1000.00;
  double _insufficientSheetStampDuty = 50.00;

  // State variables for DollarSheet testing
  String _dollarSheetMemo = 'Tactical Technology Grant';
  String _dollarSheetAmount = '250,000.00';
  AmountCurrency _dollarSheetCurrency = AmountCurrency.usd;
  String _dollarSheetRecipientName = 'Obi Amadioha';
  String _dollarSheetAccountNumber = '207 922 3313';
  String _dollarSheetBankName = 'OPay';
  String _dollarSheetBankLogo = Assets.bankOpay;
  double _dollarSheetTransactionFee = 2500.00;
  double _dollarSheetDisputeProtection = 25000.00;

  // State variables for MultipleAccountsSheet testing
  String _multipleAccountsMemo = 'Tactical Technology Grant';
  String _multipleAccountsAmount = '250,000.00';
  AmountCurrency _multipleAccountsCurrency = AmountCurrency.usd;
  String _multipleAccountsRecipientName = 'Magic Payma';
  List<BankAccount> _multipleAccountsBanks = [
    const BankAccount(
      name: 'Transfa',
      logoAsset: Assets.transfaAirMood,
      gradientColor1: Color.fromARGB(255, 240, 239, 239),
      gradientColor2: Color(0xFFFFFFFF),
    ),
    const BankAccount(
      name: 'Chase',
      logoAsset: Assets.bankchase,
      gradientColor1: Color.fromARGB(255, 240, 239, 239),
      gradientColor2: Color(0xFFFFFEFF),
    ),
    const BankAccount(
      name: 'OPay',
      logoAsset: Assets.bankOpay,
      gradientColor1: Color(0xFF07B826),
      gradientColor2: Color(0xFF4EE659),
    ),
  ];

  // State variables for ConvertCurrencySheet testing
  String _convertSheetMemo = 'Tactical Technology Grant';
  String _convertSheetAmount = '25,000.00';
  AmountCurrency _convertSheetFromCurrency = AmountCurrency.usd;
  AmountCurrency _convertSheetToCurrency = AmountCurrency.ngn;
  double _convertSheetConvertedAmount = 37500000.00;
  String _convertSheetRecipientName = 'Magic Payma';
  String _convertSheetAccountNumber = '207 922 3313';
  String _convertSheetBankName = 'Chase';
  String _convertSheetBankLogo = Assets.bankOpay;
  double _convertSheetTransactionFee = 500.00;

  // State variables for SendDollarsSheet testing
  String _sendDollarsSheetMemo = '';
  String _sendDollarsSheetAmount = '0.00';
  AmountCurrency _sendDollarsSheetCurrency = AmountCurrency.usd;
  String _sendDollarsSheetAccountNumber = 'Account number...';
  String _sendDollarsSheetRoutingNumber = 'Routing...';
  String _sendDollarsSheetAccountName = 'Account name...';
  String _sendDollarsSheetBankName = 'Bank';
  String _sendDollarsSheetSwiftCode = 'Swift...';
  String _sendDollarsSheetBankAddress = 'Bank Address...';
  String _sendDollarsSheetCountry = 'United States';
  double _sendDollarsSheetUserBalance = 200000.00;
  double _sendDollarsSheetTransactionFee = 0.00;

  // State variables for SummaryNotesSheet testing
  String _summaryNotesAmount = '25,000.00';
  AmountCurrency _summaryNotesFromCurrency = AmountCurrency.usd;
  AmountCurrency _summaryNotesToCurrency = AmountCurrency.ngn;
  double _summaryNotesConvertedAmount = 37500000.00;
  String _summaryNotesRecipientName = 'Magic Payma';
  double _summaryNotesUserBalance = 25000000.00;
  double _summaryNotesTransactionFee = 0.0012;
  double _summaryNotesExchangeRate = 1490.00;

  static const _sections = <_Section>[
    _Section('Auth & onboarding', [
      _Item('Splash', Routes.splash),
      _Item('Welcome intro', Routes.welcomeIntro),
      _Item('Onboarding (CashDrop/Live Life/Pay Suppliers)', Routes.onboarding),
      _Item('Register (Welcome Home — phone)', Routes.register),
      _Item('Verify Startkey', Routes.verifyStartkey),
      _Item('Create / Confirm Passcode', Routes.createPin),
      _Item('Welcome (Hello Magic)', Routes.welcome),
    ]),
    _Section('Identity / KYC', [
      _Item('Face-scan identity', Routes.identityVerification),
      _Item('Add Photo ID', Routes.photoId),
      _Item('Verify NIN', Routes.verifyNin),
      _Item('Add BVN', Routes.addBvn),
      _Item('Verify BVN', Routes.verifyBvn),
      _Item('Photo ID Guide', Routes.photoIdGuide),
    ]),
    _Section('Home & dashboard', [
      _Item('Dashboard (Home)', Routes.dashboard),
      _Item('Wallet detail (View balance)', Routes.wallet),
      _Item('Wallet widget (For everything you do)', Routes.walletWidget),
      _Item('Add Money', Routes.addMoney),
    ]),
    _Section('Transfa AI / Send flow', [
      _Item('Recents / Transfa AI', Routes.transfaAi),
      _Item('Amount keypad', Routes.amount),
      _Item('Recipient picker (search/recents/contacts)', Routes.recipientPick),
      _Item('Choose a Bank', Routes.chooseBank),
      _Item('Choose a Country', Routes.chooseCountry),
      _Item('Receipt — Universal Income', Routes.receiptUniversal),
      _Item('Receipt — Status (money sent)', Routes.receiptStatus),
      _Item('Receipt — Naira received', Routes.receiptReceived),
      _Item('Receipt — Unable to Send', Routes.receiptUnable),
      _Item('Receipt — In Review', Routes.receiptInReview),
      _Item('Receipt — Received from company', Routes.receiptReceivedCompany),
      _Item(
        'Receipt — Universal/Naira received',
        Routes.receiptUniversalReceived,
      ),
      _Item(
        'Receipt — Universal/Processing',
        Routes.receiptUniversalProcessing,
      ),
    ]),
    _Section('Support', [
      _Item('Live chat', Routes.supportChat),
      _Item('Memo (lockscreen chat)', Routes.memoChat),
      _Item('Notifications center', Routes.notifications),
    ]),
    _Section('Unlock & recovery', [
      _Item('Face Shot unlock', Routes.faceShotUnlock),
      _Item(
        'Welcome Home (phone unlock — returning users)',
        Routes.welcomeHomePhone,
      ),
      _Item('Unlock with Passcode', Routes.unlockPasscode),
      _Item('Pay with Passcode', Routes.payPasscode),
      _Item('Security Lockout', Routes.securityLockout),
      _Item('Forgot Passcode', Routes.forgotPasscode),
      _Item('Recovery Startkey', Routes.recoveryStartkey),
    ]),
    _Section('Settings', [
      _Item('Settings (root)', Routes.settings),
      _Item('Profile', Routes.profile),
      _Item('Privacy (toggles)', Routes.privacy),
      _Item('Security (Face ID, passcode)', Routes.security),
      _Item('Money Limits (Captain tier)', Routes.limits),
      _Item('Privacy policy', Routes.privacyPolicy),
      _Item('Legal & regulation', Routes.legal),
    ]),
  ];

  void _showBottomSheet(Widget bottomSheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      builder: (context) => bottomSheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Dev menu',
          style: AppTypography.heading.copyWith(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${kReleaseMode ? "release" : "debug"} build',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: _sections.length + 2,
        itemBuilder: (_, index) {
          if (index == 1) {
            return _BottomSheetTestSection(
              paySheetMemo: _paySheetMemo,
              paySheetAmount: _paySheetAmount,
              paySheetCurrency: _paySheetCurrency,
              onPaySheetMemoChanged: (value) {
                setState(() {
                  _paySheetMemo = value;
                });
              },
              insufficientSheetMemo: _insufficientSheetMemo,
              insufficientSheetAmount: _insufficientSheetAmount,
              insufficientSheetCurrency: _insufficientSheetCurrency,
              insufficientSheetRecipientName: _insufficientSheetRecipientName,
              insufficientSheetAccountNumber: _insufficientSheetAccountNumber,
              insufficientSheetBankName: _insufficientSheetBankName,
              insufficientSheetBankLogo: _insufficientSheetBankLogo,
              insufficientSheetTransactionFee: _insufficientSheetTransactionFee,
              insufficientSheetStampDuty: _insufficientSheetStampDuty,
              onInsufficientSheetMemoChanged: (value) {
                setState(() {
                  _insufficientSheetMemo = value;
                });
              },
              dollarSheetMemo: _dollarSheetMemo,
              dollarSheetAmount: _dollarSheetAmount,
              dollarSheetCurrency: _dollarSheetCurrency,
              dollarSheetRecipientName: _dollarSheetRecipientName,
              dollarSheetAccountNumber: _dollarSheetAccountNumber,
              dollarSheetBankName: _dollarSheetBankName,
              dollarSheetBankLogo: _dollarSheetBankLogo,
              dollarSheetTransactionFee: _dollarSheetTransactionFee,
              dollarSheetDisputeProtection: _dollarSheetDisputeProtection,
              onDollarSheetMemoChanged: (value) {
                setState(() {
                  _dollarSheetMemo = value;
                });
              },
              multipleAccountsMemo: _multipleAccountsMemo,
              multipleAccountsAmount: _multipleAccountsAmount,
              multipleAccountsCurrency: _multipleAccountsCurrency,
              multipleAccountsRecipientName: _multipleAccountsRecipientName,
              multipleAccountsBanks: _multipleAccountsBanks,
              onMultipleAccountsMemoChanged: (value) {
                setState(() {
                  _multipleAccountsMemo = value;
                });
              },
              convertSheetMemo: _convertSheetMemo,
              convertSheetAmount: _convertSheetAmount,
              convertSheetFromCurrency: _convertSheetFromCurrency,
              convertSheetToCurrency: _convertSheetToCurrency,
              convertSheetConvertedAmount: _convertSheetConvertedAmount,
              convertSheetRecipientName: _convertSheetRecipientName,
              convertSheetAccountNumber: _convertSheetAccountNumber,
              convertSheetBankName: _convertSheetBankName,
              convertSheetBankLogo: _convertSheetBankLogo,
              convertSheetTransactionFee: _convertSheetTransactionFee,
              onConvertSheetMemoChanged: (value) {
                setState(() {
                  _convertSheetMemo = value;
                });
              },
              onConvertSheetSwapCurrency: () {
                setState(() {
                  final temp = _convertSheetFromCurrency;
                  _convertSheetFromCurrency = _convertSheetToCurrency;
                  _convertSheetToCurrency = temp;
                  final tempAmount = _convertSheetAmount;
                  _convertSheetAmount = _convertSheetConvertedAmount.toStringAsFixed(2);
                  _convertSheetConvertedAmount = double.parse(tempAmount.replaceAll(',', ''));
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Currency swapped!')),
                );
              },
              onConvertSheetSummaryNotes: () {
                _showBottomSheet(
                  SummaryNotesSheet(
                    amount: _convertSheetAmount,
                    fromCurrency: _convertSheetFromCurrency,
                    toCurrency: _convertSheetToCurrency,
                    convertedAmount: _convertSheetConvertedAmount,
                    recipientName: _convertSheetRecipientName,
                    userBalance: _summaryNotesUserBalance,
                    transactionFee: _summaryNotesTransactionFee,
                    exchangeRate: _summaryNotesExchangeRate,
                    onSwapCurrency: () {
                      setState(() {
                        final temp = _convertSheetFromCurrency;
                        _convertSheetFromCurrency = _convertSheetToCurrency;
                        _convertSheetToCurrency = temp;
                        final tempAmount = _convertSheetAmount;
                        _convertSheetAmount = _convertSheetConvertedAmount.toStringAsFixed(2);
                        _convertSheetConvertedAmount = double.parse(tempAmount.replaceAll(',', ''));
                      });
                      Navigator.pop(context);
                    },
                    onDone: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              sendDollarsSheetMemo: _sendDollarsSheetMemo,
              sendDollarsSheetAmount: _sendDollarsSheetAmount,
              sendDollarsSheetCurrency: _sendDollarsSheetCurrency,
              sendDollarsSheetAccountNumber: _sendDollarsSheetAccountNumber,
              sendDollarsSheetRoutingNumber: _sendDollarsSheetRoutingNumber,
              sendDollarsSheetAccountName: _sendDollarsSheetAccountName,
              sendDollarsSheetBankName: _sendDollarsSheetBankName,
              sendDollarsSheetSwiftCode: _sendDollarsSheetSwiftCode,
              sendDollarsSheetBankAddress: _sendDollarsSheetBankAddress,
              sendDollarsSheetCountry: _sendDollarsSheetCountry,
              sendDollarsSheetUserBalance: _sendDollarsSheetUserBalance,
              sendDollarsSheetTransactionFee: _sendDollarsSheetTransactionFee,
              onSendDollarsSheetMemoChanged: (value) {
                setState(() {
                  _sendDollarsSheetMemo = value;
                });
              },
              onSendDollarsSheetRoutingInfo: (value) {
                setState(() {
                  _sendDollarsSheetRoutingNumber = value;
                });
              },
              onSendDollarsSheetSwiftInfo: (value) {
                setState(() {
                  _sendDollarsSheetSwiftCode = value;
                });
              },
              summaryNotesAmount: _summaryNotesAmount,
              summaryNotesFromCurrency: _summaryNotesFromCurrency,
              summaryNotesToCurrency: _summaryNotesToCurrency,
              summaryNotesConvertedAmount: _summaryNotesConvertedAmount,
              summaryNotesRecipientName: _summaryNotesRecipientName,
              summaryNotesUserBalance: _summaryNotesUserBalance,
              summaryNotesTransactionFee: _summaryNotesTransactionFee,
              summaryNotesExchangeRate: _summaryNotesExchangeRate,
              onSummaryNotesSwapCurrency: () {
                setState(() {
                  final temp = _summaryNotesFromCurrency;
                  _summaryNotesFromCurrency = _summaryNotesToCurrency;
                  _summaryNotesToCurrency = temp;
                  final tempAmount = _summaryNotesAmount;
                  _summaryNotesAmount = _summaryNotesConvertedAmount.toStringAsFixed(2);
                  _summaryNotesConvertedAmount = double.parse(tempAmount.replaceAll(',', ''));
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Currency swapped!')),
                );
              },
              onSummaryNotesDone: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Summary notes closed')),
                );
              },
            );
          }

          if (index == 3) {
            return const _PopupTestSection();
          }

          int sectionIndex = index;
          if (index > 1) sectionIndex--;
          if (index > 3) sectionIndex--;

          if (sectionIndex >= _sections.length) return const SizedBox.shrink();

          final section = _sections[sectionIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                child: Text(
                  section.title.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < section.items.length; i++) ...[
                      _Row(item: section.items[i]),
                      if (i < section.items.length - 1)
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Color(0xFFEEEEEE),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Section for testing bottom sheets
class _BottomSheetTestSection extends StatelessWidget {
  final String paySheetMemo;
  final String paySheetAmount;
  final AmountCurrency paySheetCurrency;
  final Function(String) onPaySheetMemoChanged;

  final String insufficientSheetMemo;
  final String insufficientSheetAmount;
  final AmountCurrency insufficientSheetCurrency;
  final String insufficientSheetRecipientName;
  final String insufficientSheetAccountNumber;
  final String insufficientSheetBankName;
  final String insufficientSheetBankLogo;
  final double insufficientSheetTransactionFee;
  final double insufficientSheetStampDuty;
  final Function(String) onInsufficientSheetMemoChanged;

  final String dollarSheetMemo;
  final String dollarSheetAmount;
  final AmountCurrency dollarSheetCurrency;
  final String dollarSheetRecipientName;
  final String dollarSheetAccountNumber;
  final String dollarSheetBankName;
  final String dollarSheetBankLogo;
  final double dollarSheetTransactionFee;
  final double dollarSheetDisputeProtection;
  final Function(String) onDollarSheetMemoChanged;

  final String multipleAccountsMemo;
  final String multipleAccountsAmount;
  final AmountCurrency multipleAccountsCurrency;
  final String multipleAccountsRecipientName;
  final List<BankAccount> multipleAccountsBanks;
  final Function(String) onMultipleAccountsMemoChanged;

  final String convertSheetMemo;
  final String convertSheetAmount;
  final AmountCurrency convertSheetFromCurrency;
  final AmountCurrency convertSheetToCurrency;
  final double convertSheetConvertedAmount;
  final String convertSheetRecipientName;
  final String convertSheetAccountNumber;
  final String convertSheetBankName;
  final String convertSheetBankLogo;
  final double convertSheetTransactionFee;
  final Function(String) onConvertSheetMemoChanged;
  final VoidCallback onConvertSheetSwapCurrency;
  final VoidCallback onConvertSheetSummaryNotes;

  final String sendDollarsSheetMemo;
  final String sendDollarsSheetAmount;
  final AmountCurrency sendDollarsSheetCurrency;
  final String sendDollarsSheetAccountNumber;
  final String sendDollarsSheetRoutingNumber;
  final String sendDollarsSheetAccountName;
  final String sendDollarsSheetBankName;
  final String sendDollarsSheetSwiftCode;
  final String sendDollarsSheetBankAddress;
  final String sendDollarsSheetCountry;
  final double sendDollarsSheetUserBalance;
  final double sendDollarsSheetTransactionFee;
  final Function(String) onSendDollarsSheetMemoChanged;
  final Function(String) onSendDollarsSheetRoutingInfo;
  final Function(String) onSendDollarsSheetSwiftInfo;

  final String summaryNotesAmount;
  final AmountCurrency summaryNotesFromCurrency;
  final AmountCurrency summaryNotesToCurrency;
  final double summaryNotesConvertedAmount;
  final String summaryNotesRecipientName;
  final double summaryNotesUserBalance;
  final double summaryNotesTransactionFee;
  final double summaryNotesExchangeRate;
  final VoidCallback onSummaryNotesSwapCurrency;
  final VoidCallback onSummaryNotesDone;

  const _BottomSheetTestSection({
    required this.paySheetMemo,
    required this.paySheetAmount,
    required this.paySheetCurrency,
    required this.onPaySheetMemoChanged,
    required this.insufficientSheetMemo,
    required this.insufficientSheetAmount,
    required this.insufficientSheetCurrency,
    required this.insufficientSheetRecipientName,
    required this.insufficientSheetAccountNumber,
    required this.insufficientSheetBankName,
    required this.insufficientSheetBankLogo,
    required this.insufficientSheetTransactionFee,
    required this.insufficientSheetStampDuty,
    required this.onInsufficientSheetMemoChanged,
    required this.dollarSheetMemo,
    required this.dollarSheetAmount,
    required this.dollarSheetCurrency,
    required this.dollarSheetRecipientName,
    required this.dollarSheetAccountNumber,
    required this.dollarSheetBankName,
    required this.dollarSheetBankLogo,
    required this.dollarSheetTransactionFee,
    required this.dollarSheetDisputeProtection,
    required this.onDollarSheetMemoChanged,
    required this.multipleAccountsMemo,
    required this.multipleAccountsAmount,
    required this.multipleAccountsCurrency,
    required this.multipleAccountsRecipientName,
    required this.multipleAccountsBanks,
    required this.onMultipleAccountsMemoChanged,
    required this.convertSheetMemo,
    required this.convertSheetAmount,
    required this.convertSheetFromCurrency,
    required this.convertSheetToCurrency,
    required this.convertSheetConvertedAmount,
    required this.convertSheetRecipientName,
    required this.convertSheetAccountNumber,
    required this.convertSheetBankName,
    required this.convertSheetBankLogo,
    required this.convertSheetTransactionFee,
    required this.onConvertSheetMemoChanged,
    required this.onConvertSheetSwapCurrency,
    required this.onConvertSheetSummaryNotes,
    required this.sendDollarsSheetMemo,
    required this.sendDollarsSheetAmount,
    required this.sendDollarsSheetCurrency,
    required this.sendDollarsSheetAccountNumber,
    required this.sendDollarsSheetRoutingNumber,
    required this.sendDollarsSheetAccountName,
    required this.sendDollarsSheetBankName,
    required this.sendDollarsSheetSwiftCode,
    required this.sendDollarsSheetBankAddress,
    required this.sendDollarsSheetCountry,
    required this.sendDollarsSheetUserBalance,
    required this.sendDollarsSheetTransactionFee,
    required this.onSendDollarsSheetMemoChanged,
    required this.onSendDollarsSheetRoutingInfo,
    required this.onSendDollarsSheetSwiftInfo,
    required this.summaryNotesAmount,
    required this.summaryNotesFromCurrency,
    required this.summaryNotesToCurrency,
    required this.summaryNotesConvertedAmount,
    required this.summaryNotesRecipientName,
    required this.summaryNotesUserBalance,
    required this.summaryNotesTransactionFee,
    required this.summaryNotesExchangeRate,
    required this.onSummaryNotesSwapCurrency,
    required this.onSummaryNotesDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
          child: Text(
            'BOTTOM SHEETS (MODAL)',
            style: AppTypography.caption.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Pay Sheet Item
              _BottomSheetRow(
                label: 'Pay Sheet (NGN)',
                description: 'Standard payment bottom sheet - Naira',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                    ),
                    builder: (context) => PaySheet(
                      amount: paySheetAmount,
                      currency: paySheetCurrency,
                      memo: paySheetMemo,
                      onMemoChanged: (newMemo) {
                        onPaySheetMemoChanged(newMemo);
                      },
                    ),
                  );
                },
              ),
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Color(0xFFEEEEEE),
              ),
              // Insufficient Money Sheet Item
              _BottomSheetRow(
                label: 'Insufficient Money Sheet (NGN)',
                description: 'Shown when NGN balance is too low',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                    ),
                    builder: (context) => InsufficientMoneySheet(
                      disputeProtection: 0.00,
                      amount: insufficientSheetAmount,
                      currency: insufficientSheetCurrency,
                      memo: insufficientSheetMemo,
                      recipientName: insufficientSheetRecipientName,
                      accountNumber: insufficientSheetAccountNumber,
                      bankName: insufficientSheetBankName,
                      bankLogoAsset: insufficientSheetBankLogo,
                      transactionFee: insufficientSheetTransactionFee,
                      stampDuty: insufficientSheetStampDuty,
                      onMemoChanged: (newMemo) {
                        onInsufficientSheetMemoChanged(newMemo);
                      },
                    ),
                  );
                },
              ),
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Color(0xFFEEEEEE),
              ),
              // Dollar Account Sheet Item
              _BottomSheetRow(
                label: 'Dollar Account Sheet (USD)',
                description: 'Shown for USD transactions with dispute protection',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                    ),
                    builder: (context) => DollarAccountSheet(
                      amount: dollarSheetAmount,
                      currency: dollarSheetCurrency,
                      memo: dollarSheetMemo,
                      recipientName: dollarSheetRecipientName,
                      accountNumber: dollarSheetAccountNumber,
                      bankName: dollarSheetBankName,
                      bankLogoAsset: dollarSheetBankLogo,
                      transactionFee: dollarSheetTransactionFee,
                      disputeProtection: dollarSheetDisputeProtection,
                      onMemoChanged: (newMemo) {
                        onDollarSheetMemoChanged(newMemo);
                      },
                    ),
                  );
                },
              ),
              
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Color(0xFFEEEEEE),
              ),
              // Convert Currency Sheet Item
              _BottomSheetRow(
                label: 'Convert Currency Sheet (USD → NGN)',
                description: 'Shows currency conversion between USD and NGN',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                    ),
                    builder: (context) => ConvertCurrencySheet(
                      amount: convertSheetAmount,
                      fromCurrency: convertSheetFromCurrency,
                      toCurrency: convertSheetToCurrency,
                      convertedAmount: convertSheetConvertedAmount,
                      memo: convertSheetMemo,
                      recipientName: convertSheetRecipientName,
                      accountNumber: convertSheetAccountNumber,
                      bankName: convertSheetBankName,
                      bankLogoAsset: convertSheetBankLogo,
                      transactionFee: convertSheetTransactionFee,
                      onMemoChanged: (newMemo) {
                        onConvertSheetMemoChanged(newMemo);
                      },
                      onSwapCurrency: onConvertSheetSwapCurrency,
                      onSummaryNotes: onConvertSheetSummaryNotes,
                    ),
                  );
                },
              ),
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Color(0xFFEEEEEE),
              ),
              // Send Dollars Sheet Item
              _BottomSheetRow(
                label: 'Send Dollars Sheet (USD)',
                description: 'International USD transfer with routing and SWIFT',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                    ),
                    builder: (context) => SendDollarsSheet(
                      amount: sendDollarsSheetAmount,
                      currency: sendDollarsSheetCurrency,
                      memo: sendDollarsSheetMemo,
                      accountNumber: sendDollarsSheetAccountNumber,
                      routingNumber: sendDollarsSheetRoutingNumber,
                      accountName: sendDollarsSheetAccountName,
                      bankName: sendDollarsSheetBankName,
                      swiftCode: sendDollarsSheetSwiftCode,
                      bankAddress: sendDollarsSheetBankAddress,
                      country: sendDollarsSheetCountry,
                      userBalance: sendDollarsSheetUserBalance,
                      transactionFee: sendDollarsSheetTransactionFee,
                      onMemoChanged: (newMemo) {
                        onSendDollarsSheetMemoChanged(newMemo);
                      },
                      onRoutingInfo: onSendDollarsSheetRoutingInfo,
                      onSwiftInfo: onSendDollarsSheetSwiftInfo,
                    ),
                  );
                },
              ),
              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: Color(0xFFEEEEEE),
              ),
              // Summary Notes Sheet Item
              _BottomSheetRow(
                label: 'Summary Notes Sheet',
                description: 'Shows detailed transaction summary with exchange rates',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                    ),
                    builder: (context) => SummaryNotesSheet(
                      amount: summaryNotesAmount,
                      fromCurrency: summaryNotesFromCurrency,
                      toCurrency: summaryNotesToCurrency,
                      convertedAmount: summaryNotesConvertedAmount,
                      recipientName: summaryNotesRecipientName,
                      userBalance: summaryNotesUserBalance,
                      transactionFee: summaryNotesTransactionFee,
                      exchangeRate: summaryNotesExchangeRate,
                      onSwapCurrency: onSummaryNotesSwapCurrency,
                      onDone: onSummaryNotesDone,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomSheetRow extends StatelessWidget {
  final String label;
  final String description;
  final VoidCallback onTap;

  const _BottomSheetRow({
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.body.copyWith(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.link, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Section for testing all popups
class _PopupTestSection extends StatelessWidget {
  const _PopupTestSection();

  void _showPopup(BuildContext context, Widget popup) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      useSafeArea: true,
      builder: (context) => popup,
    );
  }

  @override
  Widget build(BuildContext context) {
    const popupItems = [
      _PopupItem('Stamp Duty Popup', StampDutyPopup()),
      _PopupItem('Swift Code Info Popup', SwiftCodeInfoPopup()),
      _PopupItem('Insufficient Money Popup', InsufficientMoneyPopup()),
      _PopupItem('Business Banking Popup', BusinessBankingPopup()),
      _PopupItem('Transfa Account Preview Popup', TransfaAccountPreviewPopup()),
      _PopupItem('Personal Banking Popup', PersonalBankingPopup()),
      _PopupItem('Choose Bank Popup', ChooseBankPopup()),
      _PopupItem(
        'Transfa Status Popup',
        TransfaStatusPopup(
          businessName: "Uptown",
          bankName: "Uptown",
          accountNumber: "207 922 3313",
          amount: 277500,
          description: "Jewelry",
        ),
      ),
      _PopupItem(
        'Transfa Status Progress Popup',
        TransfaStatusProgressPopup(
          accountName: "Amadioha",
          bankName: "Uptown",
          accountNumber: "207 922 3313",
          amount: 277500,
          description: "Goof",
        ),
      ),
      _PopupItem(
        'Transfa Status Unavailable Popup',
        TransfaStatusUnavailablePopup(
          accountName: "Amadioha",
          bankName: "Uptown",
          accountNumber: "207 922 3313",
          amount: 36000,
          description: "April Salary",
        ),
      ),
      _PopupItem('Transfa Bank Privacy Popup', TransfaBankPrivacyPopup()),
      _PopupItem('Transfa ID Privacy Popup', TransfaIDPrivacyPopup()),
      _PopupItem('Currency Popup', CurrencyPopup()),
      _PopupItem('NO Internet Popup', NoInternetPopup()),
      _PopupItem('Multiple Banks Popup', MultipleBanksPopup()),
      _PopupItem('Bank Unavailable', BankUnavailablePopup(bankName: "Wema")),
      // _PopupItem(
      //   'Transfa Account Found Popup',
      //   TransfaAccountFoundPopup(
      //     userName: "Magic Paygma",
      //     userImageUrl: Assets.magic,
      //   ),
      // ),
      _PopupItem(
        'Transfa Done Popup',
        TransfaDonePopup(userName: "Magic Paygma", userImageUrl: Assets.magic),
      ),
      _PopupItem('Check Your Number Popup', CheckYourNumberPopup()),
      _PopupItem('Enter Correct Code Popup', EnterCorrectCodePopup()),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
          child: Text(
            'POPUP TESTS (INTEGRATION)',
            style: AppTypography.caption.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < popupItems.length; i++) ...[
                _PopupRow(
                  item: popupItems[i],
                  onTap: () => _showPopup(context, popupItems[i].popup),
                ),
                if (i < popupItems.length - 1)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Color(0xFFEEEEEE),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PopupItem {
  final String label;
  final Widget popup;
  const _PopupItem(this.label, this.popup);
}

class _PopupRow extends StatelessWidget {
  final _PopupItem item;
  final VoidCallback onTap;

  const _PopupRow({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: AppTypography.body.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to show popup',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.open_in_new_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section {
  final String title;
  final List<_Item> items;
  const _Section(this.title, this.items);
}

class _Item {
  final String label;
  final String route;
  const _Item(this.label, this.route);
}

class _Row extends StatelessWidget {
  final _Item item;
  const _Row({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(item.route),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: AppTypography.body.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.route,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}