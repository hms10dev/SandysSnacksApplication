import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class AdminStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String change;
  final bool changePositive;
  final Color borderColor;

  const AdminStatCard({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.change,
    required this.changePositive,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          // Top border
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: iconColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(value,
                      style: AppTextStyles.heading2.copyWith(fontSize: 28)),
                  const SizedBox(height: 4),
                  Text(label, style: AppTextStyles.caption),
                  const SizedBox(height: 8),
                  Text(
                    change,
                    style: AppTextStyles.caption.copyWith(
                      color: changePositive
                          ? AppColors.success
                          : AppColors.warning,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
