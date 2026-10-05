import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class CustomAppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const CustomAppButton({
    super.key,
    required this.text,
    this.onTap,
    this.textColor = Colors.white,
    this.backgroundColor,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        padding: padding ?? EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.mainAppColor,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          borderRadius: BorderRadius.circular(
            borderRadius?.r ?? 12.r,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              SizedBox(width: 8.w),
            ],

            Text(
              text,
              style: TextStyle(
                fontFamily: 'DMSans-Regular',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),

            if (suffixIcon != null) ...[
              SizedBox(width: 8.w),
              suffixIcon!,
            ],
          ],
        ),
      ),
    );
  }
}