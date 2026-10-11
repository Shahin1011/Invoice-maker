import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_app_button.dart';
import 'package:quick_invoice/core/base/custom_text_field.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';

class AddClientBottomSheet extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>>? onClientSaved;

  const AddClientBottomSheet({super.key, this.onClientSaved});

  @override
  State<AddClientBottomSheet> createState() => _AddClientBottomSheetState();
}

class _AddClientBottomSheetState extends State<AddClientBottomSheet> {
  bool _showMore = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalController.dispose();
    _countryController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final company = _companyController.text.trim();
    final clientData = {
      'name': name,
      'company': company.isEmpty ? 'Company name' : company,
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'invoices': 0,
      'amount': '\$0.00',
    };
    if (widget.onClientSaved != null) {
      widget.onClientSaved!(clientData);
    }
    Get.back(result: clientData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      'Add Client',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor1,
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFFE2E8F0)),
                    SizedBox(height: 16.h),
                    _buildLabel('Name *'),
                    CustomTextField(
                      textEditingController: _nameController,
                      hintText: 'Enter your client name',
                    ),
                    _buildLabel('Company'),
                    CustomTextField(
                      textEditingController: _companyController,
                      hintText: 'Enter company name',
                    ),
                    _buildLabel('Email'),
                    CustomTextField(
                      textEditingController: _emailController,
                      hintText: 'hello@yourbusiness.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildLabel('Phone Number'),
                    CustomTextField(
                      textEditingController: _phoneController,
                      hintText: '+1 555 000 0000',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.h),
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
                          SizedBox(width: 4.w),
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
                      _buildLabel('Address'),
                      CustomTextField(
                        textEditingController: _addressController,
                        hintText: 'Enter address',
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('City'),
                                CustomTextField(
                                  textEditingController: _cityController,
                                  hintText: '',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('State'),
                                CustomTextField(
                                  textEditingController: _stateController,
                                  hintText: '',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Postal Code'),
                                CustomTextField(
                                  textEditingController: _postalController,
                                  hintText: '',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Country'),
                                CustomTextField(
                                  textEditingController: _countryController,
                                  hintText: '',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _buildLabel('Tax / VAT Number'),
                      CustomTextField(
                        textEditingController: _taxController,
                        hintText: '',
                      ),
                    ],
                    SizedBox(height: 32.h),
                    CustomAppButton(
                      text: 'Add Client',
                      textColor: AppColors.textColor1,
                      backgroundColor: AppColors.secondaryColor,
                      onTap: _save,
                    ),
                    SizedBox(height: 16.h),
                    CustomAppButton(
                      text: 'Cancel',
                      textColor: const Color(0xFF64748B),
                      backgroundColor: Colors.white,
                      borderColor: const Color(0xFFE2E8F0),
                      onTap: () => Get.back(),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
      child: AppText(
        text,
        color: const Color(0xFF647487),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
