import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/transfa_logo.dart';
import '../../../data/mock_api/currency.dart';
import '../../features/bottom_sheets/multipleAccountsSheet.dart';
import '../../features/bottom_sheets/singleAccountSheet.dart';

// ============================================================
// PAY SHEET BOTTOM SHEET
// ============================================================

class PaySheet extends StatefulWidget {
  final String amount;
  final AmountCurrency currency;
  final String memo;
  final Function(String) onMemoChanged;

  const PaySheet({
    super.key,
    required this.amount,
    required this.currency,
    required this.memo,
    required this.onMemoChanged,
  });

  @override
  State<PaySheet> createState() => _PaySheetState();
}

class _PaySheetState extends State<PaySheet> {
  final TextEditingController _memoController = TextEditingController();

  // Selected recipient data - updated from navigation
  String _selectedAccountNumber = '';
  String _selectedBank = '';
  String _selectedBankLogo = '';
  Color? _selectedBankGradient1;
  Color? _selectedBankGradient2;
  String _selectedRecipientName = '';
  String? _selectedRecipientImage;
  String _selectedAccountNumberDisplay = '';

  // Mock data - replace with actual API calls
  final double _userBalance = 50000000.00;
  final double _transactionFee = 1000.00;

  // Default recipient data (fallback)
  final String _defaultRecipientName = 'Magic Payma';
  final String _defaultAccountNumber = '207 922 3313';
  final String _defaultBankName = 'OPay';
  final String? _defaultRecipientImage = Assets.magic;

  // Mock bank accounts for multiple banks scenario
  final List<BankAccount> _mockBankAccounts = [
    const BankAccount(
      name: 'Transfa',
      logoAsset: Assets.logoSmallWhite,
      gradientColor1: Color(0xFF000000),
      gradientColor2: Color(0xFF000000),
    ),
    const BankAccount(
      name: 'FCMB',
      logoAsset: Assets.bankfcmbRound,
      gradientColor1: Color(0xFF5C2684),
      gradientColor2: Color(0xFF5C2684),
    ),
    const BankAccount(
      name: 'OPay',
      logoAsset: Assets.bankOpay,
      gradientColor1: Color(0xFFFFFFFF),
      gradientColor2: Color(0xFFFFFFFF),
    ),
  ];

  // Getters for current values
  String get _currentRecipientName => _selectedRecipientName.isNotEmpty
      ? _selectedRecipientName
      : _defaultRecipientName;

  String get _currentAccountNumber => _selectedAccountNumber.isNotEmpty
      ? _selectedAccountNumber
      : _defaultAccountNumber;

  String get _currentBankName =>
      _selectedBank.isNotEmpty ? _selectedBank : _defaultBankName;

  String get _currentRecipientImage =>
      _selectedRecipientImage ?? _defaultRecipientImage!;

