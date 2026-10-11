import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';

class InvoiceItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onQuantityDecreased;
  final VoidCallback onQuantityIncreased;
  final VoidCallback onRemove;
  final VoidCallback? onUnitTap;
  final VoidCallback? onEditNoteTap;

  const InvoiceItemCard({
    super.key,
    required this.item,
    required this.onQuantityDecreased,
    required this.onQuantityIncreased,
    required this.onRemove,
    this.onUnitTap,
    this.onEditNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    final qty = (item['quantity'] as num?)?.toInt() ?? 1;
    final price = (item['price'] as num?)?.toDouble() ?? 0.0;
    final itemTotal = qty * price;
    final unit = item['unit'] as String?;
    final unitDisplay = (unit != null && unit.isNotEmpty && unit != 'None') ? unit : 'Set unit';
    final desc = item['description'] as String?;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title, Subtitle, Unit trigger & Action Icons
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      item['name'] ?? '',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor1,
                    ),
                    SizedBox(height: 3.h),
                    AppText(
                      (desc != null && desc.isNotEmpty) ? desc : 'Electronic Device',
                      fontSize: 13,
                      color: const Color(0xFF64748B),
                    ),
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: onUnitTap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            unitDisplay,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mainAppColor,
                          ),
                          SizedBox(width: 2.w),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 18,
                            color: AppColors.mainAppColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: onEditNoteTap,
                    borderRadius: BorderRadius.circular(6.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: SvgPicture.asset(
                        'assets/icons/editIcon.svg',
                        width: 19.w,
                        height: 19.w,
                        colorFilter: const ColorFilter.mode(
                          AppColors.mainAppColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: onRemove,
                    borderRadius: BorderRadius.circular(6.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: SvgPicture.asset(
                        'assets/icons/deleteIcon.svg',
                        width: 18.w,
                        height: 19.w,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Bottom Row: Quantity Stepper, Price pill, and Total
          Row(
            children: [
              // Quantity stepper pill
              Container(
                height: 38.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: onQuantityDecreased,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: const Icon(
                          Icons.remove,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 18.h,
                      color: const Color(0xFFE2E8F0),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: AppText(
                        '$qty',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor1,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 18.h,
                      color: const Color(0xFFE2E8F0),
                    ),
                    InkWell(
                      onTap: onQuantityIncreased,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: const Icon(
                          Icons.add,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: const AppText(
                  '×',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF94A3B8),
                ),
              ),

              // Price pill
              Container(
                height: 38.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: AppText(
                  '\$ ${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)}',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor1,
                ),
              ),

              const Spacer(),

              // Line item total
              AppText(
                '\$${itemTotal.toStringAsFixed(2)}',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
