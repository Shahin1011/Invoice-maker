import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quick_invoice/features/clients/presentation/pages/clients_screen.dart';
import 'package:quick_invoice/features/invoices/presentation/pages/invoices_screen.dart';
import 'package:quick_invoice/features/items/presentation/pages/items_screen.dart';
import 'package:quick_invoice/features/more/presentation/pages/more_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_icons.dart';



class BottomNavScreen extends StatefulWidget {
  final int initialIndex;
  const BottomNavScreen({super.key, this.initialIndex = 0});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void navigationItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomeScreen(),
    InvoicesScreen(),
    ClientsScreen(),
    ItemsScreen(),
    MoreScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE7F4F6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          border: const Border(
            top: BorderSide(color: Color(0xFFE3E6F0), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          selectedItemColor: AppColors.mainAppColor,
          unselectedItemColor: AppColors.foundationColor,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'DMSans-Regular',
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'DMSans-Regular',
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          showSelectedLabels: true,
          backgroundColor: Colors.transparent,
          onTap: navigationItemTap,
          items: [
            _navItem(AppIcons.homeU,  AppIcons.homeS, "Home", 0),
            _navItem(AppIcons.invoiceU,        AppIcons.invoiceS,  "Invoices",  1),
            _navItem(AppIcons.clientU,     AppIcons.clientS, "Clients", 2),
            _navItem(AppIcons.itemsU,      AppIcons.itemsS,  "Items",  3),
            _navItem(AppIcons.moreU,      AppIcons.moreS,  "More",  4),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(
      String unselected,
      String selected,
      String label,
      int index,
      ) {
    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(
        unselected,
        height: 22,
        width: 22,
        colorFilter: const ColorFilter.mode(
          AppColors.foundationColor,
          BlendMode.srcIn,
        ),
      ),
      activeIcon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: SvgPicture.asset(
          selected,
          key: ValueKey<String>(selected),
          height: 23,
          width: 23,
          colorFilter: const ColorFilter.mode(
            AppColors.mainAppColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}