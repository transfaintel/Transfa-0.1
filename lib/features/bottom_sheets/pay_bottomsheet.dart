import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../features/pop-ups/multiple_banks_popup.dart';
import '../../../features/pop-ups/single_bank_popup.dart';
import '../../../shared/widgets/transfa_logo.dart';
import '../../../data/mock_api/currency.dart';


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
  String _selectedAccountNumber = '';
  String _selectedBank = '';

  // Mock data - replace with actual API calls
  final double _userBalance = 50000000.00;
  final double _transactionFee = 1000.00;

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
    // Check if account number is connected to multiple banks
    // This is mock logic - replace with actual API call
    final bool hasMultipleBanks = false;

    if (hasMultipleBanks) {
      // Show multiple banks found popup
      _showMultipleBanksPopup();
    } else  {
      // Show single account found popup
      _showSingleAccountFoundPopup();
    }
  }

  void _showSingleAccountFoundPopup() {
    Navigator.of(context).pop(); // Close pay sheet first
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => const SingleAccountFoundPopup(),
    );
  }

  void _showMultipleBanksPopup() {
    Navigator.of(context).pop(); // Close pay sheet first
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => const MultipleBanksPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620,
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
                // Fixed Header (doesn't scroll)
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
                          onTap: () => context.push(Routes.recipientPick),
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
                                  child: SvgPicture.asset(
                                    Assets.contacts,
                                    width: 26,
                                    height: 26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Bank Center Field
                        GestureDetector(
                          onTap: () => context.push(Routes.chooseBank),
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
                                  child: SvgPicture.asset(
                                    Assets.bank,
                                    width: 14,
                                    height: 14,
                                  ),
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

                        // Memo Field - Now an input field
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
                                    hintText: 'What\'s the money for?',
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
                              // Transaction Fee
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
                              // Total
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
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(35),
                            ),
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
