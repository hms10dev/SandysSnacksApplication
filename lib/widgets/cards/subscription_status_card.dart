// lib/widgets/cards/subscription_status_card.dart

import 'package:flutter/material.dart';
import 'package:sandys_snacks_app/models/subscription_model.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class SubscriptionStatusCard extends StatelessWidget {
  final UserSubscription? subscription;
  final VoidCallback onPayPressed;
  final VoidCallback onPausePressed;

  const SubscriptionStatusCard({
    super.key,
    required this.subscription,
    required this.onPayPressed,
    required this.onPausePressed,
  });

  @override
  Widget build(BuildContext context) {
    if (subscription == null) {
      return _buildLoadingCard();
    }

    final isActive = subscription!.status == SubscriptionStatus.active;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.neutral200),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: isActive ? AppColors.success : AppColors.warning,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildStats(),
                const SizedBox(height: 32),
                _buildActions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border.all(color: AppColors.neutral200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text('Loading subscription data...'),
    );
  }

  Widget _buildHeader() {
    final isActive = subscription!.status == SubscriptionStatus.active;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isActive
                    ? 'Subscription Active'
                    : 'Subscription ${subscription!.status.toString().split('.').last}',
                style: AppTextStyles.heading2,
              ),
              const SizedBox(height: 8),
              Text(
                _getStatusDescription(),
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.success.withOpacity(0.1)
                : AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            subscription!.status.toString().split('.').last.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: isActive ? AppColors.success : AppColors.warning,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(child: _buildStatItem('Total Contributed', '\$35')),
        Expanded(child: _buildStatItem('Months Active', '7')),
        Expanded(child: _buildStatItem('Next Due Date', 'Feb 1')),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPausePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neutral100,
              foregroundColor: AppColors.neutral800,
              elevation: 0,
              side: BorderSide(color: AppColors.neutral200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('⏸️ Pause'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: onPayPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('💸 Pay Now'),
          ),
        ),
      ],
    );
  }

  String _getStatusDescription() {
    switch (subscription!.status) {
      case SubscriptionStatus.active:
        return 'You\'re all caught up! Your next \$5 donation is due on February 1st, 2024.\nThanks for supporting amazing office snacks! 🍪';
      case SubscriptionStatus.overdue:
        return 'Your payment is overdue. Please update your payment to continue accessing full snacks.';
      case SubscriptionStatus.paused:
        return 'Your subscription is paused. You can reactivate it anytime to resume full access.';
      case SubscriptionStatus.inactive:
        return 'Your subscription is inactive. Subscribe to access Sandy\'s amazing snack curation!';
    }
  }
}
