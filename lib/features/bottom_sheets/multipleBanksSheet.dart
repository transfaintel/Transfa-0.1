import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/assets.dart';
import '../../../shared/widgets/transfa_logo.dart';

// ============================================================
// MULTIPLE BANKS BOTTOM SHEET
// ============================================================

class BankOption {
  final String name;
  final Widget logo;
  final VoidCallback onTap;

  const BankOption({
    required this.name,
    required this.logo,
    required this.onTap,
  });
}

class MultipleBanksSheet extends StatefulWidget {
  final String recipientName;
  final String? recipientImageUrl;
  final String? accountNumber;
  final String amount;
  final String currencySymbol;
  final String memo;
  final Function(String) onMemoChanged;
  final List<BankOption> banks;

  const MultipleBanksSheet({
    super.key,
    required this.recipientName,
    this.recipientImageUrl,
    this.accountNumber,
    required this.amount,
    required this.currencySymbol,
    required this.memo,
    required this.onMemoChanged,
    required this.banks,
  });

  @override
  State<MultipleBanksSheet> createState() => _MultipleBanksSheetState();
}

class _MultipleBanksSheetState extends State<MultipleBanksSheet> {
  final TextEditingController _memoController = TextEditingController();

  // Mock user balance
  final double _userBalance = 25000000.00;
  final double _transactionFee = 2500.00;
  final double _disputeProtection = 25000.00;

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
    final String symbol = widget.currencySymbol;
    final double parsedAmount =
        double.tryParse(widget.amount.replaceAll(',', '')) ?? 0;

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
                              if (widget.accountNumber != null) ...[
                                const SizedBox(height: 5),
                                Text(
                                  widget.accountNumber!,
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
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Choose a Bank Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              // Navigation Note
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.accountNumber != null
                                            ? 'This account number is connected to multiple banks, choose a bank to pay.'
                                            : '${widget.recipientName} has multiple bank accounts, choose a bank to pay.',
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          letterSpacing: 0.02,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Bank List
                              ...widget.banks.asMap().entries.map((entry) {
                                final index = entry.key;
                                final bank = entry.value;
                                return Column(
                                  children: [
                                    _BankRow(
                                      logo: bank.logo,
                                      name: bank.name,
                                      onTap: bank.onTap,
                                    ),
                                    if (index < widget.banks.length - 1)
                                      const Divider(
                                        height: 1,
                                        indent: 16,
                                        endIndent: 16,
                                        color: Color(0x08000000),
                                      ),
                                  ],
                                );
                              }),
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
                                        fontWeight: FontWeight.w400,
                                        fontSize: 30,
                                        letterSpacing: 0.02,
                                        color: Colors.black,
                                      ),
                                    ),
                                    // WidgetSpan(
                                    //   alignment: PlaceholderAlignment.baseline,
                                    //   baseline: TextBaseline.alphabetic,
                                    //   child: Transform.translate(
                                    //     offset: const Offset(0, -8),
                                    //     child: Text(
                                    //       _getDecimalPart(parsedAmount),
                                    //       style: const TextStyle(
                                    //         fontFamily: 'Arial Rounded MT Bold',
                                    //         fontWeight: FontWeight.w400,
                                    //         fontSize: 16,
                                    //         letterSpacing: 0.02,
                                    //         color: Color(0xFF8A8A8C),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.memo,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    vertical: 15.0,
                                  ),
                                  child: TextField(
                                    controller: _memoController,
                                    onChanged: _onMemoChanged,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      letterSpacing: 0.02,
                                      color: Colors.black,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: "Memo: what's the money for?",
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
                                      // WidgetSpan(
                                      //   alignment:
                                      //       PlaceholderAlignment.baseline,
                                      //   baseline: TextBaseline.alphabetic,
                                      //   child: Transform.translate(
                                      //     offset: const Offset(0, -5),
                                      //     child: Text(
                                      //       _getDecimalPart(_userBalance),
                                      //       style: const TextStyle(
                                      //         fontFamily: 'Roboto',
                                      //         fontWeight: FontWeight.w400,
                                      //         fontSize: 11,
                                      //         letterSpacing: 0.02,
                                      //         color: Color(0xFF8A8A8C),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              // Container(
                              //   width: 26,
                              //   height: 26,
                              //   alignment: Alignment.center,
                              //   child: SvgPicture.asset(
                              //     Assets.menu,
                              //     width: 18,
                              //     height: 18,
                              //   ),
                              // ),
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

                        // Pay Bubble - Touch to Confirm (Disabled State)
                        GestureDetector(
                          onTap: () {},
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
}

class _BankRow extends StatelessWidget {
  final Widget logo;
  final String name;
  final VoidCallback onTap;

  const _BankRow({required this.logo, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Bank Logo
            Container(width: 50, height: 50, child: logo),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  letterSpacing: 0.02,
                  color: Colors.black,
                ),
              ),
            ),
            // Forward arrow
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
    );
  }
}
