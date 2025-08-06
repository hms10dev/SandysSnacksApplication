// lib/widgets/common/app_sidebar.dart
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/constants.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;

  const AppSidebar({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(right: BorderSide(color: AppColors.neutral200)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 32),
          _buildNavMenu(context),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Text(
          AppConstants.appIcon,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 8),
        Text(
          AppConstants.appName,
          style: AppTextStyles.heading3.copyWith(
            fontFamily: 'Cal Sans',
          ),
        ),
      ],
    );
  }

  Widget _buildNavMenu(BuildContext context) {
    final navItems = [
      {'icon': '🏠', 'label': 'Dashboard', 'route': '/dashboard'},
      {'icon': '🍪', 'label': 'Current Snacks', 'route': '/snacks'},
      {'icon': '📝', 'label': 'Make a Request', 'route': '/request'},
      {'icon': '🗳️', 'label': 'Vote on Themes', 'route': '/vote'},
      {'icon': '📚', 'label': 'Past Collections', 'route': '/history'},
      {'icon': '💳', 'label': 'Manage Donation', 'route': '/subscription'},
      {'icon': '⚙️', 'label': 'Settings', 'route': '/settings'},
    ];

    return Column(
      children: navItems
          .map((item) => _buildNavItem(
                context,
                item['icon']!,
                item['label']!,
                item['route']!,
              ))
          .toList(),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String icon, String label, String route) {
    final isActive = currentRoute == route;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle navigation
            if (route == '/dashboard') {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else if (route == '/subscription') {
              // Already on subscription page
            }
            // Add other route handlers as needed
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.warmCream : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  child: Center(
                    child: Text(
                      icon,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: isActive ? AppColors.accent : AppColors.neutral600,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
