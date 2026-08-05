import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/assets.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/transfa_logo.dart';
import '../../../data/mock_api/currency.dart';
import '../../features/pop-ups/chooseBank_popup.dart';

// ============================================================
// CONVERT CURRENCY BOTTOM SHEET
// ============================================================

class ConvertCurrencySheet extends StatefulWidget {
  final String amount;
  final AmountCurrency fromCurrency;
  final AmountCurrency toCurrency;
  final double convertedAmount;
  final String memo;
  final String recipientName;
  final String accountNumber;
  final String bankName;
  final String bankLogoAsset;
  final double transactionFee;
  final Function(String) onMemoChanged;
  final VoidCallback onSwapCurrency;
  final VoidCallback onSummaryNotes;

  const ConvertCurrencySheet({
    super.key,
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.convertedAmount,
    required this.memo,
    required this.recipientName,
    required this.accountNumber,
    required this.bankName,
    required this.bankLogoAsset,
    required this.transactionFee,
    required this.onMemoChanged,
    required this.onSwapCurrency,
    required this.onSummaryNotes,
  });

  @override
  State<ConvertCurrencySheet> createState() => _ConvertCurrencySheetState();
}

class _ConvertCurrencySheetState extends State<ConvertCurrencySheet> {
  final TextEditingController _memoController = TextEditingController();

  // Mock user balance
  final double _userBalance = 25000000.00;

  // Bank selection state
  String _selectedBankName = '';
  String _selectedBankLogo = '';
  bool _isBankSelected = false;

  double get _totalAmount {
    final amount = double.tryParse(widget.amount.replaceAll(',', '')) ?? 0;
    return amount + widget.transactionFee;
  }

  String _formatWithCommas(double amount) {
    final formatter = NumberFormat('#,###.##');
    return formatter.format(amount);
  }

  String _getMainAmount(double amount) {
    final formatted = _formatWithCommas(amount);
    if (formatted.contains('.')) {
      return formatted.split('.')[0];
    }
    return formatted;
  }

  String _getDecimalPart(double amount) {
    final formatted = _formatWithCommas(amount);
    if (formatted.contains('.')) {
      return '.${formatted.split('.')[1]}';
    }
    return '.00';
  }

