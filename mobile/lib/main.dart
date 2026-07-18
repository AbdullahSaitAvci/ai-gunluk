import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/screens/enrich_screen.dart';
import 'package:mobile/screens/entry_screen.dart';
import 'package:mobile/screens/history_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/mood_screen.dart';
import 'package:mobile/screens/onboarding_screen.dart';
import 'package:mobile/screens/settings_screen.dart';
import 'package:mobile/screens/splash_screen.dart';
import 'package:mobile/screens/success_screen.dart';
import 'package:mobile/widgets/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  await Supabase.initialize(
    url: 'https://voetvwldxfumcufxpkht.supabase.co',
    publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZvZXR2d2xkeGZ1bWN1Znhwa2h0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkyNzg1NjIsImV4cCI6MjA5NDg1NDU2Mn0.OYnw6JOUNGG7eLYoGdHJHddGJhgsEWrnWDd7xMflDV0',
  );
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '659930256846-so2u3m37iconmlhaqhve0c023j52rub2.apps.googleusercontent.com',
  );
  runApp(const ProviderScope(child: AynaApp()));
}

class AynaApp extends StatelessWidget {
  const AynaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ayna AI',
      theme: AppTheme.themeData,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        EntryScreen.routeName: (_) => const EntryScreen(),
        EnrichScreen.routeName: (_) => const EnrichScreen(),
        MoodScreen.routeName: (_) => const MoodScreen(),
        SuccessScreen.routeName: (_) => const SuccessScreen(),
        HistoryScreen.routeName: (_) => const HistoryScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
      },
    );
  }
}
