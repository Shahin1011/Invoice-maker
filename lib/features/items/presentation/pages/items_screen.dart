import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_app_button.dart';
import 'package:quick_invoice/core/base/custom_text_field.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  // Mock data for items
  final List<Map<String, dynamic>> items = [
    {
      'name': 'Monas 10mg',
      'unit': 'Box',
      'description': "It's a simple box",
      'amount': '\$900.00',
    },
    {
      'name': 'Monas 10mg',
      'unit': 'Box',
      'description': "It's a simple box",
      'amount': '\$900.00',
    },
    {
      'name': 'Monas 10mg',
      'unit': 'Box',
      'description': "", // Assuming no description for testing
      'amount': '\$800.00',
    },
  ];

  bool isSelectionMode = false;
  Set<int> selectedIndices = {};

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      selectedIndices.clear();
    });
  }

  void _selectAll() {
    setState(() {
      if (selectedIndices.length == items.length) {
        selectedIndices.clear();
      } else {
        selectedIndices = Set.from(Iterable.generate(items.length));
      }
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(
            child: items.isEmpty ? _buildEmptyState() : _buildItemsList(),
          ),
          if (isSelectionMode) _buildSelectionBottomBar(),
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
      child: isSelectionMode
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _toggleSelectionMode,
                  child: AppText(
                    'Cancel',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                AppText(
                  '${selectedIndices.length} Selected',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                GestureDetector(
                  onTap: _selectAll,
                  child: AppText(
                    selectedIndices.length == items.length ? 'Deselect All' : 'Select All',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                ),
                AppText(
                  'Items',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _toggleSelectionMode,
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: _showAddItemSheet,
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: CustomTextField(
        hintText: 'Search invoices...',
        prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
        fieldBorderRadius: 24,
        fieldBorderColor: const Color(0xFFE2E8F0),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/emptyItemImg.png', height: 120.w),
            SizedBox(height: 24.h),
            AppText(
              'No items saved',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor1,
            ),
            SizedBox(height: 8.h),
            AppText(
              'Save products and services to add them to\ninvoices faster.',
              fontSize: 14,
              color: const Color(0xFF64748B),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            CustomAppButton(
              text: 'Add Item',
              textColor: AppColors.textColor1,
              backgroundColor: AppColors.secondaryColor,
              width: 160.w,
              onTap: _showAddItemSheet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionBottomBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _showExportOptions,
            child: AppText(
              'Export',
              color: AppColors.mainAppColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppText(
            'Delete (${selectedIndices.length})',
            color: const Color(0xFFEF4444), // Red color
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
      itemBuilder: (context, index) {
        final item = items[index];
        return ItemCard(
          item: item,
          isSelectionMode: isSelectionMode,
          isSelected: selectedIndices.contains(index),
          onTap: () {
            if (isSelectionMode) {
              _toggleSelection(index);
            }
          },
        );
      },
    );
  }

  void _showAddItemSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return const _AddItemBottomSheet();
      },
    );
  }

  void _showExportOptions() {
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
              AppText(
                'Choose export format',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
              SizedBox(height: 12.h),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildExportOption('CSV'),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              _buildExportOption('XLS'),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExportOption(String text) {
    return InkWell(
      onTap: () {
        Get.back(); // close sheet
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

class ItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.item,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            if (isSelectionMode) ...[
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? AppColors.mainAppColor : const Color(0xFF94A3B8),
                size: 24,
              ),
              SizedBox(width: 12.w),
            ],
            Container(
              width: 48.w,
              height: 48.w,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.mainAppColor,
                size: 24,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item['name'],
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor1,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    item['unit'],
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                  ),
                  if (item['description'] != null && item['description'].toString().isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    AppText(
                      item['description'],
                      fontSize: 13,
                      color: const Color(0xFF94A3B8),
                    ),
                  ],
                ],
              ),
            ),
            AppText(
              item['amount'],
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor1,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddItemBottomSheet extends StatefulWidget {
  const _AddItemBottomSheet();

  @override
  State<_AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<_AddItemBottomSheet> {
  String selectedUnit = 'Select unit';

  void _showSelectUnitSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return _SelectUnitBottomSheet(
          onUnitSelected: (unit) {
            setState(() {
              selectedUnit = unit;
            });
            Get.back();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          children: [
            Row(
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
            const Divider(color: Color(0xFFE2E8F0)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _buildLabel('Item Name *'),
                    const CustomTextField(hintText: 'Enter your items name'),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Unit Price *'),
                              const CustomTextField(hintText: '0.00'),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Unit'),
                              GestureDetector(
                                onTap: _showSelectUnitSheet,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        selectedUnit,
                                        fontSize: 14,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                      const Icon(Icons.keyboard_arrow_down, color: Color(0xFF94A3B8), size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    _buildLabel('Description'),
                    const CustomTextField(
                      hintText: 'Describe the service or product...',
                      maxLines: 3,
                    ),
                    SizedBox(height: 32.h),
                    CustomAppButton(
                      text: 'Add Item',
                      textColor: AppColors.textColor1,
                      backgroundColor: AppColors.secondaryColor,
                      onTap: () {
                        Get.back();
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomAppButton(
                      text: 'Cancel',
                      textColor: const Color(0xFF64748B),
                      backgroundColor: Colors.white,
                      borderColor: const Color(0xFFE2E8F0),
                      onTap: () {
                        Get.back();
                      },
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
      child: AppText(
        text,
        color: const Color(0xFF647477),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _SelectUnitBottomSheet extends StatelessWidget {
  final Function(String) onUnitSelected;

  const _SelectUnitBottomSheet({required this.onUnitSelected});

  final List<String> units = const [
    'None',
    'Piece (pcs)',
    'Box',
    'Dozen (dz)',
    'Hour',
    'Day',
    'Month',
    'Meter (m)',
    'Centimeter (cm)',
    'Kilogram (kg)',
    'Gram (g)',
    'Pound (lb)',
    'Ounce (oz)',
    'Inch (in)',
    'Feet (ft)',
    'Liter (L)',
    'Milliliter (ml)',
    'Service',
    'Project',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.only(top: 16.h),
      child: Column(
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
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  'Select Unit',
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
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: units.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => onUnitSelected(units[index]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    child: AppText(
                      units[index],
                      fontSize: 14,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          InkWell(
            onTap: () {
              // Add custom unit
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              width: double.infinity,
              child: Row(
                children: [
                  const Icon(Icons.add, color: AppColors.mainAppColor, size: 20),
                  SizedBox(width: 8.w),
                  AppText(
                    'Add Custom Unit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainAppColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
