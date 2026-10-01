import 'package:get/get.dart';
import 'package:quick_invoice/features/clients/presentation/pages/clients_screen.dart';
import 'package:quick_invoice/features/invoices/presentation/pages/invoices_screen.dart';
import 'package:quick_invoice/features/more/presentation/pages/more_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../bottom_nav/bottom_nav.dart';


class AppRoutes {


  static const String bottomNavScreen = "/bottom_nav";
  static const String splashScreen = "/splash_screen";
  static const String homeScreen = "/home_screen";
  static const String invoicesScreen = "/invoices_screen";
  static const String clientsScreen = "/clients_screen";
  static const String itemsScreen = "/items_screen";
  static const String moreScreen = "/more_screen";


  static List<GetPage> routes = [
    GetPage(name: bottomNavScreen, page: () => BottomNavScreen()),
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: invoicesScreen, page: () => InvoicesScreen()),
    GetPage(name: clientsScreen, page: () => ClientsScreen()),
    GetPage(name: moreScreen, page: () => MoreScreen()),

  ];
}