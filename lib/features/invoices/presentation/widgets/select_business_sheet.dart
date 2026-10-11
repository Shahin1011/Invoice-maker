import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';
import 'package:quick_invoice/features/onboarding/presentation/business_setup_screen.dart';

class SelectBusinessSheet extends StatelessWidget {
  final List<Map<String, dynamic>> businesses;
  final Map<String, dynamic>? selectedBusiness;
  final ValueChanged<Map<String, dynamic>> onBusinessSelected;
  final ValueChanged<Map<String, dynamic>> onBusinessAdded;

  const SelectBusinessSheet({
    super.key,
    required this.businesses,
    required this.selectedBusiness,
    required this.onBusinessSelected,
    required this.onBusinessAdded,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  AppText(
                    'Select Business',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            ...businesses.map((biz) {
              final isSelected = selectedBusiness?['name'] == biz['name'];
              return InkWell(
                onTap: () {
                  onBusinessSelected(biz);
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: const BoxDecoration(
                          color: AppColors.mainAppColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: AppText(
                          (biz['name'] as String)[0].toUpperCase(),
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              biz['name'] ?? '',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor1,
                            ),
                            SizedBox(height: 2.h),
                            AppText(
                              biz['owner'] ?? '',
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check,
                          color: AppColors.mainAppColor,
                        ),
                    ],
                  ),
                ),
              );
            }),
            const Divider(height: 24, color: Color(0xFFE2E8F0)),
            InkWell(
              onTap: () async {
                Get.back();
                final result = await Get.to(() => const BusinessSetupScreen(isFromInvoice: true));
                if (result != null && result is Map<String, dynamic>) {
                  onBusinessAdded(result);
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: AppColors.mainAppColor,
                      size: 20,
                    ),
                    SizedBox(width: 8.w),
                    AppText(
                      'Add New Business',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainAppColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
