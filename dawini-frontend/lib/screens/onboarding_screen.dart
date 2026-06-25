import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import './onboarding_page.dart';
import './login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Find Medicines Fast',
      description: 'Search real-time availability in nearby pharmacies with our live inventory mapping.',
      accentColor: AppColors.onboarding1Accent,
      circleBgColor: AppColors.onboarding1Bg,
      iconWidget: const Icon(Icons.search_sharp, size: 80, color: AppColors.onboarding1Accent),
    ),
    OnboardingData(
      title: 'Secure Availability',
      description: 'Send confirmation requests to reserve your medicine and pick it up with confidence.',
      accentColor: AppColors.onboarding2Accent,
      circleBgColor: AppColors.onboarding2Bg,
      iconWidget: const Icon(Icons.shield_outlined, size: 90, color: AppColors.onboarding2Accent),
    ),
    OnboardingData(
      title: 'Stock Alerts',
      description: 'Get notified instantly as soon as your essential medication is back in stock at a nearby store.',
      accentColor: AppColors.onboarding3Accent,
      circleBgColor: AppColors.onboarding3Bg,
      iconWidget: const Icon(Icons.notifications_active_outlined, size: 90, color: AppColors.onboarding3Accent),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar (Back, Title, Skip)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage > 0
                      ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                      : const SizedBox(width: 48, height: 48),
                  const Text(
                    'Dawini',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Action Skip
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Slider
            SizedBox(
              height: 460,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return OnboardingPage(
                    title: data.title,
                    description: data.description,
                    accentColor: data.accentColor,
                    circleBgColor: data.circleBgColor,
                    iconWidget: data.iconWidget,
                  );
                },
              ),
            ),
            const Spacer(),
            // Indicateurs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 6,
                  width: _currentPage == index ? 22 : 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.indicatorInactive,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Bouton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_currentPage < _onboardingData.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (_currentPage < _onboardingData.length - 1) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final Color accentColor;
  final Color circleBgColor;
  final Widget iconWidget;

  OnboardingData({
    required this.title,
    required this.description,
    required this.accentColor,
    required this.circleBgColor,
    required this.iconWidget,
  });
}