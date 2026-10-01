import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';
import 'package:quick_invoice/features/onboarding/presentation/onboarding_screen.dart';
import '../../../core/route/route.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Get.offAll(() => OnboardingScreen());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildCustomLogo() {
    return SizedBox(
      height: 120,
      width: 100,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // The main document background
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INVOICE',
                    style: TextStyle(
                      color: AppColors.mainAppColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 4, width: double.infinity, color: AppColors.upcomingColor),
                            const SizedBox(height: 6),
                            Container(height: 4, width: 24, color: AppColors.upcomingColor),
                            const SizedBox(height: 6),
                            Container(height: 4, width: 36, color: AppColors.upcomingColor),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '\$',
                        style: TextStyle(
                          color: AppColors.mainAppColor,
                          fontSize: 32,
                          height: 1,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // The folded corner at the top right
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFF26B0B1),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
          // The yellow checkmark badge at bottom left
          Positioned(
            bottom: -10,
            left: -10,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.white,
                size: 24,
                weight: 900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainAppColor,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            // Logo Image
            // We use the splashImg.png or fallback to a placeholder if it's the whole logo
            _buildCustomLogo(),
            const SizedBox(height: 16),
            // Text: InvoiceGo
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                children: [
                  TextSpan(
                    text: 'Invoice',
                    style: TextStyle(color: AppColors.white),
                  ),
                  TextSpan(
                    text: 'Go',
                    style: TextStyle(color: AppColors.secondaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Text(
              'Create • PDF • Share',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                letterSpacing: 1.0,
              ),
            ),
            const Spacer(flex: 2),
            // Loading Dots
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                int activeIndex = (_animationController.value * 3).floor();
                if (activeIndex > 2) activeIndex = 2; // safety clamp
                
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(activeIndex == 0 ? AppColors.secondaryColor : AppColors.white),
                    const SizedBox(width: 8),
                    _buildDot(activeIndex == 1 ? AppColors.secondaryColor : AppColors.white),
                    const SizedBox(width: 8),
                    _buildDot(activeIndex == 2 ? AppColors.secondaryColor : AppColors.white),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            // Version text
            const Text(
              'Version 1.0',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}