import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/repositories/repositories.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    final user = await ref.read(authRepositoryProvider).login(_email.text.trim(), _password.text);
    ref.read(currentUserProvider.notifier).state = user;
    if (mounted) context.go(Routes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Welcome back')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Text('Log in to continue.', style: AppTypography.bodyMuted),
          const SizedBox(height: 24),
          AppInput(
            label: 'Email',
            hint: 'you@email.com',
            controller: _email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          AppInput(
            label: 'Password',
            hint: 'Your password',
            controller: _password,
            obscure: _obscure,
            trailing: IconButton(
              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.textMuted),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text('Forgot password?',
                  style: AppTypography.caption.copyWith(color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Log in', loading: _loading, onPressed: _submit),
        ],
      ),
    );
  }
}
