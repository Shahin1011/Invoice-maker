import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';
import 'package:quick_invoice/features/invoices/presentation/pages/new_invoice_screen.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> invoice;
  final int initialTabIndex; // 0: Overview, 1: Preview, 2: History

  const InvoiceDetailScreen({
    super.key,
    required this.invoice,
    this.initialTabIndex = 0,
  });

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> _invoiceData;

  // Payments list for Payment History
  List<Map<String, dynamic>> _payments = [];

  @override
  void initState() {
    super.initState();
    _invoiceData = Map<String, dynamic>.from(widget.invoice);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    // Initial default payment if already has payment or dummy
    if (_invoiceData['payments'] != null && _invoiceData['payments'] is List) {
      _payments = List<Map<String, dynamic>>.from(_invoiceData['payments']);
    } else {
      // Default initial payment like screenshot
      _payments = [
        {
          'amount': 100.0,
          'method': 'Bank Transfer',
          'date': 'Oct 11, 2026',
          'reference': '1246IOUKL54',
          'status': 'Payment Fully Paid',
        }
      ];
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Financial calculations
  double get _totalAmount {
    final amt = _invoiceData['amount'];
    if (amt is num) return amt.toDouble();
    if (amt is String) {
      final clean = amt.replaceAll('\$', '').replaceAll(',', '').trim();
      return double.tryParse(clean) ?? 665.28;
    }
    return 665.28;
  }

  double get _paidAmount {
    double sum = 0.0;
    for (var p in _payments) {
      final a = p['amount'];
      if (a is num) sum += a.toDouble();
    }
    return sum;
  }

  double get _balanceDue {
    final due = _totalAmount - _paidAmount;
    return due > 0 ? due : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final invoiceNo = _invoiceData['invoiceNo'] ?? 'INV-1002345';
    final clientName = _invoiceData['client'] ?? 'Hefzur Rahman';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.mainAppColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 22),
          onPressed: () => Get.back(result: _invoiceData),
        ),
        title: Column(
          children: [
            Text(
              invoiceNo,
              style: TextStyle(
                fontFamily: 'DMSans-Regular',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              clientName,
              style: TextStyle(
                fontFamily: 'DMSans-Regular',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: _showInvoiceMoreOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.mainAppColor,
              indicatorWeight: 3,
              labelColor: AppColors.mainAppColor,
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: TextStyle(
                fontFamily: 'DMSans-Regular',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'DMSans-Regular',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Preview'),
                Tab(text: 'History'),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildPreviewTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. OVERVIEW TAB ---
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invoice Total Card
          _buildTotalCard(),
          SizedBox(height: 16.h),

          // INVOICE DETAILS Section
          _buildInvoiceDetailsSection(),
          SizedBox(height: 16.h),

          // FROM Section
          _buildFromSection(),
          SizedBox(height: 16.h),

          // BILL TO Section
          _buildBillToSection(),
          SizedBox(height: 16.h),

          // ITEMS Section
          _buildItemsSection(),
          SizedBox(height: 16.h),

          // NOTES Section
          _buildNotesSection(),
          SizedBox(height: 16.h),

          // PAYMENT HISTORY Section
          _buildPaymentHistorySection(),
          SizedBox(height: 20.h),

          // Action Buttons: + Record Payment & Mark invoice as fully paid
          _buildActionButtons(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  // Top Total Card
  Widget _buildTotalCard() {
    final badgeText = _invoiceData['badgeText'] ?? 'Due in 34 days';

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
              Text(
                'Invoice Total',
                style: TextStyle(
                  fontFamily: 'DMSans-Regular',
                  fontSize: 13.sp,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontFamily: 'DMSans-Regular',
                    fontSize: 11.sp,
                    color: const Color(0xFF475569),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            '\$${_totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor1,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              // Paid box
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Paid',
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '\$${_paidAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Balance Due box
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Balance Due',
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '\$${_balanceDue.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFD97706),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Section header helper
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'DMSans-Regular',
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: const Color(0xFF64748B),
      ),
    );
  }

  // INVOICE DETAILS Section
  Widget _buildInvoiceDetailsSection() {
    final invoiceNo = _invoiceData['invoiceNo'] ?? 'INV-1002345';
    final date = _invoiceData['date'] ?? 'Oct 8, 2026';
    final dueDate = _invoiceData['dueDate'] ?? 'Nov 6, 2026';

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
          _buildSectionHeader('INVOICE DETAILS'),
          SizedBox(height: 12.h),
          _buildDetailRow('Invoice#', invoiceNo),
          SizedBox(height: 8.h),
          _buildDetailRow('Date', date),
          SizedBox(height: 8.h),
          _buildDetailRow('Due Date', dueDate),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DMSans-Regular',
            fontSize: 13.sp,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'DMSans-Regular',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor1,
          ),
        ),
      ],
    );
  }

  // FROM Section
  Widget _buildFromSection() {
    final biz = _invoiceData['business'];
    final name = (biz != null ? biz['name'] : null) ?? 'ABC Company';
    final email = (biz != null ? biz['email'] : null) ?? 'hefzurrahman@gmail.com';
    final phone = (biz != null ? biz['phone'] : null) ?? '01812347891';
    final address = (biz != null ? biz['address'] : null) ?? 'Bhuysin beri, nowagaon (S)';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('FROM'),
          SizedBox(height: 10.h),
          Text(
            name,
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            email,
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 13.sp,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            phone,
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 13.sp,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            address,
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 13.sp,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // BILL TO Section
  Widget _buildBillToSection() {
    final client = _invoiceData['client'] ?? 'Hefzur Rahman';
    final company = _invoiceData['clientCompany'] ?? 'BAXC Limited Company';
    final email = _invoiceData['clientEmail'] ?? 'baxc@company.gamil.com';
    final phone = _invoiceData['clientPhone'] ?? '01812347891';
    final address = _invoiceData['clientAddress'] ?? 'Bhuysin beri, nowagaon (S)';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('BILL TO'),
          SizedBox(height: 10.h),
          Text(
            client,
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            company,
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 13.sp,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            email,
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 13.sp,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            phone,
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 13.sp,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            address,
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 13.sp,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // ITEMS Section
  Widget _buildItemsSection() {
    final rawItems = _invoiceData['items'];
    List<Map<String, dynamic>> itemsList = [];
    if (rawItems != null && rawItems is List && rawItems.isNotEmpty) {
      itemsList = List<Map<String, dynamic>>.from(rawItems);
    } else {
      // Default sample items matching screenshot
      itemsList = [
        {
          'name': 'Napa',
          'description': 'Paracetamol 500mg',
          'quantity': 2,
          'price': 100.0,
        },
        {
          'name': 'Seclo',
          'description': 'Omeprazole 20mg',
          'quantity': 1,
          'price': 500.0,
        },
      ];
    }

    double subtotal = 0.0;
    for (var it in itemsList) {
      final q = (it['quantity'] as num?)?.toInt() ?? 1;
      final p = (it['price'] as num?)?.toDouble() ?? 0.0;
      subtotal += q * p;
    }

    // Discount & VAT calculation
    double discountRate = 12.0;
    double discountAmount = (subtotal * discountRate) / 100.0;
    double base = subtotal - discountAmount;
    double vatRate = 8.0;
    double vatAmount = (base * vatRate) / 100.0;
    double calculatedTotal = (base > 0 ? base : 0.0) + vatAmount;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('ITEMS (${itemsList.length})'),
          SizedBox(height: 12.h),
          ...itemsList.map((item) {
            final q = (item['quantity'] as num?)?.toInt() ?? 1;
            final p = (item['price'] as num?)?.toDouble() ?? 0.0;
            final itemTotal = q * p;

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] ?? '',
                          style: TextStyle(
                            fontFamily: 'DMSans-Regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor1,
                          ),
                        ),
                        if (item['description'] != null &&
                            item['description'].toString().isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            item['description'],
                            style: TextStyle(
                              fontFamily: 'DMSans-Regular',
                              fontSize: 12.sp,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                        SizedBox(height: 2.h),
                        Text(
                          '$q x \$${p.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'DMSans-Regular',
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${itemTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'DMSans-Regular',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor1,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          SizedBox(height: 12.h),

          // Subtotal
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          SizedBox(height: 8.h),

          // Discount
          _buildSummaryRow(
            'Discount (${discountRate.toStringAsFixed(0)}%)',
            '-\$${discountAmount.toStringAsFixed(2)}',
            valueColor: const Color(0xFF10B981),
          ),
          SizedBox(height: 8.h),

          // VAT
          _buildSummaryRow(
            'VAT (${vatRate.toStringAsFixed(0)}%)',
            '+\$${vatAmount.toStringAsFixed(2)}',
            valueColor: const Color(0xFF64748B),
          ),
          SizedBox(height: 12.h),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'DMSans-Regular',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textColor1,
                ),
              ),
              Text(
                '\$${calculatedTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'DMSans-Regular',
                  fontSize: 16.sp,
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

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DMSans-Regular',
            fontSize: 13.sp,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'DMSans-Regular',
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textColor1,
          ),
        ),
      ],
    );
  }

  // NOTES Section
  Widget _buildNotesSection() {
    final note = _invoiceData['note'] ?? 'Thank you for your business.';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('NOTES'),
          SizedBox(height: 8.h),
          Text(
            note,
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 13.sp,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // PAYMENT HISTORY Section
  Widget _buildPaymentHistorySection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('PAYMENT HISTORY'),
          SizedBox(height: 12.h),
          if (_payments.isEmpty)
            Text(
              'No payments recorded yet.',
              style: TextStyle(
                fontFamily: 'DMSans-Regular',
                fontSize: 13.sp,
                color: const Color(0xFF94A3B8),
              ),
            )
          else
            ..._payments.map((payment) {
              final amt = (payment['amount'] as num?)?.toDouble() ?? 0.0;
              final method = payment['method'] ?? 'Bank Transfer';
              final date = payment['date'] ?? 'Oct 11, 2026';
              final ref = payment['reference'] ?? '';
              final status = payment['status'] ?? 'Payment Fully Paid';

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${amt.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'DMSans-Regular',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor1,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Color(0xFF64748B),
                            size: 20,
                          ),
                          onPressed: () => _showPaymentOptions(payment),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '$method  •  $date',
                      style: TextStyle(
                        fontFamily: 'DMSans-Regular',
                        fontSize: 12.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    if (ref.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        'Ref: $ref',
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                    SizedBox(height: 2.h),
                    Text(
                      status,
                      style: TextStyle(
                        fontFamily: 'DMSans-Regular',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0F766E),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // Action Buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        // + Record Payment Button (Yellow/Gold)
        InkWell(
          onTap: _showRecordPaymentBottomSheet,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFBBF24), // Vibrant yellow/amber
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: AppColors.textColor1, size: 18),
                SizedBox(width: 6.w),
                Text(
                  'Record Payment',
                  style: TextStyle(
                    fontFamily: 'DMSans-Regular',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor1,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),

        // Mark invoice as fully paid Button (Light teal/cyan)
        InkWell(
          onTap: _showMarkAsPaidBottomSheet,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4F1), // Soft mint / teal background
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check, color: Color(0xFF0F766E), size: 18),
                SizedBox(width: 6.w),
                Text(
                  'Mark invoice as fully paid',
                  style: TextStyle(
                    fontFamily: 'DMSans-Regular',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F766E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- 2. PREVIEW TAB ---
  Widget _buildPreviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INVOICE',
                      style: TextStyle(
                        fontFamily: 'DMSans-Regular',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.mainAppColor,
                      ),
                    ),
                    Text(
                      _invoiceData['invoiceNo'] ?? 'INV-1002345',
                      style: TextStyle(
                        fontFamily: 'DMSans-Regular',
                        fontSize: 13.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: _invoiceData['status'] == 'Paid'
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    (_invoiceData['status'] ?? 'Unpaid').toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'DMSans-Regular',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: _invoiceData['status'] == 'Paid'
                          ? const Color(0xFF059669)
                          : const Color(0xFFD97706),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32, color: Color(0xFFE2E8F0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Billed To:',
                        style: TextStyle(
                            fontFamily: 'DMSans-Regular',
                            fontSize: 12.sp,
                            color: const Color(0xFF94A3B8))),
                    SizedBox(height: 4.h),
                    Text(_invoiceData['client'] ?? 'Hefzur Rahman',
                        style: TextStyle(
                            fontFamily: 'DMSans-Regular',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor1)),
                    Text('baxc@company.gamil.com',
                        style: TextStyle(
                            fontFamily: 'DMSans-Regular',
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Invoice Date: ${_invoiceData['date'] ?? 'Oct 8, 2026'}',
                        style: TextStyle(
                            fontFamily: 'DMSans-Regular',
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B))),
                    SizedBox(height: 2.h),
                    Text('Due Date: ${_invoiceData['dueDate'] ?? 'Nov 6, 2026'}',
                        style: TextStyle(
                            fontFamily: 'DMSans-Regular',
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B))),
                  ],
                ),
              ],
            ),
            const Divider(height: 32, color: Color(0xFFE2E8F0)),
            _buildItemsSection(),
          ],
        ),
      ),
    );
  }

  // --- 3. HISTORY TAB ---
  Widget _buildHistoryTab() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildHistoryItem(
          icon: Icons.create_outlined,
          title: 'Invoice Created',
          subtitle: 'Created on Oct 8, 2026',
          time: '10:30 AM',
        ),
        _buildHistoryItem(
          icon: Icons.send_outlined,
          title: 'Invoice Sent',
          subtitle: 'Sent via Email to client',
          time: '10:35 AM',
        ),
        if (_payments.isNotEmpty)
          _buildHistoryItem(
            icon: Icons.payments_outlined,
            title: 'Payment Recorded',
            subtitle: '\$${_paidAmount.toStringAsFixed(2)} via Bank Transfer',
            time: '11:00 AM',
            isSuccess: true,
          ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    bool isSuccess = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isSuccess ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSuccess ? const Color(0xFF10B981) : AppColors.mainAppColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'DMSans-Regular',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor1,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'DMSans-Regular',
                    fontSize: 12.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontFamily: 'DMSans-Regular',
              fontSize: 11.sp,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // --- BOTTOM SHEETS ---

  // 1. Invoice 3-dot More Options Bottom Sheet
  void _showInvoiceMoreOptions() {
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
              _buildBottomSheetOption('Edit Invoice', () {
                Get.back();
                Get.to(() => NewInvoiceScreen(initialInvoice: _invoiceData));
              }),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              _buildBottomSheetOption('Share', () {
                Get.back();
                Get.snackbar('Share', 'Sharing invoice...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.mainAppColor,
                    colorText: Colors.white);
              }),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              _buildBottomSheetOption('Export PDF', () {
                Get.back();
                Get.snackbar('Export PDF', 'Exporting PDF...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.mainAppColor,
                    colorText: Colors.white);
              }),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              _buildBottomSheetOption('Print', () {
                Get.back();
                Get.snackbar('Print', 'Printing invoice...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.mainAppColor,
                    colorText: Colors.white);
              }),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              _buildBottomSheetOption('Duplicate', () {
                Get.back();
                Get.to(() => NewInvoiceScreen(
                      initialInvoice: {
                        ..._invoiceData,
                        'invoiceNo': '${_invoiceData['invoiceNo'] ?? 'INV-1002'}-COPY',
                      },
                    ));
              }),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
              _buildBottomSheetOption('Delete', () {
                Get.back();
                Get.back(result: {'deleted': true, ..._invoiceData});
              }, isDestructive: true),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption(String title, VoidCallback onTap,
      {bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'DMSans-Regular',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDestructive ? const Color(0xFFEF4444) : AppColors.textColor1,
          ),
        ),
      ),
    );
  }

  // 2. Record Payment Bottom Sheet
  void _showRecordPaymentBottomSheet() {
    final amountController = TextEditingController(
      text: _balanceDue > 0 ? _balanceDue.toStringAsFixed(2) : '00.00',
    );
    final dateController = TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
    );
    final paymentMethodController = TextEditingController(text: 'Bank Transfer');
    final referenceController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Record Payment',
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor1,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Amount
                  _buildFieldLabel('Amount *'),
                  _buildPaymentTextField(
                    controller: amountController,
                    hintText: '00.00',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 14.h),

                  // Date of Birth / Payment Date
                  _buildFieldLabel('Date of Birth'),
                  _buildPaymentTextField(
                    controller: dateController,
                    hintText: '10/11/2026',
                    suffixIcon: const Icon(Icons.calendar_today_outlined,
                        size: 18, color: Color(0xFF64748B)),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        dateController.text =
                            DateFormat('MM/dd/yyyy').format(picked);
                      }
                    },
                  ),
                  SizedBox(height: 14.h),

                  // Payment Method
                  _buildFieldLabel('Payment Method'),
                  _buildPaymentTextField(
                    controller: paymentMethodController,
                    hintText: 'Bank Transfer',
                  ),
                  SizedBox(height: 14.h),

                  // Reference
                  _buildFieldLabel('Reference (optional)'),
                  _buildPaymentTextField(
                    controller: referenceController,
                    hintText: 'Transaction ID, receipt #...',
                  ),
                  SizedBox(height: 14.h),

                  // Note
                  _buildFieldLabel('Note (optional)'),
                  _buildPaymentTextField(
                    controller: noteController,
                    hintText: 'Add a note...',
                  ),
                  SizedBox(height: 20.h),

                  // Save Payment Button
                  InkWell(
                    onTap: () {
                      final val = double.tryParse(amountController.text.trim()) ?? 0.0;
                      if (val > 0) {
                        setState(() {
                          _payments.add({
                            'amount': val,
                            'method': paymentMethodController.text.trim().isEmpty
                                ? 'Bank Transfer'
                                : paymentMethodController.text.trim(),
                            'date': DateFormat('MMM dd, yyyy').format(DateTime.now()),
                            'reference': referenceController.text.trim(),
                            'status': _balanceDue - val <= 0
                                ? 'Payment Fully Paid'
                                : 'Partially Paid',
                          });
                          if (_balanceDue <= 0) {
                            _invoiceData['status'] = 'Paid';
                            _invoiceData['badgeText'] = 'Paid';
                            _invoiceData['badgeType'] = 'paid';
                          }
                        });
                      }
                      Get.back();
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Save Payment',
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Cancel Button
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 3. Mark as Paid Bottom Sheet
  void _showMarkAsPaidBottomSheet() {
    final remaining = _balanceDue;
    final amountController = TextEditingController(
      text: remaining.toStringAsFixed(2),
    );
    final dateController = TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
    );
    final paymentMethodController = TextEditingController(text: 'Bank Transfer');
    final referenceController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mark as Paid',
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor1,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Informational banner
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F4F1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      'Remaining balance of \$${remaining.toStringAsFixed(2)} will be recorded as paid.',
                      style: TextStyle(
                        fontFamily: 'DMSans-Regular',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0F766E),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Amount
                  _buildFieldLabel('Amount *'),
                  _buildPaymentTextField(
                    controller: amountController,
                    hintText: remaining.toStringAsFixed(2),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 14.h),

                  // Date
                  _buildFieldLabel('Date of Birth'),
                  _buildPaymentTextField(
                    controller: dateController,
                    hintText: '10/11/2026',
                    suffixIcon: const Icon(Icons.calendar_today_outlined,
                        size: 18, color: Color(0xFF64748B)),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        dateController.text =
                            DateFormat('MM/dd/yyyy').format(picked);
                      }
                    },
                  ),
                  SizedBox(height: 14.h),

                  // Payment Method
                  _buildFieldLabel('Payment Method'),
                  _buildPaymentTextField(
                    controller: paymentMethodController,
                    hintText: 'Bank Transfer',
                  ),
                  SizedBox(height: 14.h),

                  // Reference
                  _buildFieldLabel('Reference (optional)'),
                  _buildPaymentTextField(
                    controller: referenceController,
                    hintText: 'Transaction ID, receipt #...',
                  ),
                  SizedBox(height: 14.h),

                  // Note
                  _buildFieldLabel('Note (optional)'),
                  _buildPaymentTextField(
                    controller: noteController,
                    hintText: 'Add a note...',
                  ),
                  SizedBox(height: 20.h),

                  // Save Payment Button
                  InkWell(
                    onTap: () {
                      final val = double.tryParse(amountController.text.trim()) ?? remaining;
                      setState(() {
                        _payments.add({
                          'amount': val,
                          'method': paymentMethodController.text.trim().isEmpty
                              ? 'Bank Transfer'
                              : paymentMethodController.text.trim(),
                          'date': DateFormat('MMM dd, yyyy').format(DateTime.now()),
                          'reference': referenceController.text.trim(),
                          'status': 'Payment Fully Paid',
                        });
                        _invoiceData['status'] = 'Paid';
                        _invoiceData['badgeText'] = 'Paid';
                        _invoiceData['badgeType'] = 'paid';
                      });
                      Get.back();
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Save Payment',
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Cancel Button
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'DMSans-Regular',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'DMSans-Regular',
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _buildPaymentTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        style: TextStyle(
          fontFamily: 'DMSans-Regular',
          fontSize: 14.sp,
          color: AppColors.textColor1,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'DMSans-Regular',
            fontSize: 14.sp,
            color: const Color(0xFF94A3B8),
          ),
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  void _showPaymentOptions(Map<String, dynamic> payment) {
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
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                title: const Text('Delete Payment', style: TextStyle(color: Color(0xFFEF4444))),
                onTap: () {
                  Get.back();
                  setState(() {
                    _payments.remove(payment);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
