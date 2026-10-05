import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_app_button.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedBusiness = 'Medicine Pharmecy';
  String selectedPeriod = 'This Month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOverviewCard(),
                  SizedBox(height: 16.h),
                  CustomAppButton(
                    text: 'Create New Invoice',
                    textColor: AppColors.textColor1,
                    backgroundColor: AppColors.secondaryColor,
                    prefixIcon: const Icon(Icons.add, color: AppColors.textColor1, size: 20),
                    onTap: () {
                      // Navigate to create invoice
                    },
                  ),
                  SizedBox(height: 24.h),
                  _buildSectionHeader('Recent Invoices', 'See All', () {}),
                  SizedBox(height: 12.h),
                  _buildEmptyStateCard(
                    imagePath: 'assets/images/emptyInvoiceImg.png',
                    title: 'No invoices yet',
                    subtitle: 'Create your first invoice and it will appear\nhere.',
                  ),
                  SizedBox(height: 24.h),
                  _buildSectionHeader('Reports', 'View Reports', () {}),
                  SizedBox(height: 12.h),
                  _buildEmptyStateCard(
                    imagePath: 'assets/images/emptyReportImg.png',
                    title: 'No report data yet',
                    subtitle: 'Your invoice data will appear here once your\ncreate invoices.',
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.mainAppColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 12.h,
        left: 16.w,
        right: 16.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
          ),
          GestureDetector(
            onTap: _showSelectBusinessSheet,
            child: Row(
              children: [
                AppText(
                  selectedBusiness,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                SizedBox(width: 4.w),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                'Overview',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor1,
              ),
              GestureDetector(
                onTap: _showSelectPeriodSheet,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      AppText(
                        selectedPeriod,
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(width: 4.w),
                      const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B), size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AppText(
            'Total Billed',
            fontSize: 12,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 4.h),
          AppText(
            '\$0.00',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor1,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildMiniCard('Invoices', '01', const Color(0xFF0284C7)),
              SizedBox(width: 8.w),
              _buildMiniCard('Paid', '\$0.00', const Color(0xFF10B981)),
              SizedBox(width: 8.w),
              _buildMiniCard('Outstanding', '\$0.00', const Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(String title, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
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
            SizedBox(height: 4.h),
            AppText(
              value,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText, VoidCallback onAction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor1,
        ),
        GestureDetector(
          onTap: onAction,
          child: AppText(
            actionText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.mainAppColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStateCard({required String imagePath, required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Image.asset(imagePath, height: 90.w),
          SizedBox(height: 16.h),
          AppText(
            title,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textColor1,
          ),
          SizedBox(height: 8.h),
          AppText(
            subtitle,
            fontSize: 14,
            color: const Color(0xFF64748B),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showSelectBusinessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
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
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AppText(
                  'Select Business',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor1,
                ),
              ),
              SizedBox(height: 16.h),
              _buildBusinessItem('Medicine Pharmecy', 'hefzur@gmail.com', true),
              _buildBusinessItem('Medicine Pharmecy', 'hefzur@gmail.com', false),
              const Divider(color: Color(0xFFE2E8F0)),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Row(
                    children: [
                      const Icon(Icons.add, color: AppColors.mainAppColor),
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
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBusinessItem(String name, String email, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedBusiness = name;
        });
        Get.back();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: const BoxDecoration(
                color: AppColors.mainAppColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: AppText(
                name[0].toUpperCase(),
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    name,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor1,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    email,
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: AppColors.mainAppColor),
          ],
        ),
      ),
    );
  }

  void _showSelectPeriodSheet() {
    final periods = ['Today', 'This Week', 'This Month', 'Last Month', 'This Year', 'Custom Range'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
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
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AppText(
                  'Select Period',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor1,
                ),
              ),
              SizedBox(height: 16.h),
              ...periods.map((period) => _buildPeriodItem(period, period == selectedPeriod)),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPeriodItem(String period, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPeriod = period;
        });
        Get.back();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              period,
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.mainAppColor : AppColors.textColor1,
            ),
            if (isSelected)
              const Icon(Icons.check, color: AppColors.mainAppColor, size: 20),
          ],
        ),
      ),
    );
  }
}
