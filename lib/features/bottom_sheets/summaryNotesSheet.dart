import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/assets.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/transfa_logo.dart';
import '../../../data/mock_api/currency.dart';

// ============================================================
// SUMMARY NOTES BOTTOM SHEET
// ============================================================

class SummaryNotesSheet extends StatefulWidget {
  final String amount;
  final AmountCurrency fromCurrency;
  final AmountCurrency toCurrency;
  final double convertedAmount;
  final String recipientName;
  final double userBalance;
  final double transactionFee;
  final double exchangeRate;
  final VoidCallback onSwapCurrency;
  final VoidCallback onDone;

  const SummaryNotesSheet({
    super.key,
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.convertedAmount,
    required this.recipientName,
    required this.userBalance,
    required this.transactionFee,
    required this.exchangeRate,
    required this.onSwapCurrency,
    required this.onDone,
  });

  @override
  State<SummaryNotesSheet> createState() => _SummaryNotesSheetState();
}

class _SummaryNotesSheetState extends State<SummaryNotesSheet> {
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
  Widget build(BuildContext context) {
    final double parsedAmount =
        double.tryParse(widget.amount.replaceAll(',', '')) ?? 0;
    final bool isDarkAmount = widget.fromCurrency == AmountCurrency.usd;

    return Container(
      height: (MediaQuery.of(context).size.height * 0.5),
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
                // Navigation Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCFCFB).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Center(
                          child: Container(
                            width: 18,
                            height: 24,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 2),
                                  Text(
                                    'USD',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 5,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Container(height: 1, color: Colors.black),
                                  SizedBox(height: 1),
                                  Container(height: 1, color: Colors.black),
                                  SizedBox(height: 1),
                                  Container(
                                    height: 1,
                                    width: 8,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Summary Notes',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            letterSpacing: 0.02,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onDone,
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: const Center(
                            child: Text(
                              'Done',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                letterSpacing: 0.02,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Convert & Send Amount Section
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
                                                ?
                                                  // Currency Flag
                                                  Container(
                                                    width: 36,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                    child: _buildUSDFlag(),
                                                  )
                                                : Container(
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
                                              padding: EdgeInsets.all(1),
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
                                            SizedBox(width: 4),
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

                        // Detail Section
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCFCFB),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              // You send
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'You send',
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
                                                '${widget.fromCurrency.symbol}${_getMainAmount(parsedAmount)}',
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                              letterSpacing: 0.02,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: _getDecimalPart(parsedAmount),
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
                                indent: 16,
                                endIndent: 16,
                                color: Color(0x08000000),
                              ),
                              // They receive
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${widget.recipientName} gets',
                                        style: const TextStyle(
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
                                                '${widget.toCurrency.symbol}${_getMainAmount(widget.convertedAmount)}',
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                              letterSpacing: 0.02,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: _getDecimalPart(
                                              widget.convertedAmount,
                                            ),
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
                                indent: 16,
                                endIndent: 16,
                                color: Color(0x08000000),
                              ),
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
                                          TextSpan(
                                            text: _getDecimalPart(
                                              widget.transactionFee,
                                            ),
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
                                indent: 16,
                                endIndent: 16,
                                color: Color(0x08000000),
                              ),
                              // Exchange Rate
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Exchange Rate',
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
                                                '${widget.fromCurrency.symbol}${_getMainAmount(widget.exchangeRate)}',
                                            style: const TextStyle(
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 17,
                                              letterSpacing: 0.02,
                                              color: Color(0xFF8A8A8C),
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
                                indent: 16,
                                endIndent: 16,
                                color: Color(0x08000000),
                              ),
                              // Exchange rate provider
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Exchange rate provided by:',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          letterSpacing: 0.02,
                                          color: Color(0xFFB3B3B7),
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      Assets.YahooFinance,
                                      width: 102,
                                      height: 40,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Text(
                                              'Yahoo! Finance',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                letterSpacing: 0.02,
                                                color: Color(0xFFB3B3B7),
                                              ),
                                            );
                                          },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Learn More Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Banks, processors, and account security checks may require additional time to move funds. Transfa is typically instant.',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  letterSpacing: 0.02,
                                  color: Color(0xFF8A8A8C),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Transaction fee is 1.4% of the total with a minimum of \$0.25 and a maximum of \$100.00.',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  letterSpacing: 0.02,
                                  color: Color(0xFF8A8A8C),
                                ),
                              ),
                            ],
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

  Widget _buildNGNFlag() {
    return Container(
      width: 36,
      height: 30,

      child: SvgPicture.asset(Assets.Nigerian_Flag),
    );
  }
}
