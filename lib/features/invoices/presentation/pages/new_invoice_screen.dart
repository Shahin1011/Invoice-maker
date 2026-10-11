import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_app_button.dart';
import 'package:quick_invoice/core/base/custom_text_field.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';
import 'package:quick_invoice/features/clients/presentation/pages/client_details_screen.dart';
import 'package:quick_invoice/features/invoices/presentation/pages/invoice_detail_screen.dart';
import 'package:quick_invoice/features/invoices/presentation/widgets/add_invoice_item_sheet.dart';
import 'package:quick_invoice/features/invoices/presentation/widgets/edit_invoice_number_sheet.dart';
import 'package:quick_invoice/features/invoices/presentation/widgets/invoice_item_card.dart';
import 'package:quick_invoice/features/invoices/presentation/widgets/select_business_sheet.dart';
import 'package:quick_invoice/features/invoices/presentation/widgets/select_client_sheet.dart';
import 'package:quick_invoice/features/items/presentation/widgets/add_item_bottom_sheet.dart';

class NewInvoiceScreen extends StatefulWidget {
  final Map<String, dynamic>? initialInvoice;

  const NewInvoiceScreen({super.key, this.initialInvoice});

  @override
  State<NewInvoiceScreen> createState() => _NewInvoiceScreenState();
}

