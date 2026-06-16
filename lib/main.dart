// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize connectivity monitoring
  await Connectivity().checkConnectivity();
  
  runApp(const ProviderScope(child: TransfaApp()));
}