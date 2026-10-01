import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/localization/localization_controller.dart';
import 'core/route/route.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetBuilder<LocalizationController>(
            init: LocalizationController(),
            builder: (localizationController) {
              return GetMaterialApp(
                transitionDuration: const Duration(milliseconds: 400),
                defaultTransition: Transition.rightToLeft,
                debugShowCheckedModeBanner: false,
                locale: localizationController.locale,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                initialRoute: AppRoutes.splashScreen,
                navigatorKey: Get.key,
                getPages: AppRoutes.routes,
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  appBarTheme: const AppBarTheme(
                    toolbarHeight: 65,
                    elevation: 0,
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.black),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
