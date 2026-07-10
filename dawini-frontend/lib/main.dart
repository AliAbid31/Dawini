import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr'), Locale('en')],
      path: 'assets/lang',
      fallbackLocale: const Locale('fr'),
      startLocale: const Locale('fr'),
      child: const DawiniApp(),
    ),
  );
}

class DawiniApp extends StatelessWidget {
  const DawiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dawini',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.lightTheme, // Application du thème global
      home: const SplashScreen(),
    );
  }
}