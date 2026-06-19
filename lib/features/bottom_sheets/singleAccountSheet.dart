import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:transfa/features/pop-ups/chooseBank_popup.dart';
import '../../../core/constants/assets.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/transfa_logo.dart';
import '../../../core/router/routes.dart';
import '../../features/pop-ups/transfaDone_popup.dart';

// ============================================================
// SINGLE ACCOUNT BOTTOM SHEET
// ============================================================

class SingleAccountSheet extends StatefulWidget {
  final String amount;
  final String currencySymbol;
  final String memo;
  final String recipientName;
  final String? recipientImageUrl;
  final String accountNumber;
  final String bankName;
  final String? bankLogoAsset;
  final Color? bankGradientColor1;
  final Color? bankGradientColor2;
  final Function(String) onMemoChanged;

  const SingleAccountSheet({
    super.key,
    required this.amount,
    required this.currencySymbol,
    required this.memo,
    required this.recipientName,
    this.recipientImageUrl,
    required this.accountNumber,
    required this.bankName,
    this.bankLogoAsset,
    this.bankGradientColor1,
    this.bankGradientColor2,
    required this.onMemoChanged,
  });

  @override
  State<SingleAccountSheet> createState() => _SingleAccountSheetState();
}

class _SingleAccountSheetState extends State<SingleAccountSheet> {
  final TextEditingController _memoController = TextEditingController();

  // Mock user balance
  final double _userBalance = 25000000.00;
  final double _transactionFee = 1000.00;
  final double _disputeProtection = 25000.00;

  // Bank selection state
  String _selectedBankName = '';
  String? _selectedBankLogoAsset;
  Color? _selectedBankGradientColor1;
  Color? _selectedBankGradientColor2;

  double get _totalAmount {
    final amount = double.tryParse(widget.amount.replaceAll(',', '')) ?? 0;
    return amount + _transactionFee + _disputeProtection;
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
    // Initialize with the passed bank info
    _selectedBankName = widget.bankName;
    _selectedBankLogoAsset = widget.bankLogoAsset;
    _selectedBankGradientColor1 = widget.bankGradientColor1;
    _selectedBankGradientColor2 = widget.bankGradientColor2;
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _onMemoChanged(String value) {
    widget.onMemoChanged(value);
  }

  void _showChooseBankPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => ChooseBankPopup(
        onTransfaSelected: () => _updateBankSelection(
          bankName: 'Transfa',
          logoAsset: Assets.logoSmallWhite,
          gradientColor1: const Color.fromARGB(255, 0, 0, 0),
          gradientColor2: const Color.fromARGB(255, 0, 0, 16),
        ),
        onChaseSelected: () => _updateBankSelection(
          bankName: 'Chase',
          logoAsset: Assets.bankchase,
          gradientColor1: const Color(0xFFFFFFFF),
          gradientColor2: const Color(0xFFFFFFFF),
        ),
        onOPaySelected: () => _updateBankSelection(
          bankName: 'OPay',
          logoAsset: Assets.bankOpay,
          gradientColor1: const Color(0xFFFFFFFF),
          gradientColor2: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }

  void _showDonePopup() {
    // Get the recipient name from widget
    final String recipientName = widget.recipientName;
    final String recipientImageUrl = widget.recipientImageUrl!;
    
    // Close the current bottom sheet first
    Navigator.of(context).pop();
    
    // Then show the done popup
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => TransfaDonePopup(
        userName: recipientName,
        userImageUrl: recipientImageUrl,
      ),
    );
  }

  void _updateBankSelection({
    required String bankName,
    required String logoAsset,
    required Color gradientColor1,
    required Color gradientColor2,
  }) {
    setState(() {
      _selectedBankName = bankName;
      _selectedBankLogoAsset = logoAsset;
      _selectedBankGradientColor1 = gradientColor1;
      _selectedBankGradientColor2 = gradientColor2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String symbol = widget.currencySymbol;
    final double parsedAmount =
        double.tryParse(widget.amount.replaceAll(',', '')) ?? 0;

    // Determine which logo to show
    final String logoToShow = _selectedBankLogoAsset ?? widget.bankLogoAsset ?? '';
    final String bankNameToShow = _selectedBankName.isNotEmpty ? _selectedBankName : widget.bankName;
    final Color? gradient1 = _selectedBankGradientColor1 ?? widget.bankGradientColor1;
    final Color? gradient2 = _selectedBankGradientColor2 ?? widget.bankGradientColor2;

    return Container(
      height: 620,
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
                                child: widget.recipientImageUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          120,
                                        ),
                                        child: Image.asset(
                                          widget.recipientImageUrl!,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Center(
                                        child: SvgPicture.asset(
                                          Assets.contacts,
                                          width: 110,
                                          height: 110,
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
                              const SizedBox(height: 5),
                              // Account Number
                              Text(
                                widget.accountNumber,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  letterSpacing: 0.02,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Transfa Account Info - Updated with selected bank
                        GestureDetector(
                          onTap: _showChooseBankPopup,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCFCFB),
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: gradient1 != null && gradient2 != null
                                        ? LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [gradient1, gradient2],
                                          )
                                        : const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFF00BCF6),
                                              Color(0xFF006EFF),
                                            ],
                                          ),
                                    borderRadius: BorderRadius.circular(35),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: logoToShow.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(35),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: logoToShow.contains('.svg')
                                                ? SvgPicture.asset(
                                                    logoToShow,
                                                    width: 30,
                                                    height: 30,
                                                  )
                                                : Image.asset(
                                                    logoToShow,
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                          ),
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.account_balance,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    bankNameToShow,
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      letterSpacing: 0.02,
                                      color: Colors.black,
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
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '$symbol${_getMainAmount(parsedAmount)}',
                                      style: const TextStyle(
                                        fontFamily: 'Arial Rounded MT Bold',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                        letterSpacing: 0.02,
                                        color: Colors.black,
                                      ),
                                    ),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.alphabetic,
                                      child: Transform.translate(
                                        offset: const Offset(0, -8),
                                        child: Text(
                                          _getDecimalPart(parsedAmount),
                                          style: const TextStyle(
                                            fontFamily: 'Arial Rounded MT Bold',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            letterSpacing: 0.02,
                                            color: Color(0xFF8A8A8C),
                                          ),
                                        ),
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
                                    hintText: '10 Acres',
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
                                            'Balance: $symbol${_getMainAmount(_userBalance)}',
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
                                                '$symbol${_getMainAmount(_transactionFee)}',
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
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0x08000000),
                              ),
                              // Dispute Protection
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Dispute Protection',
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
                                                '$symbol${_getMainAmount(_disputeProtection)}',
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
                                                '$symbol${_getMainAmount(_totalAmount)}',
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Pay Bubble - Touch to Confirm
                        GestureDetector(
                          onTap: _showDonePopup,
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