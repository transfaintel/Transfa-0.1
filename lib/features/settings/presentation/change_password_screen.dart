import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/primary_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _current = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscureA = true, _obscureB = true, _obscureC = true;
  bool _loading = false;

  @override
  void dispose() {
    _current.dispose();
    _newPassword.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_newPassword.text.length < 8) {
      _snack('Use at least 8 characters.');
      return;
    }
    if (_newPassword.text != _confirm.text) {
      _snack('Passwords don\'t match.');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    _snack('Password updated');
    context.pop();
  }

  void _snack(String s) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));

  Widget _eye(bool obscure, VoidCallback onTap) => IconButton(
        onPressed: onTap,
        icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AppColors.textMuted),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Change password')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Text('Make sure your new password is unique and strong.',
              style: AppTypography.bodyMuted),
          const SizedBox(height: 24),
          AppInput(
            label: 'Current password',
            controller: _current,
            obscure: _obscureA,
            trailing: _eye(_obscureA, () => setState(() => _obscureA = !_obscureA)),
          ),
          const SizedBox(height: 12),
          AppInput(
            label: 'New password',
            controller: _newPassword,
            obscure: _obscureB,
            trailing: _eye(_obscureB, () => setState(() => _obscureB = !_obscureB)),
          ),
          const SizedBox(height: 12),
          AppInput(
            label: 'Confirm new password',
            controller: _confirm,
            obscure: _obscureC,
            trailing: _eye(_obscureC, () => setState(() => _obscureC = !_obscureC)),
          ),
          const SizedBox(height: 28),
          PrimaryButton(label: 'Update password', loading: _loading, onPressed: _submit),
        ],
      ),
    );
  }
}
