import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';

class InvoiceCard extends StatelessWidget {
  final Map<String, dynamic> invoice;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;

  const InvoiceCard({
    super.key,
    required this.invoice,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badgeType = invoice['badgeType'] as String? ?? 'due';
    final badgeText = invoice['badgeText'] as String? ?? 'Draft';

    Color badgeBorderColor = const Color(0xFF94A3B8);
    Color badgeTextColor = const Color(0xFF475569);
    Color badgeBgColor = Colors.transparent;

    if (badgeType == 'paid') {
      badgeBorderColor = const Color(0xFF10B981);
      badgeTextColor = const Color(0xFF059669);
    } else if (badgeType == 'overdue') {
      badgeBorderColor = const Color(0xFFEF4444);
      badgeTextColor = const Color(0xFFDC2626);
      badgeBgColor = const Color(0xFFFEF2F2);
    } else if (badgeType == 'due') {
      badgeBorderColor = const Color(0xFF94A3B8);
      badgeTextColor = const Color(0xFF475569);
      badgeBgColor = Colors.transparent;
    } else if (badgeType == 'draft') {
      badgeBorderColor = const Color(0xFF94A3B8);
      badgeTextColor = const Color(0xFF475569);
      badgeBgColor = Colors.transparent;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSelectionMode) ...[
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.mainAppColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.mainAppColor : const Color(0xFF94A3B8),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 14.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    invoice['invoiceNo'] ?? '',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor1,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    invoice['client'] ?? '',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                  SizedBox(height: 8.h),
                  AppText(
                    invoice['date'] ?? '',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: badgeBorderColor, width: 0.8),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontFamily: 'DMSans-Regular',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: badgeTextColor,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                AppText(
                  invoice['amount'] ?? '',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
