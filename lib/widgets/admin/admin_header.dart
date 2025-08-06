import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/admin_service.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../common/user_avatar.dart';

class AdminHeader extends StatefulWidget {
  const AdminHeader({Key? key}) : super(key: key);

  @override
  State<AdminHeader> createState() => _AdminHeaderState();
}

class _AdminHeaderState extends State<AdminHeader> {
  String selectedMonth = 'January 2024';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.neutral200)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Consumer<AdminService>(
        builder: (context, adminService, child) {
          final stats = adminService.getSubscriptionStats();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLeftSection(stats),
              _buildUserMenu(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeftSection(Map<String, dynamic> stats) {
    return Row(
      children: [
        _buildMonthSelector(),
        const SizedBox(width: 24),
        if (MediaQuery.of(context).size.width > 768) ...[
          _buildQuickStat('\$${stats['monthlyRevenue']}', 'This Month'),
          const SizedBox(width: 24),
          _buildQuickStat('${stats['activeSubscribers']}', 'Active'),
          const SizedBox(width: 24),
          _buildQuickStat('${stats['overdueSubscribers']}', 'Pending'),
        ],
      ],
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.neutral600,
        border: Border.all(color: AppColors.neutral200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedMonth,
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w500),
          items: ['January 2024', 'December 2023', 'November 2023']
              .map(
                  (month) => DropdownMenuItem(value: month, child: Text(month)))
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => selectedMonth = value);
          },
        ),
      ),
    );
  }

  Widget _buildQuickStat(String value, String label) {
    return Row(
      children: [
        Text(value,
            style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600, color: AppColors.primary)),
        const SizedBox(width: 8),
        Text(label,
            style: AppTextStyles.caption.copyWith(color: AppColors.neutral600)),
      ],
    );
  }

  Widget _buildUserMenu() {
    return Row(
      children: [
        _buildNotificationBell(),
        const SizedBox(width: 16),
        const UserAvatar(name: 'Sandy', size: 40),
      ],
    );
  }

  Widget _buildNotificationBell() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.neutral600,
        border: Border.all(color: AppColors.neutral200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          const Center(child: Icon(Icons.notifications_outlined, size: 20)),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}
