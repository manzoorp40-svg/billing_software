import 'package:flutter/material.dart';

import 'package:super_market/app/core/theme/app_colors.dart';
import 'package:super_market/app/core/theme/app_sizes.dart';

class FilterChipData {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  FilterChipData({
    required this.label,
    required this.selected,
    required this.onSelected,
  });
}

class AppFilterChips extends StatelessWidget {
  final List<FilterChipData> filters;

  const AppFilterChips({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.map((filter) {
        return FilterChip(
          label: Text(filter.label),
          selected: filter.selected,
          onSelected: (_) => filter.onSelected(),
          selectedColor: AppColors.primary.withOpacity(0.2),
          checkmarkColor: AppColors.primary,
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: filter.selected ? AppColors.primary : Colors.grey.shade300,
            ),
          ),
        );
      }).toList(),
    );
  }
}
