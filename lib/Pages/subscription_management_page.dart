// lib/pages/subscription_management_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../widgets/common/app_sidebar.dart';
import '../widgets/cards/subscription_status_overview.dart';
import '../widgets/forms/payment_method_selector.dart';

class SubscriptionManagementPage extends StatefulWidget {
  const SubscriptionManagementPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionManagementPage> createState() =>
      _SubscriptionManagementPageState();
}

class _SubscriptionManagementPageState
    extends State<SubscriptionManagementPage> {
  final _preferencesController = TextEditingController();
  final _cravingsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-populate with existing preferences
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      _preferencesController.text = authService.user?.dietaryPreferences ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar
          const AppSidebar(currentRoute: '/subscription'),

          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(bottom: BorderSide(color: AppColors.neutral200)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Breadcrumb
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Dashboard',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.accent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(' → ', style: AppTextStyles.caption),
              Text('Manage Donation', style: AppTextStyles.caption),
            ],
          ),

          // User Menu
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  border: Border.all(color: AppColors.neutral200),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.notifications_outlined, size: 20),
              ),
              const SizedBox(width: 16),
              Consumer<AuthService>(
                builder: (context, authService, child) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accent, Color(0xFFFFB800)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        authService.userName?.substring(0, 1).toUpperCase() ??
                            'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 32),

            // Status Overview
            Consumer<AuthService>(
              builder: (context, authService, child) {
                return SubscriptionStatusOverview(
                  subscription: authService.subscription,
                );
              },
            ),
            const SizedBox(height: 24),

            // Info Alert
            _buildInfoAlert(),
            const SizedBox(height: 32),

            // Payment Method Section
            _buildPaymentMethodSection(),
            const SizedBox(height: 32),

            // Preferences Section
            _buildPreferencesSection(),
            const SizedBox(height: 32),

            // Payment History Section
            _buildPaymentHistorySection(),
            const SizedBox(height: 32),

            // Subscription Controls
            _buildSubscriptionControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Your Donation',
          style: AppTextStyles.heading1.copyWith(
            fontFamily: 'Cal Sans',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Update your monthly contribution to Sandy\'s snack fund',
          style: AppTextStyles.body,
        ),
      ],
    );
  }

  Widget _buildInfoAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        border: Border.all(color: const Color(0xFF7DD3FC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.caption
                    .copyWith(color: const Color(0xFF0369A1)),
                children: const [
                  TextSpan(
                    text: 'Reminder: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text:
                        'We\'ll send you a friendly reminder 3 days before your next donation is due. You can update your preferences or pause your subscription anytime below.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
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
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Method', style: AppTextStyles.heading3),
          const SizedBox(height: 24),
          PaymentMethodSelector(
            onPaymentMethodChanged: (method) {
              // Handle payment method selection
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
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
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preferences & Requests', style: AppTextStyles.heading3),
          const SizedBox(height: 24),

          // Dietary Preferences
          _buildFormGroup(
            label: 'Dietary Preferences',
            controller: _preferencesController,
            placeholder:
                'Any allergies, dietary restrictions, or preferences we should know about? (e.g., gluten-free, vegan, nut allergies, etc.)',
          ),

          const SizedBox(height: 24),

          // Current Cravings
          _buildFormGroup(
            label: 'Current Cravings',
            controller: _cravingsController,
            placeholder:
                'What are you in the mood for lately? Help Sandy plan future collections!',
          ),

          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: _savePreferences,
            icon: const Icon(Icons.save),
            label: const Text('Save Preferences'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormGroup({
    required String label,
    required TextEditingController controller,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AppTextStyles.caption,
            filled: true,
            fillColor: AppColors.neutral50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentHistorySection() {
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
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment History', style: AppTextStyles.heading3),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.neutral200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(1),
              },
              children: [
                // Header
                TableRow(
                  decoration: BoxDecoration(
                    color: AppColors.neutral50,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  children: [
                    _buildTableHeader('Month'),
                    _buildTableHeader('Amount'),
                    _buildTableHeader('Date Paid'),
                    _buildTableHeader('Status'),
                  ],
                ),
                // Data rows
                ..._buildPaymentHistoryRows(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.neutral800,
        ),
      ),
    );
  }

  List<TableRow> _buildPaymentHistoryRows() {
    final payments = [
      {
        'month': 'January 2024',
        'amount': '\$5.00',
        'date': 'Jan 2, 2024',
        'status': 'Paid'
      },
      {
        'month': 'December 2023',
        'amount': '\$5.00',
        'date': 'Dec 1, 2023',
        'status': 'Paid'
      },
      {
        'month': 'November 2023',
        'amount': '\$5.00',
        'date': 'Nov 3, 2023',
        'status': 'Paid'
      },
      {
        'month': 'October 2023',
        'amount': '\$5.00',
        'date': 'Oct 1, 2023',
        'status': 'Paid'
      },
    ];

    return payments
        .map((payment) => TableRow(
              children: [
                _buildTableCell(payment['month']!),
                _buildTableCell(payment['amount']!),
                _buildTableCell(payment['date']!),
                _buildTableCellWithBadge(payment['status']!),
              ],
            ))
        .toList();
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(text, style: AppTextStyles.caption),
    );
  }

  Widget _buildTableCellWithBadge(String status) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          status,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSubscriptionControls() {
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
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subscription Controls', style: AppTextStyles.heading3),
          const SizedBox(height: 24),

          Column(
            children: [
              _buildControlButton(
                icon: Icons.pause,
                label: 'Pause Subscription (Vacation Mode)',
                onPressed: _pauseSubscription,
                style: 'secondary',
              ),
              const SizedBox(height: 16),
              _buildControlButton(
                icon: Icons.email,
                label: 'Update Email Reminders',
                onPressed: _updateEmailReminders,
                style: 'secondary',
              ),
              const SizedBox(height: 16),
              _buildControlButton(
                icon: Icons.cancel,
                label: 'Cancel Subscription',
                onPressed: _cancelSubscription,
                style: 'danger',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Warning Alert
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEFCE8),
              border: Border.all(color: const Color(0xFFFACC15)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('⚠️', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.caption
                          .copyWith(color: const Color(0xFFA16207)),
                      children: const [
                        TextSpan(
                          text: 'Note: ',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text:
                              'If you cancel or pause your subscription, you\'ll only have access to taste samples until you reactivate. We\'ll miss you, but no hard feelings!',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required String style,
  }) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (style) {
      case 'danger':
        backgroundColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFFDC2626);
        borderColor = const Color(0xFFFECACA);
        break;
      case 'secondary':
      default:
        backgroundColor = AppColors.neutral100;
        textColor = AppColors.neutral800;
        borderColor = AppColors.neutral200;
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _savePreferences() {
    final authService = Provider.of<AuthService>(context, listen: false);
    // TODO: Implement save preferences
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences saved!')),
    );
  }

  void _pauseSubscription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pause Subscription?'),
        content: const Text(
            'Are you sure you want to pause your subscription? You can reactivate it anytime.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final authService =
                  Provider.of<AuthService>(context, listen: false);
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

  void _updateEmailReminders() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email reminder settings coming soon!')),
    );
  }

  void _cancelSubscription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Subscription?'),
        content: const Text(
            'Are you sure you want to cancel your subscription? You\'ll only have access to taste samples after canceling.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Subscription'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement cancel subscription
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Subscription cancelled')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            child: const Text('Cancel Subscription'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _preferencesController.dispose();
    _cravingsController.dispose();
    super.dispose();
  }
}

extension on User? {
  get dietaryPreferences => null;
}
