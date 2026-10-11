import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_app_button.dart';
import 'package:quick_invoice/core/base/custom_text_field.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';

class EditInvoiceNumberSheet extends StatefulWidget {
  final String currentNumber;
  final ValueChanged<String> onSaved;

  const EditInvoiceNumberSheet({
    super.key,
    required this.currentNumber,
    required this.onSaved,
  });

  @override
  State<EditInvoiceNumberSheet> createState() => _EditInvoiceNumberSheetState();
}

class _EditInvoiceNumberSheetState extends State<EditInvoiceNumberSheet> {
  bool isAutoGenerate = true;
  final String generatedNumber = 'INV-1002';
  late final TextEditingController manualCtrl;

  @override
  void initState() {
    super.initState();
    manualCtrl = TextEditingController(text: widget.currentNumber);
  }

  @override
  void dispose() {
    manualCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 12.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  'Invoice Number',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor1,
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, color: Color(0xFF64748B)),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Toggle Pills: Auto Generate / Manual Entry
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isAutoGenerate = true;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isAutoGenerate ? AppColors.mainAppColor : Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: isAutoGenerate
                              ? AppColors.mainAppColor
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        'Auto Generate',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isAutoGenerate ? Colors.white : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isAutoGenerate = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: !isAutoGenerate ? AppColors.mainAppColor : Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: !isAutoGenerate
                              ? AppColors.mainAppColor
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        'Manual Entry',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: !isAutoGenerate ? Colors.white : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            if (isAutoGenerate)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Next invoice number',
                      fontSize: 13,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 6.h),
                    AppText(
                      generatedNumber,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor1,
                    ),
                    SizedBox(height: 6.h),
                    AppText(
                      'Numbers are assigned in sequence per business.',
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Custom Invoice Number',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    textEditingController: manualCtrl,
                    hintText: 'e.g. INV-1002',
                    fieldBorderRadius: 16,
                    fillColor: const Color(0xFFF8FAFC),
                    fieldBorderColor: const Color(0xFFE2E8F0),
                  ),
                ],
              ),

            SizedBox(height: 24.h),

            CustomAppButton(
              text: 'Save',
              textColor: AppColors.textColor1,
              backgroundColor: AppColors.secondaryColor,
              onTap: () {
                final chosen = isAutoGenerate
                    ? generatedNumber
                    : (manualCtrl.text.trim().isEmpty
                        ? generatedNumber
                        : manualCtrl.text.trim());
                widget.onSaved(chosen);
                Get.back();
              },
            ),
            SizedBox(height: 12.h),

            InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                alignment: Alignment.center,
                child: AppText(
                  'Cancel',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
