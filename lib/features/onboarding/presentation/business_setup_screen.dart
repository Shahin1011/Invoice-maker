import 'package:flutter/material.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_text_field.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';

class BusinessSetupScreen extends StatefulWidget {
  const BusinessSetupScreen({super.key});

  @override
  State<BusinessSetupScreen> createState() => _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends State<BusinessSetupScreen> {
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: AppText(
        text,
        color: const Color(0xFF64748B), // Greyish blue
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Set Up Your Business',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor1,
              ),
              const SizedBox(height: 8),
              AppText(
                'Add a few details to personalize your invoices. You\ncan complete the rest later.',
                fontSize: 14,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 16),
              
              _buildLabel('BUSINESS LOGO'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF64748B), size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Add your logo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mainAppColor,
                          ),
                          const SizedBox(height: 4),
                          AppText(
                            'Personalizes your invoices. Tap to\nupload and preview.',
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),

              _buildLabel('BUSINESS NAME *'),
              const CustomTextField(
                hintText: 'e.g. ABC Company',
              ),

              _buildLabel('BUSINESS OWNER NAME'),
              const CustomTextField(
                hintText: 'e.g. John Smith',
              ),

              _buildLabel('PHONE NUMBER'),
              const CustomTextField(
                hintText: '+1 555 000 0000',
                keyboardType: TextInputType.phone,
              ),

              _buildLabel('EMAIL'),
              const CustomTextField(
                hintText: 'hello@yourbusiness.com',
                keyboardType: TextInputType.emailAddress,
              ),

              _buildLabel('BUSINESS ADDRESS'),
              const CustomTextField(
                hintText: 'Enter your complete business address\ne.g. 123 Main St, New York, NY 10001',
                maxLines: 3,
              ),

              _buildLabel('CURRENCY *'),
              CustomTextField(
                hintText: 'USD — \$ — US Dollar',
                readOnly: true,
                suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.mainAppColor),
                  const SizedBox(width: 4),
                  AppText(
                    'Show more',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainAppColor,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: AppColors.mainAppColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Skip action
                  },
                  child: AppText(
                    'Skip for Now',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
