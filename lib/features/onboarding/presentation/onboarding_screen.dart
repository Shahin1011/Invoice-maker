import 'package:flutter/material.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/features/onboarding/presentation/business_setup_screen.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';

class OnboardingData {
  final String imagePath;
  final TextSpan title;
  final String description;

  OnboardingData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final List<OnboardingData> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      OnboardingData(
        imagePath: 'assets/images/onboardingImg1.png',
        title: const TextSpan(
          children: [
            TextSpan(
              text: 'Create Professional\n',
              style: TextStyle(fontFamily: "SpaceGrotesk-Bold", color: Colors.black, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: 'Invoices Easily',
              style: TextStyle(fontFamily: "SpaceGrotesk-Bold", color: AppColors.mainAppColor, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        description: 'Design and send beautiful invoices in just a\nfew taps. Save time and keep your\nbusiness organized.',
      ),
      OnboardingData(
        imagePath: 'assets/images/onboardingImg2.png',
        title: const TextSpan(
          children: [
            TextSpan(
              text: 'Manage ',
              style: TextStyle(fontFamily: "SpaceGrotesk-Bold", color: Colors.black, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: 'Clients ',
              style: TextStyle(fontFamily: "SpaceGrotesk-Bold", color: AppColors.mainAppColor, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: 'and\n',
              style: TextStyle(fontFamily: "SpaceGrotesk-Bold", color: Colors.black, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: 'Items',
              style: TextStyle(fontFamily: "SpaceGrotesk-Bold", color: AppColors.mainAppColor, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        description: 'Save your clients, products, and services\nonce and reuse them whenever you create\nan invoice.',
      ),
      OnboardingData(
        imagePath: 'assets/images/onboardingImg3.png',
        title: const TextSpan(
          children: [
            TextSpan(
              text: 'Track Your ',
              style: TextStyle(fontFamily: "SpaceGrotesk-Bold", color: Colors.black, fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: 'Business\nGrowth',
              style: TextStyle(fontFamily: "SpaceGrotesk-Bold", color: AppColors.mainAppColor, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        description: 'Get clear insights with simple reports and\nkeep track of your payments, outstanding\ninvoices, and more.',
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BusinessSetupScreen()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BusinessSetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar with Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _skip,
                    child: AppText(
                      'Skip',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.mainAppColor,
                    ),
                  ),
                ],
              ),
            ),
            
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Image.asset(
                          page.imagePath,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 40),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 24,
                              height: 1.3,
                            ),
                            children: page.title.children,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontFamily: "DMSans-Regular",
                            fontSize: 16,
                            fontWeight:FontWeight.w400
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Section (Indicators and Button)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 6,
                        width: _currentPage == index ? 20 : 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.mainAppColor
                              : AppColors.inputBorder,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentPage == _pages.length - 1
                            ? AppColors.secondaryColor
                            : AppColors.mainAppColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Get Started'
                            : 'Continue',
                        style: TextStyle(
                          color: _currentPage == _pages.length - 1
                              ? AppColors.mainAppColor
                              : AppColors.white,
                          fontFamily: "DMSans-Regular",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
