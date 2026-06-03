import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/widgets/primary_button.dart';
import 'package:mobile/widgets/section_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<(String, String, IconData)> _pages = const [
    ('Hoş geldin', 'Her gün tek bir soruyla kendine aynadan bak.', LucideIcons.sun),
    ('Sesin korunur', 'AI senin yerine yazmaz, sadece yazdıklarını parlatır.', LucideIcons.sparkles),
    ('Güvenli alan', 'Günlüklerin senin kontrolünde ve gizliliğine saygılı.', LucideIcons.shield),
  ];

  /// Onboarding adımlarını ilerletir veya giriş ekranına yönlendirir.
  void _next() {
    if (_currentPage == _pages.length - 1) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Onboarding', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (value) => setState(() => _currentPage = value),
                  itemBuilder: (_, index) {
                    final page = _pages[index];
                    return Center(
                      child: SectionCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(page.$3, size: 52),
                            const SizedBox(height: 24),
                            Text(page.$1, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            Text(page.$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white70)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentPage ? Colors.white : Colors.white24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                label: _currentPage == _pages.length - 1 ? 'Başlayalım' : 'Devam et',
                onPressed: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
