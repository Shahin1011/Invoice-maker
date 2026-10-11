import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_app_button.dart';
import 'package:quick_invoice/core/base/custom_text_field.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';

class AddItemBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? initialItem;
  final ValueChanged<Map<String, dynamic>>? onItemSaved;

  const AddItemBottomSheet({
    super.key,
    this.initialItem,
    this.onItemSaved,
  });

  @override
  State<AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descController;
  late String selectedUnit;

  @override
  void initState() {
    super.initState();
    final it = widget.initialItem;
    _nameController = TextEditingController(text: it?['name'] ?? '');
    if (it != null && it['price'] != null) {
      final p = (it['price'] as num).toDouble();
      _priceController = TextEditingController(
        text: p.toStringAsFixed(p.truncateToDouble() == p ? 0 : 2),
      );
    } else {
      _priceController = TextEditingController();
    }
    _descController = TextEditingController(text: it?['description'] ?? '');
    selectedUnit = (it != null && it['unit'] != null && (it['unit'] as String).isNotEmpty)
        ? it['unit']
        : 'Select unit';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showSelectUnitSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SelectUnitBottomSheet(
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

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final unit = selectedUnit == 'Select unit' ? 'Box' : selectedUnit;
    final itemData = {
      ...widget.initialItem ?? {},
      'name': name,
      'unit': unit,
      'price': price,
      'amount': '\$${price.toStringAsFixed(2)}',
      'description': _descController.text.trim(),
    };

    if (widget.onItemSaved != null) {
      widget.onItemSaved!(itemData);
    }
    Get.back(result: itemData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      widget.initialItem != null ? 'Edit Item' : 'Add Item',
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
                SizedBox(height: 16.h),
                _buildLabel('Item Name *'),
                CustomTextField(
                  textEditingController: _nameController,
                  hintText: 'Enter your items name',
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Unit Price *'),
                          CustomTextField(
                            textEditingController: _priceController,
                            hintText: '0.00',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
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
                CustomTextField(
                  textEditingController: _descController,
                  hintText: 'Describe the service or product...',
                  maxLines: 3,
                ),
                SizedBox(height: 24.h),
                CustomAppButton(
                  text: widget.initialItem != null ? 'Save Changes' : 'Add Item',
                  textColor: AppColors.textColor1,
                  backgroundColor: AppColors.secondaryColor,
                  onTap: _save,
                ),
                SizedBox(height: 12.h),
                CustomAppButton(
                  text: 'Cancel',
                  textColor: const Color(0xFF64748B),
                  backgroundColor: Colors.white,
                  borderColor: const Color(0xFFE2E8F0),
                  onTap: () => Get.back(),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
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

class SelectUnitBottomSheet extends StatefulWidget {
  final Function(String) onUnitSelected;

  const SelectUnitBottomSheet({super.key, required this.onUnitSelected});

  @override
  State<SelectUnitBottomSheet> createState() => _SelectUnitBottomSheetState();
}

class _SelectUnitBottomSheetState extends State<SelectUnitBottomSheet> {
  bool _isAddingCustom = false;
  final TextEditingController _customUnitController = TextEditingController();

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
  void dispose() {
    _customUnitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          padding: EdgeInsets.only(top: 16.h),
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
              Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  shrinkWrap: true,
                  itemCount: units.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => widget.onUnitSelected(units[index]),
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
              if (_isAddingCustom)
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        'Custom Unit',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor1,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        textEditingController: _customUnitController,
                        hintText: 'e.g. Bundle, Pack, Set...',
                        fieldBorderColor: const Color(0xFFE2E8F0),
                        fieldBorderRadius: 8,
                      ),
                      SizedBox(height: 16.h),
                      CustomAppButton(
                        text: 'Save & Use',
                        textColor: AppColors.textColor1,
                        backgroundColor: AppColors.secondaryColor,
                        borderRadius: 8,
                        onTap: () {
                          final val = _customUnitController.text.trim();
                          if (val.isNotEmpty) {
                            widget.onUnitSelected(val);
                          }
                        },
                      ),
                      SizedBox(height: 12.h),
                      CustomAppButton(
                        text: 'Cancel',
                        textColor: AppColors.textColor1,
                        backgroundColor: Colors.white,
                        borderColor: const Color(0xFFE2E8F0),
                        borderRadius: 8,
                        onTap: () {
                          setState(() {
                            _isAddingCustom = false;
                            _customUnitController.clear();
                          });
                        },
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                )
              else
                InkWell(
                  onTap: () {
                    setState(() {
                      _isAddingCustom = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    margin: EdgeInsets.only(bottom: 16.h),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
        ),
      ),
    );
  }
}
