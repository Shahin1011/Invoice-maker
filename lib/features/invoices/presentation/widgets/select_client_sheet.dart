import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_text_field.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';
import 'package:quick_invoice/features/clients/presentation/widgets/add_client_bottom_sheet.dart';

class SelectClientSheet extends StatefulWidget {
  final List<Map<String, dynamic>> clients;
  final Map<String, dynamic>? selectedClient;
  final ValueChanged<Map<String, dynamic>> onClientSelected;
  final ValueChanged<Map<String, dynamic>> onClientAdded;

  const SelectClientSheet({
    super.key,
    required this.clients,
    required this.selectedClient,
    required this.onClientSelected,
    required this.onClientAdded,
  });

  @override
  State<SelectClientSheet> createState() => _SelectClientSheetState();
}

class _SelectClientSheetState extends State<SelectClientSheet> {
  String filter = '';

  void _openAddClientSheet() {
    Get.back(); // Close SelectClientSheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return AddClientBottomSheet(
          onClientSaved: (newClient) {
            widget.onClientAdded(newClient);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.clients
        .where((c) =>
            (c['name'] as String).toLowerCase().contains(filter.toLowerCase()) ||
            (c['company'] as String).toLowerCase().contains(filter.toLowerCase()))
        .toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 8.h,
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
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    'Select Client',
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: CustomTextField(
                hintText: 'Search by name, email or phone...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                fieldBorderRadius: 24,
                fieldBorderColor: const Color(0xFFE2E8F0),
                onChanged: (val) {
                  setState(() {
                    filter = val;
                  });
                },
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: filteredList.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                itemBuilder: (context, index) {
                  final c = filteredList[index];
                  final isSelected = widget.selectedClient?['name'] == c['name'];

                  return InkWell(
                    onTap: () {
                      widget.onClientSelected(c);
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
                              color: Color(0xFFE0F2FE),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: AppText(
                              (c['name'] as String)[0].toUpperCase(),
                              color: AppColors.mainAppColor,
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
                                  c['name'] ?? '',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor1,
                                ),
                                SizedBox(height: 2.h),
                                AppText(
                                  c['company'] ?? '',
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
                },
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            InkWell(
              onTap: _openAddClientSheet,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: AppColors.mainAppColor,
                      size: 20,
                    ),
                    SizedBox(width: 8.w),
                    AppText(
                      'Add New Client',
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
