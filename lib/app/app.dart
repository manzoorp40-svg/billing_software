import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_market/app/core/bindings/initial_binding.dart';
import 'package:super_market/app/core/theme/app_theme.dart';
import 'package:super_market/app/routes/app_pages.dart';
import 'package:super_market/app/routes/app_routes.dart';

class ConstructionBillingApp extends StatelessWidget {
  const ConstructionBillingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Construction Billing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.main,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}