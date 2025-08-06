import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/admin_service.dart';
import '../../utils/colors.dart';
import '../cards/admin_stat_card.dart';

class AdminStatsGrid extends StatelessWidget {
  const AdminStatsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminService>(
      builder: (context, adminService, child) {
        final stats = adminService.getSubscriptionStats();

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 1200
                ? 4
                : constraints.maxWidth > 800
                    ? 2
                    : 1;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.3,
              children: [
                AdminStatCard(
                  icon: Icons.attach_money,
                  iconColor: AppColors.success,
                  value: '\$${stats['monthlyRevenue']}',
                  label: 'January Revenue',
                  change: '↗️ +\$15 from last month',
                  changePositive: true,
                  borderColor: AppColors.success,
                ),
                AdminStatCard(
                  icon: Icons.people,
                  iconColor: const Color(0xFF3B82F6),
                  value: '${stats['activeSubscribers']}',
                  label: 'Active Subscribers',
                  change: '↗️ +2 new this month',
                  changePositive: true,
                  borderColor: const Color(0xFF3B82F6),
                ),
                AdminStatCard(
                  icon: Icons.schedule,
                  iconColor: AppColors.warning,
                  value: '${stats['overdueSubscribers']}',
                  label: 'Pending Donations',
                  change: '💭 Need gentle reminders',
                  changePositive: false,
                  borderColor: AppColors.warning,
                ),
                AdminStatCard(
                  icon: Icons.note_add,
                  iconColor: AppColors.accent,
                  value: '5',
                  label: 'New Requests',
                  change: '✨ Lots of chocolate lovers!',
                  changePositive: true,
                  borderColor: AppColors.accent,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
