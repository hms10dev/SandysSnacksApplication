// lib/widgets/forms/payment_method_selector.dart
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

enum PaymentMethod { venmo, zelle }

class PaymentMethodSelector extends StatefulWidget {
  final Function(PaymentMethod) onPaymentMethodChanged;

  const PaymentMethodSelector({
    Key? key,
    required this.onPaymentMethodChanged,
  }) : super(key: key);

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  PaymentMethod selectedMethod = PaymentMethod.venmo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPaymentOption(
          method: PaymentMethod.venmo,
          icon: '📱',
          iconColor: const Color(0xFF3D95CE),
          title: 'Venmo',
          subtitle: 'Send \$5 to @sand-baskar each month',
          instructions: [
            'Open Venmo and search for @sand-baskar',
            'Send \$5 with note "Sandy\'s Snacks - [Your Name]"',
            'Take a screenshot and upload it below (optional)',
          ],
        ),
        const SizedBox(height: 16),
        _buildPaymentOption(
          method: PaymentMethod.zelle,
          icon: '💰',
          iconColor: const Color(0xFF6F42C1),
          title: 'Zelle',
          subtitle: 'Send \$5 to sandy@email.com each month',
          instructions: [
            'Open your banking app and go to Zelle',
            'Send \$5 to sandy@email.com',
            'Include "Sandy\'s Snacks - [Your Name]" in the memo',
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    required String icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<String> instructions,
  }) {
    final isSelected = selectedMethod == method;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = method;
        });
        widget.onPaymentMethodChanged(method);
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.neutral200,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? AppColors.warmCream : AppColors.cardBackground,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to pay:',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...instructions
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${entry.key + 1}. ',
                                  style: AppTextStyles.caption,
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: AppTextStyles.caption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