  @override
  void initState() {
    super.initState();
    _memoController.text = widget.memo;
    // Initialize with default bank
    _selectedBankName = widget.bankName;
    _selectedBankLogo = widget.bankLogoAsset;
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _onMemoChanged(String value) {
    widget.onMemoChanged(value);
  }

  void _showBankPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => ChooseBankPopup(
        onTransfaSelected: () {
          setState(() {
            _selectedBankName = 'Transfa';
            _selectedBankLogo = Assets.logoSmallWhite;
            _isBankSelected = true;
          });
        },
        onChaseSelected: () {
          setState(() {
            _selectedBankName = 'Chase';
            _selectedBankLogo = Assets.bankchase;
            _isBankSelected = true;
          });
        },
        onOPaySelected: () {
          setState(() {
            _selectedBankName = 'OPay';
            _selectedBankLogo = Assets.bankOpay;
            _isBankSelected = true;
          });
        },
      ),
    );
  }

  Widget _buildBankLogo(String logoAsset, String bankName) {
    if (bankName == 'Transfa') {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: SvgPicture.asset(logoAsset),
          ),
        ),
      );
    } else if (bankName == 'OPay') {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Center(
          child: Container(
            width: 30,
            height: 30,
            child: Image.asset(logoAsset, fit: BoxFit.contain),
          ),
        ),
      );
    } else {
      // Chase or default
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F5),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Center(
          child: Container(
            width: 26,
            height: 26,
            child: SvgPicture.asset(logoAsset),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double parsedAmount =
        double.tryParse(widget.amount.replaceAll(',', '')) ?? 0;
    final bool isDarkAmount = widget.fromCurrency == AmountCurrency.usd;

    return Container(
      height: (MediaQuery.of(context).size.height * 0.7),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFB).withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(45),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                // Fixed Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                            size: 16,
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
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Face Shot & Name Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Face Shot Avatar
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF00BCF6),
                                      Color(0xFF006EFF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(120),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(120),
                                  child: Image.asset(
                                    Assets.magic,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Recipient Name
                              Text(
                                widget.recipientName,
                                style: const TextStyle(
                                  fontFamily: 'Arial Rounded MT Bold',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 30,
                                  letterSpacing: 0.02,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Selected Bank Field - Now with tap to choose
                        GestureDetector(
                          onTap: _showBankPopup,
                          child: Container(
                            height: 70,
                            padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCFCFB),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Row(
                              children: [
                                // Bank Logo
                                _selectedBankName == "Chase"
                                    ? Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            35,
                                          ),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            child: SvgPicture.asset(
                                              Assets.bankchase,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      )
                                    : _buildBankLogo(
                                        _selectedBankLogo,
                                        _selectedBankName,
                                      ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _selectedBankName,
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      letterSpacing: 0.02,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Transform.rotate(
                                  angle: 3.14159, // 180 degrees
                                  child: SvgPicture.asset(
                                    Assets.context,
                                    width: 12,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFFB3B3B7),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Convert & Send Amount Field
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Send ${widget.recipientName}',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  letterSpacing: 0.02,
                                  color: Color(0xFF8A8A8C),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Swap Currency Button
                                  GestureDetector(
                                    onTap: widget.onSwapCurrency,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: SvgPicture.asset(
                                        Assets.switchCurrency,
                                        width: 16,
                                        height: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Amount Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // From Currency Amount
                                        Row(
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${widget.fromCurrency.symbol}${_getMainAmount(parsedAmount)}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Arial Rounded MT Bold',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 30,
                                                        letterSpacing: 0.02,
                                                        color: isDarkAmount
                                                            ? Colors.black
                                                            : const Color(
                                                                0xFF8A8A8C,
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            widget.fromCurrency ==
                                                    AmountCurrency.usd
                                                ? Container(
                                                    width: 35,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    child: _buildUSDFlag(),
                                                  )
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                          0,
                                                          0,
                                                          10,
                                                          0,
                                                        ),
                                                    child: Container(
                                                      width: 26,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                      child: _buildNGNFlag(),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        // Divider
                                        Container(
                                          height: 1,
                                          color: const Color(0x08000000),
                                        ),
                                        const SizedBox(height: 2),
                                        // To Currency Amount
                                        Row(
                                          children: [
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${widget.toCurrency.symbol}${_getMainAmount(widget.convertedAmount)}',
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'Arial Rounded MT Bold',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 30,
                                                        letterSpacing: 0.02,
                                                        color: Color(
                                                          0xFF8A8A8C,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Currency Flag
                                            Container(
                                              width: 26,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child:
                                                  widget.toCurrency ==
                                                      AmountCurrency.usd
                                                  ? _buildUSDFlag()
                                                  : _buildNGNFlag(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                              SvgPicture.asset(
                                Assets.memo,
                                width: 30,
                                height: 30,
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
                                    hintText: 'Memo: what’s the money for?',
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
                                            'Balance: ${widget.fromCurrency.symbol}${_getMainAmount(_userBalance)}',
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17,
                                          letterSpacing: 0.02,
                                          color: Color(0xFF8A8A8C),
                                        ),
                                      ),
                                      WidgetSpan(
                                        alignment:
                                            PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.alphabetic,
                                        child: Transform.translate(
                                          offset: const Offset(0, -5),
                                          child: Text(
                                            _getDecimalPart(_userBalance),
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                              letterSpacing: 0.02,
                                              color: Color(0xFF8A8A8C),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 26,
                                height: 26,
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  Assets.menu,
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Summary Section
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              // Transaction Fee
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
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
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${widget.fromCurrency.symbol}${_getMainAmount(widget.transactionFee)}',
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                              letterSpacing: 0.02,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: ' Fee',
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
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0x08000000),
                              ),
                              // Total
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
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
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${widget.fromCurrency.symbol}${_getMainAmount(_totalAmount)}',
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
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0x08000000),
                              ),
                              // Summary Notes
                              GestureDetector(
                                onTap: widget.onSummaryNotes,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Summary Notes',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: 0.02,
                                            color: Color(0xFF8A8A8C),
                                          ),
                                        ),
                                      ),
                                      Transform.rotate(
                                        angle: -3.14159 / 2, // -90 degrees
                                        child: SvgPicture.asset(
                                          Assets.forward,
                                          width: 10,
                                          height: 6,
                                          colorFilter: const ColorFilter.mode(
                                            Color(0xFFB3B3B7),
                                            BlendMode.srcIn,
                                          ),
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

                        // Pay Bubble - Touch to Confirm
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Processing payment...'),
                              ),
                            );
                          },
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
                                    color: Color(0x4D000000),
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

  Widget _buildUSDFlag() {
    return Container(
      child: SvgPicture.asset(Assets.spendCurrency, height: 60, width: 60),
    );
  }

  Widget _buildNGNFlag() {
    return Container(child: SvgPicture.asset(Assets.Nigerian_Flag));
  }
}
