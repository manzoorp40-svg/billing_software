import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../controllers/main_layout_controller.dart';

import '../../../core/services/sync_service.dart';
import '../../../core/utils/date_utils.dart';

class AppHeader extends GetView<MainLayoutController> {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final syncService = Get.find<SyncService>();

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Page Title
          Obx(() => Text(
            controller.pageTitle.value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          )),

          const Spacer(),

          // Quick Actions
          _QuickActionButton(
            icon: Icons.add,
            label: 'New Purchase',
            onTap: () => Get.toNamed('/purchase/form'),
          ),
          _QuickActionButton(
            icon: Icons.receipt_long,
            label: 'New Bill',
            onTap: () => Get.toNamed('/bill/form'),
          ),

          const SizedBox(width: 16),
          const VerticalDivider(width: 1),

          // Sync Status
          Obx(() => _SyncIndicator(
            pendingCount: syncService.pendingCount.value,
            lastSync: syncService.lastSyncTime.value,
            onSync: () => syncService.sync(),
          )),

          const SizedBox(width: 16),

          // Date Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  AppDateUtils.formatDate(DateTime.now().millisecondsSinceEpoch),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // User Menu
          PopupMenuButton<String>(
            offset: const Offset(0, 48),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primary,
                    child: const Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Admin',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  Get.toNamed('/settings/profile');
                  break;
                case 'settings':
                  Get.toNamed('/settings');
                  break;
                case 'logout':
                // Handle logout
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}

class _SyncIndicator extends StatelessWidget {
  final int pendingCount;
  final int lastSync;
  final VoidCallback onSync;

  const _SyncIndicator({
    required this.pendingCount,
    required this.lastSync,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    final hasPending = pendingCount > 0;
    final lastSyncText = lastSync > 0
        ? 'Last sync: ${AppDateUtils.formatRelative(lastSync)}'
        : 'Never synced';

    return InkWell(
      onTap: onSync,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: hasPending
              ? Colors.orange.withOpacity(0.1)
              : Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasPending ? Colors.orange.withOpacity(0.3) : Colors.green.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasPending ? Icons.cloud_off : Icons.cloud_done,
              size: 16,
              color: hasPending ? Colors.orange : Colors.green,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hasPending ? '$pendingCount pending' : 'Synced',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: hasPending ? Colors.orange : Colors.green,
                  ),
                ),
                Text(
                  lastSyncText,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            if (hasPending) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.refresh,
                size: 14,
                color: Colors.orange,
              ),
            ],
          ],
        ),
      ),
    );
  }
}