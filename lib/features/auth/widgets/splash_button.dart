import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:markme_admin/core/utils/app_utils.dart';

class SplashButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final IconData? icon;
  final Color? color;
  const SplashButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:theme.buttonTheme.colorScheme?.secondary ,
          elevation: 8,
          shadowColor: theme.shadowColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,
              color:theme.colorScheme.primary ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 26, color: theme.colorScheme.primary),
            ],
          ],
        ),
      ),
    );
  }
}
