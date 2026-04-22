import 'package:flutter/material.dart';

import 'package:super_market/app/core/theme/app_colors.dart';
import 'package:super_market/app/core/theme/app_sizes.dart';

class AppDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int? sortColumnIndex;
  final bool sortAscending;
  final Function(int, bool)? onSort;
  final bool showCheckboxColumn;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.showCheckboxColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortAscending,
          showCheckboxColumn: showCheckboxColumn,
          headingRowColor: WidgetStateProperty.all(AppColors.surface),
          dataRowColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return AppColors.surface.withOpacity(0.5);
            }
            return null;
          }),
          columns: columns.map((column) {
            return DataColumn(
              label: column.label,
              numeric: column.numeric,
              onSort: onSort != null
                  ? (columnIndex, ascending) => onSort!(columnIndex, ascending)
                  : null,
            );
          }).toList(),
          rows: rows,
        ),
      ),
    );
  }
}
