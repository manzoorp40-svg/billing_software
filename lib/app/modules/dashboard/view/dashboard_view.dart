
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../master/party/controllers/dashboard_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_utils.dart';
import '../../../widgets/common/app_card.dart';
import '../../../widgets/common/app_status_badge.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _WelcomeSection(),
                const SizedBox(height: 24),

                // Summary Cards Row 1
                Row(
                  children: [
                    Expanded(child: _SiteSummaryCard()),
                    const SizedBox(width: 16),
                    Expanded(child: _WorkerSummaryCard()),
                    const SizedBox(width: 16),
                    Expanded(child: _PartySummaryCard()),
                  ],
                ),
                const SizedBox(height: 16),

                // Summary Cards Row 2
                Row(
                  children: [
                    Expanded(child: _PurchaseSummaryCard()),
                    const SizedBox(width: 16),
                    Expanded(child: _BillingSummaryCard()),
                    const SizedBox(width: 16),
                    Expanded(child: _StockSummaryCard()),
                  ],
                ),
                const SizedBox(height: 24),

                // Alerts & Recent Activity
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _LowStockAlertCard()),
                    const SizedBox(width: 16),
                    Expanded(flex: 3, child: _RecentTransactionsCard()),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Here\'s what\'s happening with your construction business today.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SiteSummaryCard extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Sites',
      icon: Icons.work_outline,
      iconColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Obx(() => Text(
                '${controller.activeSites.value}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              )),
              const SizedBox(width: 8),
              const Text(
                'Active',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Row(
            children: [
              _MiniStat(
                label: 'Total',
                value: '${controller.totalSites.value}',
              ),
              const SizedBox(width: 16),
              _MiniStat(
                label: 'Completed',
                value: '${controller.completedSites.value}',
              ),
            ],
          )),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => controller.navigateTo('/sites'),
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('View All'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerSummaryCard extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Workers',
      icon: Icons.engineering_outlined,
      iconColor: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Obx(() => Text(
                '${controller.workersPresentToday.value}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              )),
              const SizedBox(width: 8),
              const Text(
                'Present',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => _MiniStat(
            label: 'Total Workers',
            value: '${controller.totalWorkers.value}',
          )),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => controller.navigateTo('/labor/attendance'),
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('Mark Attendance'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartySummaryCard extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Parties',
      icon: Icons.people_outline,
      iconColor: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.arrow_downward, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    CurrencyFormatter.formatCompact(controller.totalReceivables.value),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const Text(
                'Receivable',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.arrow_upward, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    CurrencyFormatter.formatCompact(controller.totalPayables.value.abs()),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const Text(
                'Payable',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          )),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => controller.navigateTo('/parties'),
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('View Parties'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _PurchaseSummaryCard extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Purchases (This Month)',
      icon: Icons.shopping_cart_outlined,
      iconColor: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CurrencyFormatter.formatCompact(controller.purchasesAmountThisMonth.value),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                '${controller.purchasesThisMonth.value} purchases',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          )),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => controller.navigateTo('/purchases'),
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('View All'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillingSummaryCard extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Bills (This Month)',
      icon: Icons.receipt_long_outlined,
      iconColor: Colors.teal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CurrencyFormatter.formatCompact(controller.billsAmountThisMonth.value),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              Text(
                '${controller.billsThisMonth.value} bills',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          )),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => controller.navigateTo('/bills'),
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('View All'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockSummaryCard extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Stock Value',
      icon: Icons.inventory_2_outlined,
      iconColor: Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
            CurrencyFormatter.formatCompact(controller.totalStockValue.value),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          )),
          Obx(() => Text(
            '${controller.lowStockMaterials.length} items low on stock',
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          )),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => controller.navigateTo('/materials'),
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('View Stock'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _LowStockAlertCard extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Low Stock Alerts',
      icon: Icons.warning_amber_outlined,
      iconColor: Colors.red,
      action: TextButton(
        onPressed: () => controller.navigateTo('/materials?filter=lowstock'),
        child: const Text('View All'),
      ),
      child: Obx(() {
        final items = controller.lowStockMaterials.take(5).toList();
        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'All stock levels are healthy',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        return Column(
          children: items.map((material) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.red.withOpacity(0.1),
              child: const Icon(Icons.inventory_2, color: Colors.red, size: 20),
            ),
            title: Text(material.name),
            subtitle: Text(
              'Stock: ${material.currentStock.toStringAsFixed(2)} | Alert at: ${material.alertQuantity.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: AppStatusBadge(
              label: material.currentStock <= 0 ? 'Out of Stock' : 'Low Stock',
              color: material.currentStock <= 0 ? Colors.red : Colors.orange,
            ),
          )).toList(),
        );
      }),
    );
  }
}

class _RecentTransactionsCard extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Recent Activity',
      icon: Icons.history,
      iconColor: AppColors.primary,
      action: TextButton(
        onPressed: () => controller.navigateTo('/reports'),
        child: const Text('View All'),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Purchases'),
                Tab(text: 'Bills'),
              ],
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
            ),
            SizedBox(
              height: 250,
              child: TabBarView(
                children: [
                  _RecentPurchaseList(),
                  _RecentBillList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentPurchaseList extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final purchases = controller.recentPurchases;
      if (purchases.isEmpty) {
        return const Center(
          child: Text(
            'No recent purchases',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        );
      }

      return ListView.builder(
        itemCount: purchases.length,
        itemBuilder: (context, index) {
          final purchase = purchases[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: const Icon(Icons.shopping_cart, color: Colors.blue, size: 20),
            ),
            title: Text(purchase.purchaseNumber),
            subtitle: Text(
              '${purchase.supplierName ?? 'Unknown'} | ${AppDateUtils.formatRelative(purchase.purchaseDate)}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Text(
              CurrencyFormatter.format(purchase.totalAmount),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      );
    });
  }
}

class _RecentBillList extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bills = controller.recentBills;
      if (bills.isEmpty) {
        return const Center(
          child: Text(
            'No recent bills',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        );
      }

      return ListView.builder(
        itemCount: bills.length,
        itemBuilder: (context, index) {
          final bill = bills[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.teal.withOpacity(0.1),
              child: const Icon(Icons.receipt_long, color: Colors.teal, size: 20),
            ),
            title: Text(bill.billNumber),
            subtitle: Text(
              '${bill.siteName ?? 'Unknown'} | ${AppDateUtils.formatRelative(bill.billDate)}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Text(
              CurrencyFormatter.format(bill.totalAmount),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      );
    });
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}