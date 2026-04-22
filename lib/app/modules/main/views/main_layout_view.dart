import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_layout_controller.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/app_header.dart';

class MainLayoutView extends GetView<MainLayoutController> {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          const AppSidebar(),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                const AppHeader(),

                // Page Content
                Expanded(
                  child: Obx(() => IndexedStack(
                    index: controller.currentIndex.value,
                    children: controller.pages,
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}