class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  // Selected Business
  Map<String, dynamic>? selectedBusiness = {
    'name': 'ABC Company',
    'owner': 'Owner Name',
  };

  // Available Businesses Mock
  final List<Map<String, dynamic>> businesses = [
    {'name': 'Medicine Pharmacy', 'owner': 'Owner Name'},
    {'name': 'ABC Company', 'owner': 'Owner Name'},
  ];

  // Invoice Details
  final TextEditingController invoiceNumberController =
      TextEditingController(text: 'INV-1001');
  DateTime invoiceDate = DateTime.now();
  String selectedPaymentTerm = '30 Days';
  DateTime invoiceDueDate = DateTime.now().add(const Duration(days: 30));
  final TextEditingController poNumberController = TextEditingController();

  final List<String> paymentTermOptions = [
    'Due on Receipt',
    '7 Days',
    '14 Days',
    '21 Days',
    '30 Days',
    '45 Days',
    '60 Days',
    '90 Days',
    'Custom',
  ];

  // Selected Client
  Map<String, dynamic>? selectedClient;

  // Available Clients Mock
  final List<Map<String, dynamic>> availableClients = [
    {'name': 'Hefzur Rahman', 'company': 'Company name', 'email': 'hefzur@gmail.com'},
    {'name': 'Tamim Ahmed', 'company': 'Tamim Tech Ltd', 'email': 'tamim@gmail.com'},
    {'name': 'Shahin Alam', 'company': 'Quick Systems', 'email': 'shahin@gmail.com'},
  ];

  // Available Items Mock
  final List<Map<String, dynamic>> availableItems = [
    {
      'name': 'Mouse',
      'unit': 'Set unit',
      'price': 10.0,
      'description': 'Electronic Device',
    },
    {
      'name': 'Keyboards',
      'unit': 'Set unit',
      'price': 12.0,
      'description': 'Electronic device',
    },
    {'name': 'Monas 10mg', 'unit': 'Box', 'price': 50.0, 'description': 'Medical item'},
    {'name': 'Seclo 20mg', 'unit': 'Box', 'price': 50.0, 'description': 'Medical item'},
    {'name': 'Rolac 10mg', 'unit': 'Box', 'price': 50.0, 'description': 'Medical item'},
    {'name': 'Napa Extra', 'unit': 'Box', 'price': 25.0, 'description': 'Medical item'},
  ];

  // Selected Items on this invoice
  List<Map<String, dynamic>> selectedItems = [];

  // Financials
  bool isDiscountActive = true;
  bool isDiscountPercentage = true;
  final TextEditingController discountController =
      TextEditingController(text: '10');
  bool isTaxActive = false;
  final TextEditingController taxNameController = TextEditingController();
  final TextEditingController taxRateController =
      TextEditingController(text: '0');
  final TextEditingController noteController =
      TextEditingController(text: 'Thank you for your business.');

  @override
  void initState() {
    super.initState();
    invoiceDueDate = invoiceDate.add(const Duration(days: 30));
    if (widget.initialInvoice != null) {
      final inv = widget.initialInvoice!;
      invoiceNumberController.text = inv['invoiceNo'] ?? 'INV-1001';
      if (inv['client'] != null) {
        selectedClient = {
          'name': inv['client'],
          'company': 'Company name',
        };
      }
    } else {
      selectedItems = [
        {
          'name': 'Mouse',
          'unit': 'Set unit',
          'price': 10.0,
          'quantity': 1,
          'description': 'Electronic Device',
        },
        {
          'name': 'Keyboards',
          'unit': 'Set unit',
          'price': 12.0,
          'quantity': 1,
          'description': 'Electronic device',
        },
      ];
    }
  }

  void _onPaymentTermSelected(String term) {
    setState(() {
      selectedPaymentTerm = term;
      if (term == 'Due on Receipt') {
        invoiceDueDate = invoiceDate;
      } else if (term.contains('Days')) {
        final days = int.tryParse(term.replaceAll('Days', '').trim()) ?? 0;
        invoiceDueDate = invoiceDate.add(Duration(days: days));
      } else if (term == 'Custom') {
        _pickDueDate();
      }
    });
  }

  void _pickDueDate() {
    _pickDate(
      currentDate: invoiceDueDate,
      onDatePicked: (date) {
        setState(() {
          invoiceDueDate = date;
          selectedPaymentTerm = 'Custom';
        });
      },
    );
  }

  @override
  void dispose() {
    invoiceNumberController.dispose();
    poNumberController.dispose();
    noteController.dispose();
    discountController.dispose();
    taxNameController.dispose();
    taxRateController.dispose();
    super.dispose();
  }

  double get discountRate {
    if (!isDiscountActive) return 0.0;
    return double.tryParse(discountController.text.trim()) ?? 0.0;
  }

  double get taxRate {
    if (!isTaxActive) return 0.0;
    return double.tryParse(taxRateController.text.trim()) ?? 0.0;
  }

  double get subtotal {
    double total = 0.0;
    for (var item in selectedItems) {
      final qty = (item['quantity'] as num?)?.toInt() ?? 1;
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      total += qty * price;
    }
    return total;
  }

  double get calculatedDiscount {
    if (!isDiscountActive || discountRate <= 0) return 0.0;
    if (isDiscountPercentage) {
      return (subtotal * discountRate) / 100.0;
    }
    return discountRate;
  }

  double get calculatedTax {
    if (!isTaxActive || taxRate <= 0) return 0.0;
    final base = subtotal - calculatedDiscount;
    if (base <= 0) return 0.0;
    return (base * taxRate) / 100.0;
  }

  double get grandTotal {
    final base = subtotal - calculatedDiscount;
    final total = (base > 0 ? base : 0.0) + calculatedTax;
    return total > 0 ? total : 0.0;
  }

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
          'New Invoice',
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBusinessSection(),
            SizedBox(height: 12.h),
            _buildInvoiceDetailsSection(),
            SizedBox(height: 12.h),
            _buildClientSection(),
            SizedBox(height: 12.h),
            _buildItemsSection(),
            SizedBox(height: 12.h),
            _buildCalculationsSection(),
            SizedBox(height: 12.h),
            _buildNoteSection(),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomAppButton(
                text: 'Save Invoice',
                textColor: AppColors.textColor1,
                backgroundColor: AppColors.secondaryColor,
                onTap: () {
                  _saveInvoice(status: 'Unpaid');
                },
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  // --- 1. BUSINESS SECTION ---
  Widget _buildBusinessSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('BUSINESS'),
          SizedBox(height: 8.h),
          if (selectedBusiness == null)
            _buildDashedActionButton(
              icon: Icons.add,
              text: 'Select Business',
              onTap: _showSelectBusinessSheet,
            )
          else
            InkWell(
              onTap: _showSelectBusinessSheet,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
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
                        (selectedBusiness!['name'] as String)[0].toUpperCase(),
                        color: AppColors.mainAppColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            selectedBusiness!['name'] ?? '',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.textColor1,
                          ),
                          SizedBox(height: 2.h),
                          AppText(
                            selectedBusiness!['owner'] ?? '',
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- 2. INVOICE DETAILS SECTION ---
  Widget _buildInvoiceDetailsSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('INVOICE DETAILS'),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildDetailsTile(
                  label: 'Invoice Number',
                  trailingText: invoiceNumberController.text,
                  hasArrow: true,
                  onTap: _editInvoiceNumber,
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                _buildDetailsTile(
                  label: 'Invoice Date',
                  trailingText: DateFormat('MM/dd/yyyy').format(invoiceDate),
                  trailingIcon: Icons.calendar_today_outlined,
                  onTap: () => _pickDate(
                    currentDate: invoiceDate,
                    onDatePicked: (date) {
                      setState(() {
                        invoiceDate = date;
                        if (selectedPaymentTerm == 'Due on Receipt') {
                          invoiceDueDate = date;
                        } else if (selectedPaymentTerm.contains('Days')) {
                          final days = int.tryParse(selectedPaymentTerm.replaceAll('Days', '').trim()) ?? 0;
                          invoiceDueDate = date.add(Duration(days: days));
                        }
                      });
                    },
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                _buildPaymentTermsSection(),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                _buildDetailsTile(
                  label: 'Due Date',
                  trailingText: DateFormat('MMM d, yyyy').format(invoiceDueDate),
                  onTap: _pickDueDate,
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                  child: Row(
                    children: [
                      AppText(
                        'PO Number',
                        fontSize: 14,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: TextField(
                          controller: poNumberController,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontFamily: 'DMSans-Regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor1,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter PO number',
                            hintStyle: TextStyle(
                              fontFamily: 'DMSans-Regular',
                              fontSize: 14.sp,
                              color: const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. CLIENT SECTION ---
  Widget _buildClientSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('CLIENT'),
              if (selectedClient != null)
                GestureDetector(
                  onTap: _showSelectClientSheet,
                  child: AppText(
                    'Change',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainAppColor,
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          if (selectedClient == null)
            _buildDashedActionButton(
              icon: Icons.add,
              text: 'Select or Add Client',
              onTap: _showSelectClientSheet,
            )
          else
            InkWell(
              onTap: () {
                if (selectedClient != null) {
                  Get.to(() => ClientDetailsScreen(client: selectedClient!));
                }
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
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
                        (selectedClient!['name'] as String)[0].toUpperCase(),
                        color: AppColors.mainAppColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            selectedClient!['name'] ?? '',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.textColor1,
                          ),
                          SizedBox(height: 2.h),
                          AppText(
                            selectedClient!['company'] ?? 'Client company',
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- 4. ITEMS SECTION ---
  Widget _buildItemsSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildSectionHeader(
                selectedItems.isEmpty ? 'ITEMS' : 'ITEMS (${selectedItems.length})',
              ),
            ],
          ),
          if (selectedItems.isNotEmpty) ...[
            SizedBox(height: 12.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedItems.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final item = selectedItems[index];
                return InvoiceItemCard(
                  item: item,
                  onQuantityDecreased: () {
                    final qty = (item['quantity'] as num?)?.toInt() ?? 1;
                    if (qty > 1) {
                      setState(() {
                        item['quantity'] = qty - 1;
                      });
                    }
                  },
                  onQuantityIncreased: () {
                    final qty = (item['quantity'] as num?)?.toInt() ?? 1;
                    setState(() {
                      item['quantity'] = qty + 1;
                    });
                  },
                  onRemove: () {
                    setState(() {
                      selectedItems.removeAt(index);
                    });
                  },
                  onUnitTap: () => _pickUnitForItem(item),
                  onEditNoteTap: () => _showEditItemSheet(item),
                );
              },
            ),
          ],
          SizedBox(height: 12.h),
          _buildDashedActionButton(
            icon: Icons.add,
            text: 'Add Item',
            onTap: _showAddItemSheet,
          ),
        ],
      ),
    );
  }

  void _pickUnitForItem(Map<String, dynamic> item) {
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
              item['unit'] = unit;
            });
            Get.back();
          },
        );
      },
    );
  }


  void _showEditItemSheet(Map<String, dynamic> item) {
    showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return AddItemBottomSheet(
          initialItem: item,
          onItemSaved: (updatedItem) {
            setState(() {
              item['name'] = updatedItem['name'];
              item['price'] = (updatedItem['price'] as num).toDouble();
              item['unit'] = updatedItem['unit'];
              item['description'] = updatedItem['description'];
            });
          },
        );
      },
    );
  }

  // --- 5. CALCULATIONS SECTION (SUBTOTAL, DISCOUNT, TAX, TOTAL) ---
  Widget _buildCalculationsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtotal row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  fontFamily: 'DMSans-Regular',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'DMSans-Regular',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor1,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Discount row
          if (isDiscountActive)
            Row(
              children: [
                // '%' toggle chip
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDiscountPercentage = true;
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isDiscountPercentage
                          ? AppColors.mainAppColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: isDiscountPercentage
                          ? null
                          : Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      '%',
                      style: TextStyle(
                        fontFamily: 'DMSans-Regular',
                        fontSize: 13.sp,
                        fontWeight: isDiscountPercentage
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isDiscountPercentage
                            ? Colors.white
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),

                // 'Fixed' toggle chip
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDiscountPercentage = false;
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: !isDiscountPercentage
                          ? AppColors.mainAppColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: !isDiscountPercentage
                          ? null
                          : Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      'Fixed',
                      style: TextStyle(
                        fontFamily: 'DMSans-Regular',
                        fontSize: 13.sp,
                        fontWeight: !isDiscountPercentage
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: !isDiscountPercentage
                            ? Colors.white
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                // Amount input field pill
                Container(
                  width: 64.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Center(
                    child: TextField(
                      controller: discountController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'DMSans-Regular',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const Spacer(),

                // Close / Delete icon
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDiscountActive = false;
                      discountController.clear();
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            )
          else
            GestureDetector(
              onTap: () {
                setState(() {
                  isDiscountActive = true;
                  if (discountController.text.isEmpty) {
                    discountController.text = '10';
                  }
                });
              },
              child: Text(
                '+ Add Discount',
                style: TextStyle(
                  fontFamily: 'DMSans-Regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mainAppColor,
                ),
              ),
            ),
          SizedBox(height: 12.h),

          // Tax row
          if (!isTaxActive)
            GestureDetector(
              onTap: () {
                setState(() {
                  isTaxActive = true;
                  if (taxRateController.text.isEmpty) {
                    taxRateController.text = '0';
                  }
                });
              },
              child: Text(
                '+ Add Tax',
                style: TextStyle(
                  fontFamily: 'DMSans-Regular',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mainAppColor,
                ),
              ),
            )
          else
            Row(
              children: [
                // Tax name input pill
                Expanded(
                  child: Container(
                    height: 34.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Center(
                      child: TextField(
                        controller: taxNameController,
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Tax name (VAT)',
                          hintStyle: TextStyle(
                            fontFamily: 'DMSans-Regular',
                            fontSize: 13.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                // Tax rate input pill
                Container(
                  width: 48.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Center(
                    child: TextField(
                      controller: taxRateController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'DMSans-Regular',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (val) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                SizedBox(width: 6.w),

                // '%' label
                Text(
                  '%',
                  style: TextStyle(
                    fontFamily: 'DMSans-Regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(width: 6.w),

                // Close / Delete icon
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isTaxActive = false;
                      taxRateController.text = '0';
                      taxNameController.clear();
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 14.h),

          // Divider
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          SizedBox(height: 14.h),

          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'DMSans-Regular',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor1,
                ),
              ),
              Text(
                '\$${grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'DMSans-Regular',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 6. NOTE SECTION ---
  Widget _buildNoteSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('NOTE'),
          SizedBox(height: 8.h),
          CustomTextField(
            textEditingController: noteController,
            maxLines: 4,
            hintText: 'Enter notes or instructions...',
            fieldBorderRadius: 12,
            fieldBorderColor: const Color(0xFFE2E8F0),
          ),
        ],
      ),
    );
  }

  // Helper Section Header
  Widget _buildSectionHeader(String title) {
    return AppText(
      title,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF64748B),
    );
  }

  // Helper Dashed Action Button
  Widget _buildDashedActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF9ABFC8),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.mainAppColor, size: 18),
            SizedBox(width: 8.w),
            AppText(
              text,
              color: AppColors.mainAppColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Details Tile
  Widget _buildDetailsTile({
    required String label,
    required String trailingText,
    IconData? trailingIcon,
    bool hasArrow = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              label,
              fontSize: 14,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w400,
            ),
            Row(
              children: [
                if (trailingText.isNotEmpty)
                  AppText(
                    trailingText,
                    fontSize: 14,
                    color: AppColors.textColor1,
                    fontWeight: FontWeight.w500,
                  ),
                if (trailingIcon != null) ...[
                  SizedBox(width: 8.w),
                  Icon(trailingIcon, size: 16, color: const Color(0xFF64748B)),
                ],
                if (hasArrow) ...[
                  SizedBox(width: 6.w),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- ACTIONS & SHEETS ---

  void _showSelectBusinessSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SelectBusinessSheet(
          businesses: businesses,
          selectedBusiness: selectedBusiness,
          onBusinessSelected: (biz) {
            setState(() {
              selectedBusiness = biz;
            });
          },
          onBusinessAdded: (newBiz) {
            setState(() {
              businesses.add(newBiz);
              selectedBusiness = newBiz;
            });
          },
        );
      },
    );
  }

  void _showSelectClientSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SelectClientSheet(
          clients: availableClients,
          selectedClient: selectedClient,
          onClientSelected: (client) {
            setState(() {
              selectedClient = client;
            });
          },
          onClientAdded: (newClient) {
            setState(() {
              availableClients.add(newClient);
              selectedClient = newClient;
            });
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
        return AddInvoiceItemSheet(
          availableItems: availableItems,
          selectedItems: selectedItems,
          onItemToggled: (item) {
            setState(() {
              final existingIndex =
                  selectedItems.indexWhere((si) => si['name'] == item['name']);
              if (existingIndex != -1) {
                final currentQty =
                    (selectedItems[existingIndex]['quantity'] as num?)?.toInt() ?? 1;
                selectedItems[existingIndex]['quantity'] = currentQty + 1;
              } else {
                selectedItems.add({
                  'name': item['name'],
                  'quantity': 1,
                  'price': (item['price'] as num).toDouble(),
                  'unit': item['unit'] ?? 'Set unit',
                  'description': item['description'] ?? 'Electronic Device',
                });
              }
            });
          },
          onItemCreated: (newItem) {
            setState(() {
              availableItems.add(newItem);
              selectedItems.add({
                'name': newItem['name'],
                'quantity': 1,
                'price': (newItem['price'] as num).toDouble(),
                'unit': newItem['unit'] ?? 'Set unit',
                'description': newItem['description'] ?? 'Electronic Device',
              });
            });
          },
        );
      },
    );
  }

  void _editInvoiceNumber() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return EditInvoiceNumberSheet(
          currentNumber: invoiceNumberController.text,
          onSaved: (newNumber) {
            setState(() {
              invoiceNumberController.text = newNumber;
            });
          },
        );
      },
    );
  }



  Widget _buildPaymentTermsSection() {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AppText(
              'Payment Terms',
              fontSize: 14,
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: paymentTermOptions.map((term) {
              final isSelected = selectedPaymentTerm == term;
              return GestureDetector(
                onTap: () => _onPaymentTermSelected(term),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.mainAppColor : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.mainAppColor
                          : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    term,
                    style: TextStyle(
                      fontFamily: 'DMSans-Regular',
                      fontSize: 13.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : const Color(0xFF475569),
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



  Future<void> _pickDate({
    required DateTime currentDate,
    required Function(DateTime) onDatePicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.mainAppColor,
              onPrimary: Colors.white,
              onSurface: AppColors.textColor1,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDatePicked(picked);
    }
  }

  void _showMoreOptions() {
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
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () {
                  Get.back();
                  final currentInvoiceData = {
                    'invoiceNo': invoiceNumberController.text.trim().isEmpty
                        ? 'INV-1002345'
                        : invoiceNumberController.text.trim(),
                    'client': selectedClient != null ? selectedClient!['name'] : 'Hefzur Rahman',
                    'clientCompany': selectedClient != null ? (selectedClient!['company'] ?? 'BAXC Limited Company') : 'BAXC Limited Company',
                    'date': DateFormat('MMM dd, yyyy').format(invoiceDate),
                    'dueDate': DateFormat('MMM dd, yyyy').format(invoiceDueDate),
                    'amount': '\$${grandTotal.toStringAsFixed(2)}',
                    'status': 'Unpaid',
                    'badgeText': 'Due in 34 days',
                    'badgeType': 'due',
                    'items': selectedItems,
                    'business': selectedBusiness,
                    'note': noteController.text.trim(),
                  };
                  Get.to(() => InvoiceDetailScreen(
                        invoice: currentInvoiceData,
                        initialTabIndex: 0,
                      ));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  alignment: Alignment.center,
                  child: Text(
                    'Invoice Preview',
                    style: TextStyle(
                      fontFamily: 'DMSans-Regular',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor1,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              InkWell(
                onTap: () {
                  Get.back();
                  _saveInvoice(status: 'Unpaid');
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  alignment: Alignment.center,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'DMSans-Regular',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor1,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              InkWell(
                onTap: () {
                  Get.back();
                  _saveInvoice(status: 'Draft');
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  alignment: Alignment.center,
                  child: Text(
                    'Save as Draft',
                    style: TextStyle(
                      fontFamily: 'DMSans-Regular',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  void _saveInvoice({required String status}) {
    final invoiceData = {
      'invoiceNo': invoiceNumberController.text.trim().isEmpty
          ? 'INV-1001'
          : invoiceNumberController.text.trim(),
      'client': selectedClient != null ? selectedClient!['name'] : 'Unknown Client',
      'date': DateFormat('MMM dd, yyyy').format(invoiceDate),
      'amount': '\$${grandTotal.toStringAsFixed(2)}',
      'status': status,
      'badgeText': status == 'Draft'
          ? 'Draft'
          : (status == 'Paid' ? 'Paid' : 'Due in 24 days'),
      'badgeType': status == 'Draft'
          ? 'draft'
          : (status == 'Paid' ? 'paid' : 'due'),
      'items': selectedItems,
      'note': noteController.text.trim(),
    };

    Get.back(result: invoiceData);
  }
}
