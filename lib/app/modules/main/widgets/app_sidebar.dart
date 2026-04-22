import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../controllers/main_layout_controller.dart';

class AppSidebar extends GetView<MainLayoutController> {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: AppColors.sidebarBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo / Company Name
          Container(
            height: 80,
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.construction,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Construction',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Billing',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24, height: 1),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _NavItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  index: 0,
                ),
                const _NavSection(title: 'MASTER DATA'),
                _NavItem(
                  icon: Icons.people_outline,
                  label: 'Parties',
                  index: 1,
                ),
                _NavItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Materials',
                  index: 2,
                ),
                _NavItem(
                  icon: Icons.work_outline,
                  label: 'Sites',
                  index: 3,
                ),
                _NavItem(
                  icon: Icons.engineering_outlined,
                  label: 'Workers',
                  index: 4,
                ),
                _NavItem(
                  icon: Icons.straighten_outlined,
                  label: 'Units',
                  index: 5,
                ),
                const _NavSection(title: 'TRANSACTIONS'),
                _NavItem(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Purchases',
                  index: 6,
                ),
                _NavItem(
                  icon: Icons.local_shipping_outlined,
                  label: 'Material Allocation',
                  index: 7,
                ),
                _NavItem(
                  icon: Icons.people_alt_outlined,
                  label: 'Labor',
                  index: 8,
                ),
                _NavItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Billing',
                  index: 9,
                ),
                const _NavSection(title: 'REPORTS'),
                _NavItem(
                  icon: Icons.analytics_outlined,
                  label: 'Reports',
                  index: 10,
                ),
                _NavItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Ledger',
                  index: 11,
                ),
                const _NavSection(title: 'SYSTEM'),
                _NavItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  index: 12,
                ),
              ],
            ),
          ),

          // Sync Status
          Container(
            padding: const EdgeInsets.all(AppSizes.padding),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white24),
              ),
            ),
            child: Obx(() => Row(
              children: [
                Icon(
                  controller.isSynced.value
                      ? Icons.cloud_done
                      : Icons.cloud_off,
                  color: controller.isSynced.value
                      ? Colors.greenAccent
                      : Colors.orangeAccent,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.isSynced.value
                        ? 'All synced'
                        : '${controller.pendingCount.value} pending',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

class _NavSection extends StatelessWidget {
  final String title;

  const _NavSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _NavItem extends GetView<MainLayoutController> {
  final IconData icon;
  final String label;
  final int index;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.setPage(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.transparent,
              border: Border(
                left: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}