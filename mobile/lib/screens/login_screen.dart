import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/widgets/primary_button.dart';
import 'package:mobile/widgets/section_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isSigningIn = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isSigningIn = true);
    try {
      final GoogleSignInAccount account = await GoogleSignIn.instance
          .authenticate(scopeHint: <String>['email']);
      final String? idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const GoogleSignInException(
          code: GoogleSignInExceptionCode.unknownError,
          description: 'idToken alınamadı.',
        );
      }
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } on GoogleSignInException catch (e, stack) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // canceled hem gercek iptali hem de yapilandirma
        // hatasini kapsayabiliyor; ayirt edebilmek icin loglaniyor.
        debugPrint('GoogleSignIn iptal/kapatma: ${e.code} — ${e.description}');
        return;
      }
      debugPrint('GoogleSignInException: ${e.code} ${e.description}\n$stack');
      _showError();
    } catch (e, stack) {
      debugPrint('Google sign-in error: $e\n$stack');
      _showError();
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  void _showError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google ile giriş yapılamadı, tekrar deneyin.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                LucideIcons.sparkles,
                size: 24,
                color: Color(0xFFC8A96E),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ayna AI',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const Spacer(),
              const SectionCard(
                child: Column(
                  children: [
                    Text(
                      'Tek dokunuşla devam et',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Mock giriş ekranı. Gerçek auth bağlantısı yok.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              PrimaryButton(
                label: _isSigningIn ? 'Giriş yapılıyor...' : 'Google ile Giriş Yap',
                icon: LucideIcons.logIn,
                onPressed: _isSigningIn ? null : _signInWithGoogle,
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Demo Olarak Giriş Yap',
                icon: LucideIcons.logIn,
                onPressed: _isSigningIn
                    ? null
                    : () => Navigator.pushReplacementNamed(
                        context,
                        HomeScreen.routeName,
                      ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Auth özelliği yakında eklenecek',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
