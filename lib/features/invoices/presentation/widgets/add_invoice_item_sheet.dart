import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_text_field.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';
import 'package:quick_invoice/features/items/presentation/widgets/add_item_bottom_sheet.dart';

class AddInvoiceItemSheet extends StatefulWidget {
  final List<Map<String, dynamic>> availableItems;
  final List<Map<String, dynamic>> selectedItems;
  final ValueChanged<Map<String, dynamic>> onItemToggled;
  final ValueChanged<Map<String, dynamic>> onItemCreated;

  const AddInvoiceItemSheet({
    super.key,
    required this.availableItems,
    required this.selectedItems,
    required this.onItemToggled,
    required this.onItemCreated,
  });

  @override
  State<AddInvoiceItemSheet> createState() => _AddInvoiceItemSheetState();
}

class _AddInvoiceItemSheetState extends State<AddInvoiceItemSheet> {
  String filter = '';

  void _openAddItemSheet() async {
    Get.back();
    final newItem = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return const AddItemBottomSheet();
      },
    );

    if (newItem != null) {
      widget.onItemCreated(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.availableItems
        .where((item) =>
            (item['name'] as String).toLowerCase().contains(filter.toLowerCase()))
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    'Add Item',
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
                hintText: 'Search saved items...',
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
                  final item = filteredList[index];
                  final isAlreadyAdded =
                      widget.selectedItems.any((si) => si['name'] == item['name']);

                  return InkWell(
                    onTap: () {
                      widget.onItemToggled(item);
                      Get.back();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 14.h,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFEF3C7),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              color: Color(0xFFD97706),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  item['name'] ?? '',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textColor1,
                                ),
                                SizedBox(height: 2.h),
                                AppText(
                                  item['unit'] ?? 'Box',
                                  fontSize: 12,
                                  color: const Color(0xFF64748B),
                                ),
                              ],
                            ),
                          ),
                          if (isAlreadyAdded)
                            const Icon(
                              Icons.check,
                              color: AppColors.mainAppColor,
                            )
                          else
                            AppText(
                              '\$${((item['price'] as num).toDouble() * 2).toStringAsFixed(2)}',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor1,
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
              onTap: _openAddItemSheet,
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
                      'Create new Item',
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
