import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedLanguage = 'FR';

  final List<Map<String, String>> _pages = [
    {
      'title': 'Bienvenue sur OUMI',
      'desc': 'Votre plateforme numérique nationale dédiée à la santé maternelle et infantile au Tchad.',
      'image': 'assets/images/logo.png',
    },
    {
      'title': 'Suivi Personnalisé',
      'desc': 'Que vous soyez une jeune fille, une maman ou un futur papa, accédez à des outils adaptés à vos besoins.',
      'image': 'assets/images/logo.png',
    },
    {
      'title': 'Urgence & Assistance',
      'desc': 'Signalez un accouchement ou une urgence en un clic pour une prise en charge immédiate par les hôpitaux.',
      'image': 'assets/images/logo.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: _buildLanguageSelector(),
        ),
        leadingWidth: 100,
        actions: [
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text('Passer', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (idx) => setState(() => _currentPage = idx),
              itemBuilder: (context, idx) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Logo Circulaire Header
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          padding: const EdgeInsets.all(4),
                          child: ClipOval(
                            child: Image.asset(
                              _pages[idx]['image']!,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(Icons.health_and_safety, size: 100, color: AppTheme.primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        Text(
                          _pages[idx]['title']!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _pages[idx]['desc']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return ActionChip(
      label: Text(_selectedLanguage, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      avatar: const Icon(Icons.language, size: 16, color: AppTheme.primaryColor),
      onPressed: () {
        setState(() => _selectedLanguage = _selectedLanguage == 'FR' ? 'AR' : 'FR');
      },
      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(_pages.length, (idx) => _buildDot(idx)),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  if (_currentPage == _pages.length - 1) {
                    context.go('/login');
                  } else {
                    _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                  }
                },
                backgroundColor: AppTheme.primaryColor,
                elevation: 4,
                label: Text(_currentPage == _pages.length - 1 ? 'Commencer' : 'Suivant'),
                icon: Icon(_currentPage == _pages.length - 1 ? Icons.check : Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'En continuant, vous acceptez nos Conditions d\'Utilisation',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: _currentPage == index ? 32 : 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: _currentPage == index ? AppTheme.primaryColor : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
