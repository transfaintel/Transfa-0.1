// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize connectivity monitoring
  await Connectivity().checkConnectivity();

  // This tiny delay allows the native splash to be replaced
  await Future.delayed(const Duration(milliseconds: 50));

  runApp(const ProviderScope(child: TransfaApp()));
}
