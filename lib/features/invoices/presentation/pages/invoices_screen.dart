import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_app_button.dart';
import 'package:quick_invoice/core/base/custom_text_field.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';
import 'package:quick_invoice/features/invoices/presentation/pages/invoice_detail_screen.dart';
import 'package:quick_invoice/features/invoices/presentation/pages/new_invoice_screen.dart';
import 'package:quick_invoice/features/invoices/presentation/widgets/invoice_card.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  // Available filter options
  final List<String> filterTabs = ['All', 'Paid', 'Unpaid', 'Draft'];
  String selectedFilter = 'All';

  String selectedPeriod = 'This Year';
  final List<String> periodOptions = [
    'All Time',
    'This Month',
    'Last Month',
    'This Year',
    'Last Year',
  ];

  // Invoices list
  final List<Map<String, dynamic>> invoices = [
    {
      'invoiceNo': 'INV-1002',
      'client': 'Hefzur Rahman',
      'date': 'Sep 20, 2026',
      'amount': '\$66.00',
      'status': 'Unpaid',
      'badgeText': 'Due in 24 days',
      'badgeType': 'due',
    },
    {
      'invoiceNo': 'INV-1002',
      'client': 'Hefzur Rahman',
      'date': 'Sep 20, 2026',
      'amount': '\$66.00',
      'status': 'Unpaid',
      'badgeText': 'Overdue 9 days',
      'badgeType': 'overdue',
    },
    {
      'invoiceNo': 'INV-1002',
      'client': 'Hefzur Rahman',
      'date': 'Sep 20, 2026',
      'amount': '\$66.00',
      'status': 'Paid',
      'badgeText': 'Paid',
      'badgeType': 'paid',
    },
    {
      'invoiceNo': 'INV-1002',
      'client': 'Hefzur Rahman',
      'date': 'Sep 20, 2026',
      'amount': '\$66.00',
      'status': 'Draft',
      'badgeText': 'Draft',
      'badgeType': 'draft',
    },
    {
      'invoiceNo': 'INV-1002',
      'client': 'Hefzur Rahman',
      'date': 'Sep 20, 2026',
      'amount': '\$66.00',
      'status': 'Draft',
      'badgeText': 'Draft',
      'badgeType': 'draft',
    },
    {
      'invoiceNo': 'INV-1002',
      'client': 'Hefzur Rahman',
      'date': 'Sep 20, 2026',
      'amount': '\$66.00',
      'status': 'Draft',
      'badgeText': 'Draft',
      'badgeType': 'draft',
    },
    {
      'invoiceNo': 'INV-1002',
      'client': 'Hefzur Rahman',
      'date': 'Sep 20, 2026',
      'amount': '\$66.00',
      'status': 'Draft',
      'badgeText': 'Draft',
      'badgeType': 'draft',
    },
  ];

  String searchQuery = '';
  bool isSelectionMode = false;
  Set<int> selectedIndices = {};

  void _toggleSelectionMode() {
    setState(() {
      isSelectionMode = !isSelectionMode;
      selectedIndices.clear();
    });
  }

  void _selectAll(List<Map<String, dynamic>> filteredList) {
    setState(() {
      if (selectedIndices.length == filteredList.length) {
        selectedIndices.clear();
      } else {
        selectedIndices = Set.from(Iterable.generate(filteredList.length));
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

  List<Map<String, dynamic>> get filteredInvoices {
    return invoices.where((invoice) {
      // Filter status
      if (selectedFilter != 'All' &&
          (invoice['status'] as String).toLowerCase() !=
              selectedFilter.toLowerCase()) {
        return false;
      }
      // Search query
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final no = (invoice['invoiceNo'] as String).toLowerCase();
        final client = (invoice['client'] as String).toLowerCase();
        if (!no.contains(query) && !client.contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = filteredInvoices;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchAndFilters(),
          if (invoices.isNotEmpty) _buildFilterSummary(list.length),
          Expanded(
            child: list.isEmpty ? _buildEmptyState() : _buildInvoicesList(list),
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
                  onTap: () => _selectAll(filteredInvoices),
                  child: AppText(
                    selectedIndices.length == filteredInvoices.length
                        ? 'Deselect All'
                        : 'Select All',
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
                  'Invoices',
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
                      onPressed: _openNewInvoiceScreen,
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Column(
        children: [
          CustomTextField(
            hintText: 'Search invoices...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
            fieldBorderRadius: 24,
            fieldBorderColor: const Color(0xFFE2E8F0),
            onChanged: (val) {
              setState(() {
                searchQuery = val.trim();
              });
            },
          ),
          SizedBox(height: 12.h),
          Row(
            children: filterTabs.map((tab) {
              final isSelected = selectedFilter == tab;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = tab;
                        selectedIndices.clear();
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.mainAppColor : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.mainAppColor
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: AppText(
                        tab,
                        color: isSelected ? Colors.white : const Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSummary(int count) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _showPeriodPickerSheet,
            child: Row(
              children: [
                AppText(
                  selectedPeriod,
                  fontSize: 13,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(width: 4.w),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),
          AppText(
            '$count invoices',
            fontSize: 13,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ],
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
            Image.asset(
              'assets/images/emptyInvoiceImg.png',
              height: 120.w,
            ),
            SizedBox(height: 8.h),
            AppText(
              'No invoices yet',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor1,
            ),
            SizedBox(height: 4.h),
            AppText(
              'Create your first invoice and manage\neverything in one place.',
              fontSize: 14,
              color: const Color(0xFF64748B),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 14.h),
            CustomAppButton(
              text: 'Create New Invoice',
              textColor: AppColors.textColor1,
              backgroundColor: AppColors.secondaryColor,
              width: 200.w,
              onTap: _openNewInvoiceScreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoicesList(List<Map<String, dynamic>> list) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: list.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
      itemBuilder: (context, index) {
        final invoice = list[index];
        final isSelected = selectedIndices.contains(index);

        return InvoiceCard(
          invoice: invoice,
          isSelectionMode: isSelectionMode,
          isSelected: isSelected,
          onTap: () {
            if (isSelectionMode) {
              _toggleSelection(index);
            } else {
              _openInvoiceDetails(invoice);
            }
          },
        );
      },
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
          GestureDetector(
            onTap: _deleteSelectedInvoices,
            child: AppText(
              'Delete (${selectedIndices.length})',
              color: const Color(0xFFEF4444),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _openNewInvoiceScreen() async {
    final result = await Get.to(() => const NewInvoiceScreen());
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        invoices.insert(0, result);
      });
    }
  }

  void _openInvoiceDetails(Map<String, dynamic> invoice) async {
    final result = await Get.to(() => InvoiceDetailScreen(invoice: invoice));
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (result['deleted'] == true) {
          invoices.removeWhere((i) => i['invoiceNo'] == invoice['invoiceNo']);
        } else {
          final index = invoices.indexWhere((i) => i['invoiceNo'] == invoice['invoiceNo']);
          if (index != -1) {
            invoices[index] = result;
          }
        }
      });
    }
  }

  void _deleteSelectedInvoices() {
    if (selectedIndices.isEmpty) return;
    setState(() {
      final sortedIndices = selectedIndices.toList()..sort((a, b) => b.compareTo(a));
      for (var index in sortedIndices) {
        if (index < invoices.length) {
          invoices.removeAt(index);
        }
      }
      selectedIndices.clear();
      isSelectionMode = false;
    });
  }

  void _showPeriodPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              AppText(
                'Select Period',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor1,
              ),
              SizedBox(height: 8.h),
              ...periodOptions.map((period) => ListTile(
                    title: Text(period),
                    trailing: selectedPeriod == period
                        ? const Icon(Icons.check, color: AppColors.mainAppColor)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedPeriod = period;
                      });
                      Get.back();
                    },
                  )),
            ],
          ),
        );
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
              SizedBox(height: 16.h),
              AppText(
                'Export Invoices',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor1,
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.mainAppColor),
                title: const Text('Export as PDF'),
                onTap: () => Get.back(),
              ),
              ListTile(
                leading: const Icon(Icons.table_chart_outlined, color: AppColors.mainAppColor),
                title: const Text('Export as CSV / Excel'),
                onTap: () => Get.back(),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }
}