  // Get the appropriate icon for the account number field
  Widget _getAccountIcon() {
    if (_selectedRecipientImage != null &&
        _selectedRecipientImage!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Image.asset(
          _selectedRecipientImage!,
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return SvgPicture.asset(Assets.contacts, width: 26, height: 26);
    }
  }

  // Helper to get bank initials
  String _getBankInitials(String bankName) {
    // Handle special cases
    if (bankName.toLowerCase() == 'access bank') return 'AB';
    if (bankName.toLowerCase() == 'first bank') return 'FB';
    if (bankName.toLowerCase() == 'zenith bank') return 'ZB';
    if (bankName.toLowerCase() == 'union bank') return 'UB';
    if (bankName.toLowerCase() == 'stanbic ibtc') return 'SI';

    // For other banks, get first letter or first two letters
    final words = bankName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return bankName.substring(0, 1).toUpperCase();
  }

  // Get bank gradient colors based on bank name
  (Color?, Color?) _getBankGradientsForName(String bankName) {
    switch (bankName.toLowerCase()) {
      case 'opay':
        return (const Color(0xFFFFFFFF), const Color(0xFFFFFFFF));
      case 'fcmb':
        return (const Color(0xFF5C2684), const Color(0xFF5C2684));
      case 'chase':
        return (const Color(0xFFFFFFFF), const Color(0xFFFFFFFF));
      case 'gtbank':
        return (const Color(0xFFE85A1F), const Color(0xFFE85A1F));
      case 'access bank':
        return (const Color(0xFFEF3E33), const Color(0xFFEF3E33));
      case 'first bank':
        return (const Color(0xFF003B71), const Color(0xFF003B71));
      case 'zenith bank':
        return (const Color(0xFFE60012), const Color(0xFFE60012));
      case 'uba':
        return (const Color(0xFFCC0000), const Color(0xFFCC0000));
      case 'kuda':
        return (const Color(0xFF40196D), const Color(0xFF40196D));
      case 'wema bank':
        return (const Color(0xFF6F2C91), const Color(0xFF6F2C91));
      case 'sterling bank':
        return (const Color(0xFFD8232A), const Color(0xFFD8232A));
      case 'palmpay':
        return (const Color(0xFF6238FB), const Color(0xFF6238FB));
      case 'moneypoint':
        return (const Color(0xFF0357EE), const Color(0xFF0357EE));
      case 'stanbic ibtc':
        return (const Color(0xFF0033A0), const Color(0xFF0033A0));
      case 'union bank':
        return (const Color(0xFF003E7E), const Color(0xFF003E7E));
      default:
        return (null, null);
    }
  }

  // Get the appropriate icon for the bank field
  Widget _getBankIcon() {
    if (_selectedBank.isNotEmpty) {
      // Check if we have a logo asset
      if (_selectedBankLogo.isNotEmpty) {
        // Check if the logo is an SVG
        if (_selectedBankLogo.contains('.svg')) {
          return SvgPicture.asset(_selectedBankLogo, width: 22, height: 22);
        } else {
          // For PNG images - use Image.asset with fit
          return Image.asset(
            _selectedBankLogo,
            width: 22,
            height: 22,
            fit: BoxFit.contain,
          );
        }
      } else {
        // If no logo asset, show initials with gradient
        final initials = _getBankInitials(_selectedBank);
        final gradients = _getBankGradientsForName(_selectedBank);
        final color1 = gradients.$1 ?? const Color(0xFF07B826);
        final color2 = gradients.$2 ?? const Color(0xFF4EE659);

        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color1, color2],
            ),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    }
    // Default: show default bank icon with green gradient
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF07B826), Color(0xFF4EE659)],
        ),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        Assets.bank,
        width: 12,
        height: 12,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }

  // Get bank logo for display - returns the asset path
  String _getBankLogoAsset(String bankName) {
    if (_selectedBankLogo.isNotEmpty) return _selectedBankLogo;
    switch (bankName.toLowerCase()) {
      case 'opay':
        return Assets.bankOpay;
      case 'gtbank':
        return Assets.bankchase;
      case 'access bank':
        return Assets.bankBlack;
      case 'fcmb':
        return Assets.bankFcmb;
      case 'transfa':
        return Assets.logoSmallWhite;
      case 'chase':
        return Assets.bankchase;
      default:
        return '';
    }
  }

  Color? _getBankGradient1(String bankName) {
    if (_selectedBankGradient1 != null) return _selectedBankGradient1;
    switch (bankName.toLowerCase()) {
      case 'opay':
        return const Color(0xFFFFFFFF);
      case 'transfa':
        return const Color(0xFF000000);
      case 'fcmb':
        return const Color(0xFF5C2684);
      case 'chase':
        return const Color(0xFFFFFFFF);
      case 'gtbank':
        return const Color(0xFFE85A1F);
      case 'access bank':
        return const Color(0xFFEF3E33);
      default:
        return null;
    }
  }

  Color? _getBankGradient2(String bankName) {
    if (_selectedBankGradient2 != null) return _selectedBankGradient2;
    switch (bankName.toLowerCase()) {
      case 'opay':
        return const Color(0xFFFFFFFF);
      case 'transfa':
        return const Color(0xFF000000);
      case 'fcmb':
        return const Color(0xFF5C2684);
      case 'chase':
        return const Color(0xFFFFFFFF);
      case 'gtbank':
        return const Color(0xFFE85A1F);
      case 'access bank':
        return const Color(0xFFEF3E33);
      default:
        return null;
    }
  }

  double get _totalAmount {
    final amount = double.tryParse(widget.amount.replaceAll(',', '')) ?? 0;
    return amount + _transactionFee;
  }

  @override
  void initState() {
    super.initState();
    _memoController.text = widget.memo;
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _onMemoChanged(String value) {
    widget.onMemoChanged(value);
  }

  void _onTouchToConfirm() {
    final bool hasMultipleBanks = true;
    if (hasMultipleBanks) {
      _showMultipleBanksPopup();
    } else {
      _showSingleAccountFoundPopup();
    }
  }

  void _showSingleAccountFoundPopup() {
    Navigator.of(context).pop();

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
      builder: (context) => SingleAccountSheet(
        recipientName: _currentRecipientName,
        currencySymbol: widget.currency.symbol,
        amount: widget.amount,
        memo: widget.memo,
        accountNumber: _currentAccountNumber,
        bankName: _currentBankName,
        recipientImageUrl: _currentRecipientImage,
        bankLogoAsset: _getBankLogoAsset(_currentBankName),
        bankGradientColor1: _getBankGradient1(_currentBankName),
        bankGradientColor2: _getBankGradient2(_currentBankName),
        onMemoChanged: (newMemo) {
          widget.onMemoChanged(newMemo);
          _memoController.text = newMemo;
        },
      ),
    );
  }

  void _showMultipleBanksPopup() {
    final banks = [
      const BankAccount(
        name: 'Transfa',
        logoAsset: Assets.logoSmallWhite,
        gradientColor1: Color(0xFF000000),
        gradientColor2: Color(0xFF000000),
      ),
      const BankAccount(
        name: 'FCMB',
        logoAsset: Assets.bankFcmb,
        gradientColor1: Color(0xFF5C2684),
        gradientColor2: Color(0xFF5C2684),
      ),
      const BankAccount(
        name: 'OPay',
        logoAsset: Assets.bankOpay,
        gradientColor1: Color(0xFFFFFFFF),
        gradientColor2: Color(0xFFFFFFFF),
      ),
    ];

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
      builder: (context) => MultipleAccountsSheet(
        recipientName: _currentRecipientName,
        currency: widget.currency,
        amount: widget.amount,
        memo: widget.memo,
        recipientImageUrl: _currentRecipientImage,
        accountNumber: _currentAccountNumber,
        banks: banks,
        onMemoChanged: (newMemo) {
          widget.onMemoChanged(newMemo);
          _memoController.text = newMemo;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height * 0.5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFB).withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                // Fixed Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const TransfaMark(size: 16, white: true),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Transfa',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            letterSpacing: 0.02,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Account Number Field
                        GestureDetector(
                          onTap: () async {
                            final result = await context
                                .push<Map<String, dynamic>>(
                                  Routes.recipientPick,
                                );
                            if (result != null && mounted) {
                              setState(() {
                                _selectedRecipientName = result['name'] ?? '';
                                _selectedAccountNumber =
                                    result['accountNumber'] ?? '';
                                _selectedRecipientImage = result['image'] ?? '';
                              });
                            }
                          },
                          child: Container(
                            height: 62,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCFCFB),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'To:',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                    letterSpacing: 0.02,
                                    color: Color(0xFF8A8A8C),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _selectedAccountNumber.isEmpty
                                        ? 'Account number...'
                                        : _selectedAccountNumber,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      letterSpacing: 0.02,
                                      color: _selectedAccountNumber.isEmpty
                                          ? const Color(0xFF8A8A8C)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF07B826),
                                        Color(0xFF4EE659),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  alignment: Alignment.center,
                                  child: _getAccountIcon(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Bank Center Field
                        GestureDetector(
                          onTap: () async {
                            final result = await context
                                .push<Map<String, dynamic>>(Routes.chooseBank);
                            if (result != null && mounted) {
                              setState(() {
                                _selectedBank = result['name'] ?? '';
                                _selectedBankLogo = result['logo'] ?? '';
                                _selectedBankGradient1 =
                                    result['gradientColor1'];
                                _selectedBankGradient2 =
                                    result['gradientColor2'];
                              });
                            }
                          },
                          child: Container(
                            height: 62,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCFCFB),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    gradient: _selectedBank.isNotEmpty
                                        ? LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              _selectedBankGradient1 ??
                                                  const Color(0xFFFFFFFF),
                                              _selectedBankGradient2 ??
                                                  const Color(0xFFFFFFFF),
                                            ],
                                          )
                                        : const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFF07B826),
                                              Color(0xFF4EE659),
                                            ],
                                          ),
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  alignment: Alignment.center,
                                  child: _getBankIcon(),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _selectedBank.isEmpty
                                        ? 'Bank Center'
                                        : _selectedBank,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      letterSpacing: 0.02,
                                      color: _selectedBank.isEmpty
                                          ? const Color(0xFF8A8A8C)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    Assets.context,
                                    width: 12,
                                    height: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Send Amount Field
                        Container(
                          height: 105,
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Send',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  letterSpacing: 0.02,
                                  color: Color(0xFF8A8A8C),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${widget.currency.symbol}${widget.amount}',
                                      style: AppTypography.displayLarge
                                          .copyWith(
                                            color: Colors.black,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Memo Field
                        Container(
                          height: 62,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                child: SvgPicture.asset(Assets.memo),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _memoController,
                                  onChanged: _onMemoChanged,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                    letterSpacing: 0.02,
                                    color: Colors.black,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Memo: What\'s the money for?',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      letterSpacing: 0.02,
                                      color: Color(0xFF8A8A8C),
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Pay with Field
                        Container(
                          height: 62,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                alignment: Alignment.center,
                                child: const TransfaMark(size: 12, white: true),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${widget.currency.symbol}${_userBalance.toStringAsFixed(2)}',
                                        style: AppTypography.body.copyWith(
                                          color: Colors.grey,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Summary Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Transaction Fee',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17,
                                          letterSpacing: 0.02,
                                          color: Color(0xFF8A8A8C),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${widget.currency.symbol}${_transactionFee.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        letterSpacing: 0.02,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: Color(0xFFF0F0F0),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Total',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          letterSpacing: 0.02,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${widget.currency.symbol}${_totalAmount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        letterSpacing: 0.02,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Pay Bubble - Touch to Confirm
                        GestureDetector(
                          onTap: _onTouchToConfirm,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black.withOpacity(0.3),
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(58),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Touch to Confirm',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                    letterSpacing: 0.02,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
