import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/admin_service.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';
import 'package:sandys_snacks_app/models/models.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminService = Provider.of<AdminService>(context, listen: false);
      adminService.loadAllUsers();
      adminService.loadPendingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Consumer<AdminService>(
        builder: (context, adminService, child) {
          if (adminService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageHeader(),
                const SizedBox(height: 32),
                _buildStatsOverview(adminService),
                const SizedBox(height: 40),
                _buildUsersList(adminService),
                const SizedBox(height: 40),
                _buildQuickActions(adminService),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('${AppConstants.appIcon} Admin Dashboard'),
      backgroundColor: AppColors.cardBackground,
      foregroundColor: AppColors.primary,
      elevation: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            final adminService =
                Provider.of<AdminService>(context, listen: false);
            adminService.loadAllUsers();
            adminService.loadPendingRequests();
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Provider.of<AuthService>(context, listen: false).signOut();
          },
        ),
      ],
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome, Sandy! 👑', style: AppTextStyles.heading1),
        const SizedBox(height: 8),
        Text(
          'Here\'s your snack empire overview',
          style: AppTextStyles.body,
        ),
      ],
    );
  }

  Widget _buildStatsOverview(AdminService adminService) {
    final stats = adminService.getSubscriptionStats();

    return Row(
      children: [
        Expanded(
            child: _buildStatCard(
          'Active Subscribers',
          '${stats['activeSubscribers']}',
          AppColors.success,
          Icons.people,
        )),
        const SizedBox(width: 16),
        Expanded(
            child: _buildStatCard(
          'Monthly Revenue',
          '\$${stats['monthlyRevenue']}',
          AppColors.accent,
          Icons.attach_money,
        )),
        const SizedBox(width: 16),
        Expanded(
            child: _buildStatCard(
          'Overdue Payments',
          '${stats['overdueSubscribers']}',
          AppColors.warning,
          Icons.warning,
        )),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(value, style: AppTextStyles.heading2.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildUsersList(AdminService adminService) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Subscription Status', style: AppTextStyles.heading3),
          ),
          ...adminService.allUsers
              .map((user) => _buildUserTile(user, adminService)),
        ],
      ),
    );
  }

  Widget _buildUserTile(AppUser user, AdminService adminService) {
    final statusColor = _getStatusColor(user.subscription.status);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor,
        child: Text(user.name.substring(0, 1).toUpperCase()),
      ),
      title: Text(user.name),
      subtitle: Text(user.subscription.statusMessage),
      trailing: PopupMenuButton<SubscriptionStatus>(
        onSelected: (status) {
          adminService.updateUserSubscriptionStatus(user.id, status);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: SubscriptionStatus.active,
            child: Text('Mark Active'),
          ),
          const PopupMenuItem(
            value: SubscriptionStatus.overdue,
            child: Text('Mark Overdue'),
          ),
          const PopupMenuItem(
            value: SubscriptionStatus.paused,
            child: Text('Mark Paused'),
          ),
          const PopupMenuItem(
            value: SubscriptionStatus.inactive,
            child: Text('Mark Inactive'),
          ),
        ],
        child: Icon(Icons.more_vert, color: AppColors.neutral600),
      ),
    );
  }

  Widget _buildQuickActions(AdminService adminService) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton.icon(
          onPressed: () => _showAddSnackDialog(),
          icon: const Icon(Icons.add),
          label: const Text('Add Snacks'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
        ),
        ElevatedButton.icon(
          onPressed: () => _showNotificationDialog(adminService),
          icon: const Icon(Icons.notifications),
          label: const Text('Send Notification'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
        ),
        ElevatedButton.icon(
          onPressed: () => _viewRequests(adminService),
          icon: const Icon(Icons.request_page),
          label: Text('Requests (${adminService.pendingRequests.length})'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
        ),
      ],
    );
  }

  Color _getStatusColor(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return AppColors.success;
      case SubscriptionStatus.overdue:
        return AppColors.warning;
      case SubscriptionStatus.paused:
        return AppColors.inactive;
      case SubscriptionStatus.inactive:
        return AppColors.neutral600;
    }
  }

  void _showAddSnackDialog() {
    // TODO: Implement snack upload dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Snack upload coming soon!')),
    );
  }

  void _showNotificationDialog(AdminService adminService) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Notification'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'New snacks have arrived! 🍪',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                adminService
                    .sendNotificationToSubscribers(controller.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification sent!')),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _viewRequests(AdminService adminService) {
    // TODO: Navigate to requests page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Requests page coming soon!')),
    );
  }
}
