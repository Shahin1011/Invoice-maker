import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_app_button.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';

class ClientDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> client;

  const ClientDetailsScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.mainAppColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: AppText(
          'Client Details',
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              _showMoreOptions(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(24.w),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F4F6),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: AppText(
                      client['name'][0].toUpperCase(),
                      color: AppColors.mainAppColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          client['name'],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor1,
                        ),
                        SizedBox(height: 4.h),
                        AppText(
                          'ABC Company',
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                        ),
                        SizedBox(height: 8.h),
                        _buildInfoRow(Icons.email_outlined, 'hefzur@gmail.com'),
                        SizedBox(height: 4.h),
                        _buildInfoRow(Icons.phone_outlined, '+88013565886'),
                        SizedBox(height: 4.h),
                        _buildInfoRow(null, 'House 24, Road 7, Dhanmondi, Dhaka,\nBangladesh'),
                        SizedBox(height: 4.h),
                        _buildInfoRow(null, 'Tax / VAT: 123456789'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(24.w),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'INVOICE SUMMARY',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      _buildSummaryCard('Invoices', '0', AppColors.textColor1),
                      SizedBox(width: 12.w),
                      _buildSummaryCard('Total Billed', '\$0.00', AppColors.textColor1),
                      SizedBox(width: 12.w),
                      _buildSummaryCard('Outstanding', '\$0.00', const Color(0xFFF59E0B)),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  CustomAppButton(
                    text: 'Create Statement',
                    textColor: AppColors.textColor1,
                    backgroundColor: AppColors.secondaryColor,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData? icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16.sp, color: const Color(0xFF94A3B8)),
          SizedBox(width: 8.w),
        ] else ...[
          SizedBox(width: 24.w),
        ],
        Expanded(
          child: AppText(
            text,
            fontSize: 13,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            AppText(
              title,
              fontSize: 11,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            AppText(
              value,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 12.h),
              _buildBottomSheetOption('Edit Details'),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildBottomSheetOption('Delete Client'),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildBottomSheetOption('Create New Invoice'),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildBottomSheetOption('Create Statement'),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption(String text) {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        alignment: Alignment.center,
        child: AppText(
          text,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1E293B),
        ),
      ),
    );
  }
}

