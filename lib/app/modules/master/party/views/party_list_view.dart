import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:super_market/app/core/theme/app_colors.dart';
import 'package:super_market/app/core/theme/app_sizes.dart';
import 'package:super_market/app/core/utils/currency_formatter.dart';
import 'package:super_market/app/widgets/common/app_status_badge.dart';
import 'package:super_market/app/widgets/common/app_search_field.dart';
import 'package:super_market/app/widgets/common/app_filter_chips.dart';
import 'package:super_market/app/widgets/cards/stat_summary_card.dart';
import 'package:super_market/app/widgets/common/app_data_table.dart';

import '../../../../core/constants/enums.dart';
import '../controllers/party_list_controller.dart';

class PartyListView extends GetView<PartyListController> {
  const PartyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with Stats
          Container(
            padding: const EdgeInsets.all(AppSizes.padding),
            color: Colors.white,
            child: Column(
              children: [
                // Top Bar
                Row(
                  children: [
                    Obx(() => AppSearchField(
                      onChanged: controller.setSearch,
                      hintText: 'Search parties...',
                      initialValue: controller.searchQuery.value,
                    )),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: controller.addNewParty,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Party'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Filter Chips
                Obx(() => AppFilterChips(
                  filters: [
                    FilterChipData(
                      label: 'All (${controller.totalCount.value})',
                      selected: controller.selectedPartyType.value == null,
                      onSelected: () => controller.setPartyTypeFilter(null),
                    ),
                    FilterChipData(
                      label: 'Suppliers (${controller.supplierCount.value})',
                      selected: controller.selectedPartyType.value == PartyType.supplier,
                      onSelected: () => controller.setPartyTypeFilter(PartyType.supplier),
                    ),
                    FilterChipData(
                      label: 'Clients (${controller.clientCount.value})',
                      selected: controller.selectedPartyType.value == PartyType.client,
                      onSelected: () => controller.setPartyTypeFilter(PartyType.client),
                    ),
                    FilterChipData(
                      label: 'Subcontractors (${controller.subcontractorCount.value})',
                      selected: controller.selectedPartyType.value == PartyType.subcontractor,
                      onSelected: () => controller.setPartyTypeFilter(PartyType.subcontractor),
                    ),
                  ],
                )),
              ],
            ),
          ),

          // Stats Cards
          Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Row(
              children: [
                Expanded(
                  child: StatSummaryCard(
                    title: 'Receivables',
                    value: CurrencyFormatter.formatCompact(controller.totalReceivables.value),
                    icon: Icons.arrow_downward,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatSummaryCard(
                    title: 'Payables',
                    value: CurrencyFormatter.formatCompact(controller.totalPayables.value.abs()),
                    icon: Icons.arrow_upward,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // Data Table
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                AppSizes.padding,
                0,
                AppSizes.padding,
                AppSizes.padding,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredParties.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No parties found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: controller.addNewParty,
                          icon: const Icon(Icons.add),
                          label: const Text('Add your first party'),
                        ),
                      ],
                    ),
                  );
                }

                return AppDataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('GSTIN')),
                    DataColumn(label: Text('Balance'), numeric: true),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: controller.filteredParties.map((party) {
                    return DataRow(
                      onSelectChanged: (_) => controller.viewPartyDetails(party),
                      cells: [
                        DataCell(Text(
                          party.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        )),
                        DataCell(AppStatusBadge(
                          label: PartyType.fromIndex(party.partyType).displayName,
                          color: _getPartyTypeColor(party.partyType),
                        )),
                        DataCell(Text(party.phone ?? '-')),
                        DataCell(Text(party.gstin ?? '-')),
                        DataCell(Text(
                          CurrencyFormatter.format(party.balance),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: party.balance >= 0 ? Colors.green : Colors.red,
                          ),
                        )),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility, size: 20),
                              onPressed: () => controller.viewPartyDetails(party),
                              tooltip: 'View',
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => controller.viewPartyDetails(party),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                              onPressed: () => controller.deleteParty(party.localId),
                              tooltip: 'Delete',
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                  sortColumnIndex: controller.sortBy.value == 'name' ? 0 : null,
                  sortAscending: controller.sortAsc.value,
                  onSort: (columnIndex, ascending) {
                    controller.setSort('name');
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPartyTypeColor(int partyType) {
    switch (partyType) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}