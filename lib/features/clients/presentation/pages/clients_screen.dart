import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quick_invoice/core/base/appText.dart';
import 'package:quick_invoice/core/base/custom_app_button.dart';
import 'package:quick_invoice/core/base/custom_text_field.dart';
import 'package:quick_invoice/core/utils/app_colors.dart';
import 'package:quick_invoice/features/clients/presentation/pages/client_details_screen.dart';

import 'package:quick_invoice/features/clients/presentation/widgets/add_client_bottom_sheet.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  // Mock data for clients
  final List<Map<String, dynamic>> clients = [
    {
      'name': 'Shahin Alam',
      'invoices': 5,
      'amount': '\$200.00',
    },
    {
      'name': 'Tamim Ahmed',
      'invoices': 2,
      'amount': '\$100.00',
    },
    {
      'name': 'Hefzur Rahman',
      'invoices': 3,
      'amount': '\$200.00',
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
      if (selectedIndices.length == clients.length) {
        selectedIndices.clear();
      } else {
        selectedIndices = Set.from(Iterable.generate(clients.length));
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
            child: clients.isEmpty ? _buildEmptyState() : _buildClientsList(),
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
                    'Select All',
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
                  'Clients',
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
                      onPressed: _showAddClientSheet,
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
        hintText: 'Search clients...',
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
            Image.asset('assets/images/emptyClientImg.png', height: 120.w),
            SizedBox(height: 24.h),
            AppText(
              'No clients yet',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textColor1,
            ),
            SizedBox(height: 8.h),
            AppText(
              'Save clients once and reuse them whenever\nyou create an invoice.',
              fontSize: 14,
              color: const Color(0xFF64748B),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            CustomAppButton(
              text: 'Add Client',
              textColor: AppColors.textColor1,
              backgroundColor: AppColors.secondaryColor,
              width: 160.w,
              onTap: _showAddClientSheet,
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
          AppText(
            'Export',
            color: AppColors.mainAppColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
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

  Widget _buildClientsList() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: clients.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
      itemBuilder: (context, index) {
        final client = clients[index];
        return ClientCard(
          client: client,
          isSelectionMode: isSelectionMode,
          isSelected: selectedIndices.contains(index),
          onTap: () {
            if (isSelectionMode) {
              _toggleSelection(index);
            } else {
              Get.to(() => ClientDetailsScreen(client: client));
            }
          },
        );
      },
    );
  }

  void _showAddClientSheet() {
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
            setState(() {
              clients.add(newClient);
            });
          },
        );
      },
    );
  }
}

class ClientCard extends StatelessWidget {
  final Map<String, dynamic> client;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;

  const ClientCard({
    super.key,
    required this.client,
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
                color: Color(0xFFE7F4F6),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: AppText(
                client['name'][0].toUpperCase(),
                color: AppColors.mainAppColor,
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
                    client['name'],
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor1,
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    '${client['invoices']} invoices',
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
            AppText(
              client['amount'],
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
