import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:transfa/shared/widgets/animated_dotted_loader.dart';
import '../../../core/constants/assets.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/transfa_logo.dart';
import '../../../data/mock_api/currency.dart';

// ============================================================
// SEND DOLLARS BOTTOM SHEET
// ============================================================

class SendDollarsSheet extends StatefulWidget {
  final String amount;
  final AmountCurrency currency;
  final String memo;
  final String accountNumber;
  final String routingNumber;
  final String accountName;
  final String bankName;
  final String swiftCode;
  final String bankAddress;
  final String country;
  final double userBalance;
  final double transactionFee;
  final Function(String) onMemoChanged;
  final VoidCallback onRoutingInfo;
  final VoidCallback onSwiftInfo;

  const SendDollarsSheet({
    super.key,
    required this.amount,
    required this.currency,
    required this.memo,
    required this.accountNumber,
    required this.routingNumber,
    required this.accountName,
    required this.bankName,
    required this.swiftCode,
    required this.bankAddress,
    required this.country,
    required this.userBalance,
    required this.transactionFee,
    required this.onMemoChanged,
    required this.onRoutingInfo,
    required this.onSwiftInfo,
  });

  @override
  State<SendDollarsSheet> createState() => _SendDollarsSheetState();
}

class _SendDollarsSheetState extends State<SendDollarsSheet> {
  final TextEditingController _memoController = TextEditingController();

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
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _onMemoChanged(String value) {
    widget.onMemoChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final String symbol = widget.currency.symbol;
    final double parsedAmount =
        double.tryParse(widget.amount.replaceAll(',', '')) ?? 0;

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
                        // Account Number & Name Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              // Account Number Row
                              Padding(
                                padding: const EdgeInsets.all(10),
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
                                        widget.accountNumber,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17,
                                          letterSpacing: 0.02,
                                          color: Color(0xFF8A8A8C),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 26,
                                      height: 26,
                                      child: AnimatedDottedLoader(),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                                color: Color(0x08000000),
                              ),
                              // Routing Number Row
                              GestureDetector(
                                onTap: widget.onRoutingInfo,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9F1F1),
                                          borderRadius: BorderRadius.circular(
                                            35,
                                          ),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            Assets.Routing,
                                            width: 13.5,
                                            height: 10.8,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          widget.routingNumber,
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: 0.02,
                                            color: Color(0xFF8A8A8C),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 26,
                                        height: 26,
                                        child: const Icon(
                                          Icons.info_outline,
                                          size: 25,
                                          color: Color(0xFFB3B3B7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                                color: Color(0x08000000),
                              ),
                              // Account Name Row
                              Padding(
                                padding: const EdgeInsets.all(10),
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
                                      child: SvgPicture.asset(
                                        Assets.contacts,
                                        width: 26,
                                        height: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        widget.accountName,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17,
                                          letterSpacing: 0.02,
                                          color: Color(0xFF8A8A8C),
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

                        // Bank Field
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
                                padding: EdgeInsets.all(7),
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
                                child: SvgPicture.asset(
                                  Assets.bank,
                                  width: 14,
                                  height: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.bankName,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                    letterSpacing: 0.02,
                                    color: Color(0xFF8A8A8C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Swift, Bank Address & Country Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              // Swift Code Row
                              GestureDetector(
                                onTap: widget.onSwiftInfo,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9F1F1),
                                          borderRadius: BorderRadius.circular(
                                            35,
                                          ),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            Assets.swiftRedLogo,
                                            width: 22,
                                            height: 22,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          widget.swiftCode,
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            letterSpacing: 0.02,
                                            color: Color(0xFF8A8A8C),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 26,
                                        height: 26,
                                        child: const Icon(
                                          Icons.info_outline,
                                          size: 25,
                                          color: Color(0xFFB3B3B7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                                color: Color(0x08000000),
                              ),
                              // Bank Address Row
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9F1F1),
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          Assets.locationAlt,
                                          width: 12,
                                          height: 18,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        widget.bankAddress,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17,
                                          letterSpacing: 0.02,
                                          color: Color(0xFF8A8A8C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                                color: Color(0x08000000),
                              ),
                              // Country Row with Dropdown
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: _buildUSDFlag(),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        widget.country,
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
                                        width: 10.5,
                                        height: 14,
                                        colorFilter: const ColorFilter.mode(
                                          Color(0xFFB3B3B7),
                                          BlendMode.srcIn,
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
                                  decoration: InputDecoration(
                                    hintText: widget.memo.isEmpty
                                        ? 'Memo...'
                                        : widget.memo,
                                    hintStyle: const TextStyle(
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
                                            'Balance: $symbol${_getMainAmount(widget.userBalance)}',
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
                                            _getDecimalPart(widget.userBalance),
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
      width: 36,
      height: 30,
      
      child: SvgPicture.asset(Assets.spendCurrency),
    );
  }
}
