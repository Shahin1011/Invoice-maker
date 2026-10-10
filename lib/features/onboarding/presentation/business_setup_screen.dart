import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_app_button.dart';
import 'package:quick_invoice/core/base/custom_text_field.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/route/route.dart';

class BusinessSetupScreen extends StatefulWidget {
  const BusinessSetupScreen({super.key});

  @override
  State<BusinessSetupScreen> createState() => _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends State<BusinessSetupScreen> {
  bool _showMore = false;
  final TextEditingController _currencyController = TextEditingController(text: 'USD — \$ — US Dollar');
  final TextEditingController _phoneController = TextEditingController();
  File? _logoImage;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US');

  Future<void> _pickLogo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _logoImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _currencyController.dispose();
    _phoneController.dispose();
    super.dispose();
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
                'Add a few details to personalize your invoices. You can complete the rest later.',
                fontSize: 14,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 16),
              
              _buildLabel('BUSINESS LOGO'),
              GestureDetector(
                onTap: _pickLogo,
                child: Container(
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
                          image: _logoImage != null
                              ? DecorationImage(
                                  image: FileImage(_logoImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _logoImage == null
                            ? const Icon(Icons.camera_alt_outlined, color: Color(0xFF64748B), size: 20)
                            : null,
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
              ),

              _buildLabel('Business Name'),
              const CustomTextField(
                hintText: 'e.g. ABC Company',
              ),

              _buildLabel('Business Owner Name'),
              const CustomTextField(
                hintText: 'e.g. John Smith',
              ),

              _buildLabel('Phone Number'),
              Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: AppColors.mainAppColor,
                  colorScheme: const ColorScheme.light(primary: AppColors.mainAppColor),
                ),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    _phoneNumber = number;
                  },
                  searchBoxDecoration: InputDecoration(
                    hintText: 'Search by country name or dial code',
                    hintStyle: const TextStyle(
                      fontFamily: 'DMSans-Regular',
                      fontSize: 14,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                    setSelectorButtonAsPrefixIcon: true,
                    leadingPadding: 12,
                    useBottomSheetSafeArea: true,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: const TextStyle(
                    fontFamily: 'DMSans-Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mainAppColor,
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'DMSans-Regular',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mainAppColor,
                  ),
                  initialValue: _phoneNumber,
                  textFieldController: _phoneController,
                  formatInput: true,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  inputDecoration: InputDecoration(
                    hintText: '555 000 0000',
                    hintStyle: const TextStyle(
                      fontFamily: 'DMSans-Regular',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.borderColor,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.mainAppColor, width: 1),
                    ),
                  ),
                ),
              ),

              _buildLabel('Email'),
              const CustomTextField(
                hintText: 'hello@yourbusiness.com',
                keyboardType: TextInputType.emailAddress,
              ),

              _buildLabel('Business Address'),
              const CustomTextField(
                hintText: 'Enter your complete business address\ne.g. 123 Main St, New York, NY 10001',
                maxLines: 3,
              ),

              _buildLabel('Currency'),
              CustomTextField(
                textEditingController: _currencyController,
                readOnly: true,
                suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                onTap: () {
                  showCurrencyPicker(
                    context: context,
                    showFlag: true,
                    showCurrencyName: true,
                    showCurrencyCode: true,
                    theme: CurrencyPickerThemeData(
                      inputDecoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.mainAppColor),
                        ),
                      ),
                    ),
                    onSelect: (Currency currency) {
                      _currencyController.text = '${currency.code} — ${currency.symbol} — ${currency.name}';
                    },
                  );
                },
              ),

              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showMore = !_showMore;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      _showMore ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppColors.mainAppColor,
                    ),
                    const SizedBox(width: 4),
                    AppText(
                      _showMore ? 'Collapse' : 'Show more',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mainAppColor,
                    ),
                  ],
                ),
              ),
              if (_showMore) ...[
                _buildLabel('Website'),
                const CustomTextField(
                  hintText: 'https://yourbusiness.com',
                ),
                _buildLabel('Tax / VAT Number'),
                const CustomTextField(
                  hintText: 'Enter tax or VAT number',
                ),
                _buildLabel('Payment Information'),
                const CustomTextField(
                  hintText: 'Bank Name\nAccount Name\nAccount Number',
                  maxLines: 3,
                ),
                _buildLabel('Business Registration Number'),
                const CustomTextField(
                  hintText: 'Enter registration number',
                ),
              ],
              const SizedBox(height: 32),
              CustomAppButton(
                text: "Continue",
                textColor: AppColors.mainAppColor,
                backgroundColor: AppColors.secondaryColor,
                onTap: () {
                  Get.offAllNamed(AppRoutes.bottomNavScreen);
                },
              ),

              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.offAllNamed(AppRoutes.bottomNavScreen);
                  },
                  child: AppText(
                    'Skip for Now',
                    fontSize: 15,
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: AppText(
        text,
        color: const Color(0xFF647477),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
