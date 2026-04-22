import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'app/core/constants/app_constants.dart';
import 'app/data/providers/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Database (singleton)
  await Get.putAsync<DatabaseProvider>(() async {
    final db = DatabaseProvider();
    return await db.init();
  }, permanent: true);

  // Initialize window manager for desktop
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(AppConstants.defaultWindowWidth, AppConstants.defaultWindowHeight),
    minimumSize: Size(AppConstants.minWindowWidth, AppConstants.minWindowHeight),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: AppConstants.appName,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ConstructionBillingApp());
}