import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({
    Key? key,
    required this.name,
    this.size = 32,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accent, Color(0xFFFFB800)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: Center(
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'U',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: size < 40 ? 12 : 16,
            ),
          ),
        ),
      ),
    );
  }
}
