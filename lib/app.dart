// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'package:flutter/services.dart';
import 'shared/widgets/connectivity_observer.dart';

class TransfaApp extends ConsumerStatefulWidget {
  const TransfaApp({super.key});

  @override
  ConsumerState<TransfaApp> createState() => _TransfaAppState();
}

class _TransfaAppState extends ConsumerState<TransfaApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Transfa',
      theme: AppTheme.light(context),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // ConnectivityObserver for checking when internet connection drops
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return ConnectivityObserver(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
