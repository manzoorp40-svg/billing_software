import 'package:flutter/material.dart';

import 'package:super_market/app/core/theme/app_colors.dart';
import 'package:super_market/app/core/theme/app_sizes.dart';

class AppCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final Widget? action;
  final Widget child;

  const AppCard({
    super.key,
    required this.title,
    this.icon,
    this.iconColor,
    this.action,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (action != null) action!,
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: child,
          ),
        ],
      ),
    );
  }
}
