import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/transfa_logo.dart';
import '../../../data/mock_api/currency.dart';
import '../../features/pop-ups/insufficientBalance_popup.dart';
import '../../features/pop-ups/stampDuty_popup.dart';

class InsufficientMoneySheet extends StatefulWidget {
  final String amount;
  final AmountCurrency currency;
  final String memo;
  final String recipientName;
  final String accountNumber;
  final String bankName;
  final String bankLogoAsset;
  final double transactionFee;
  final double stampDuty;
  final double disputeProtection;
  final Function(String) onMemoChanged;

  const InsufficientMoneySheet({
    super.key,
    required this.amount,
    required this.currency,
    required this.memo,
    required this.recipientName,
    required this.accountNumber,
    required this.bankName,
    required this.bankLogoAsset,
    required this.transactionFee,
    required this.stampDuty,
    required this.disputeProtection,
    required this.onMemoChanged,
  });

  @override
  State<InsufficientMoneySheet> createState() => _InsufficientMoneySheetState();
}

class _InsufficientMoneySheetState extends State<InsufficientMoneySheet> {
  final TextEditingController _memoController = TextEditingController();
  final double _userBalance = 200000.00;

  double get _totalAmount {
    final amount = double.tryParse(widget.amount.replaceAll(',', '')) ?? 0;
    return amount + widget.transactionFee + widget.stampDuty;
  }

  String _formatAmount(double amount) =>
      NumberFormat('#,###.##').format(amount);
  String _getMainAmount(double amount) => _formatAmount(amount).split('.')[0];
  String _getDecimalPart(double amount) {
    final parts = _formatAmount(amount).split('.');
    return parts.length > 1 ? '.${parts[1]}' : '.00';
  }

  bool get _isUSD => widget.currency == AmountCurrency.usd;

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

  void _showInsufficientPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => InsufficientMoneyPopup(
        onAddMoney: () {
          context.push(Routes.amount);
        },
      ),
    );
  }

  void _showStampDutyPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const StampDutyPopup(),
    );
  }

  Widget _buildHeader() => Padding(
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
  );

  Widget _buildRecipientInfo() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: _isUSD
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF00FD83), Color(0xFF00A95D)],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFF6777), Color(0xFFF74155)],
                  ),
            borderRadius: BorderRadius.circular(100),
          ),
          child: SvgPicture.asset(Assets.contacts),
        ),
        const SizedBox(height: 10),
        Text(
          widget.recipientName,
          style: const TextStyle(
            fontFamily: 'Arial Rounded MT Bold',
            fontWeight: FontWeight.w400,
            fontSize: 30,
            letterSpacing: 0.02,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          widget.accountNumber,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 17,
            letterSpacing: 0.02,
            color: Color(0x80000000),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildBankField() => Container(
    height: 70,
    padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
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
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF07B826), Color(0xFF4EE659)],
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
          child: widget.bankLogoAsset.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.asset(widget.bankLogoAsset, fit: BoxFit.cover),
                )
              : const Center(
                  child: Icon(
                    Icons.account_balance,
                    color: Colors.white,
                    size: 24,
                  ),
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
              color: Colors.black,
            ),
          ),
        ),
        SvgPicture.asset(
          Assets.context,
          width: 12,
          height: 16,
          colorFilter: const ColorFilter.mode(
            Color(0xFFB3B3B7),
            BlendMode.srcIn,
          ),
        ),
      ],
    ),
  );

  Widget _buildAmountField() => Container(
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _buildAmountText(
                double.tryParse(widget.amount.replaceAll(',', '')) ?? 0,
              ),
            ),
            _buildAddMoneyButton(),
          ],
        ),
      ],
    ),
  );

  Widget _buildAmountText(double amount) => RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: '${widget.currency.symbol}${_getMainAmount(amount)}',
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
              _getDecimalPart(amount),
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
  );

  Widget _buildAddMoneyButton() => GestureDetector(
    onTap: () => context.push(Routes.amount),
    child: Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF7088), Color(0xFFF41E42)],
        ),
        borderRadius: BorderRadius.circular(35),
      ),
      child: const Center(
        child: Text(
          'Add Money',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: 0.02,
            color: Color(0xFFFCFCFB),
          ),
        ),
      ),
    ),
  );

  Widget _buildMemoField() => Container(
    height: 62,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: const Color(0xFFFCFCFB),
      borderRadius: BorderRadius.circular(35),
    ),
    child: Row(
      children: [
        SvgPicture.asset(Assets.memo, width: 30, height: 30),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _memoController,
            onChanged: widget.onMemoChanged,
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
  );

  Widget _buildBalanceField() => Container(
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
                      'Balance: ${widget.currency.symbol}${_getMainAmount(_userBalance)}',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                    letterSpacing: 0.02,
                    color: Color(0xFF8A8A8C),
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
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
          child: SvgPicture.asset(Assets.menu, width: 18, height: 18),
        ),
      ],
    ),
  );

  Widget _buildSummary() => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFFFCFCFB),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Column(
      children: [
        _buildSummaryRow('Transaction Fee', widget.transactionFee),
        const Divider(height: 1, thickness: 1, color: Color(0x08000000)),

        // Show Stamp Duty only for NGN, Dispute Protection only for USD
        if (!_isUSD)
          GestureDetector(
            onTap: _showStampDutyPopup,
            child: _buildStampDutyRow(),
          )
        else
          _buildSummaryRow('Dispute Protection', widget.disputeProtection),

        const Divider(height: 1, thickness: 1, color: Color(0x08000000)),
        _buildSummaryRow('Total', _totalAmount, bold: true),
      ],
    ),
  );

  Widget _buildSummaryRow(String label, double amount, {bool bold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
                  fontSize: 17,
                  letterSpacing: 0.02,
                  color: bold ? Colors.black : const Color(0xFF8A8A8C),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${widget.currency.symbol}${_getMainAmount(amount)}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
                      fontSize: 17,
                      letterSpacing: 0.02,
                      color: Colors.black,
                    ),
                  ),
                  if (!bold)
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
      );

  Widget _buildStampDutyRow() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F3F5),
            borderRadius: BorderRadius.circular(35),
          ),
          alignment: Alignment.center,
          child: Image.asset(Assets.cbnLogo, width: 14, height: 18),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'Stamp Duty',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              fontSize: 17,
              letterSpacing: 0.02,
              color: Color(0xFF8A8A8C),
            ),
          ),
        ),
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          child: const Icon(Icons.info_outline, size: 16, color: Colors.black),
        ),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    '${widget.currency.symbol}${_getMainAmount(widget.stampDuty)}',
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
  );

  Widget _buildConfirmButton() => GestureDetector(
    onTap: _showInsufficientPopup,
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
  );

  @override
  Widget build(BuildContext context) {
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
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildRecipientInfo(),
                        const SizedBox(height: 20),
                        _buildBankField(),
                        const SizedBox(height: 20),
                        _buildAmountField(),
                        const SizedBox(height: 20),
                        _buildMemoField(),
                        const SizedBox(height: 20),
                        _buildBalanceField(),
                        const SizedBox(height: 20),
                        _buildSummary(),
                        const SizedBox(height: 20),
                        _buildConfirmButton(),
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
