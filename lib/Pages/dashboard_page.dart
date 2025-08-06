import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandys_snacks_app/utils/colors.dart';
import 'package:sandys_snacks_app/widgets/cards/subscription_status_card.dart';
import '../services/auth_service.dart';
import '../utils/text_styles.dart';
import '../utils/constants.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(authService.userName),
                const SizedBox(height: 32),
                SubscriptionStatusCard(
                  subscription: authService.subscription,
                  onPayPressed: () => _handlePayment(context, authService),
                  onPausePressed: () => _handlePause(context, authService),
                ),
                const SizedBox(height: 40),
                _buildUpcomingFeature('Current snacks coming soon! 🍪'),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('${AppConstants.appIcon} ${AppConstants.appName}'),
      backgroundColor: AppColors.cardBackground,
      foregroundColor: AppColors.primary,
      elevation: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () =>
              Provider.of<AuthService>(context, listen: false).signOut(),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(String? userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, ${userName ?? 'User'}! 👋',
          style: AppTextStyles.heading1,
        ),
        const SizedBox(height: 8),
        Text(
          'Here\'s what\'s happening with your snack subscription',
          style: AppTextStyles.body,
        ),
      ],
    );
  }

  Widget _buildUpcomingFeature(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Text(
        message,
        style: AppTextStyles.body.copyWith(
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // YOUR business logic handlers
  void _handlePayment(BuildContext context, AuthService authService) {
    // For now, simulate payment - later connect to actual payment system
    authService.processPayment().then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment processed! Welcome to the snack squad! 🎉'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  void _handlePause(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pause Subscription?'),
        content: const Text(
            'Are you sure you want to pause your subscription? You can reactivate anytime.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              authService.pauseSubscription();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Subscription paused')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: const Text('Pause'),
          ),
        ],
      ),
    );
  }
}
