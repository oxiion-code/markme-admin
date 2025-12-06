import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BatchContainer extends StatelessWidget {
  final String batchName;
  final IconData iconData;
  final Color cardColor;
  final VoidCallback? onRightCornerButtonPressed;
  final IconData? rightCornerButtonIcon;
  final Color? rightCornerButtonIconColor;

  const BatchContainer({
    super.key,
    required this.batchName,
    required this.iconData,
    required this.cardColor,
    this.onRightCornerButtonPressed,
    this.rightCornerButtonIcon,
    this.rightCornerButtonIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(-2, -2),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(
                  iconData,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              Text(
                batchName.split("_").join(" ").toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          if (rightCornerButtonIcon != null)
            Positioned(
              top: -12,
              right: -12,
              child: Material(
                elevation: 5,
                shape: const CircleBorder(),
                color: Colors.white,
                child: IconButton(
                  icon: Icon(
                    rightCornerButtonIcon,
                    color: rightCornerButtonIconColor ?? Colors.redAccent,
                    size: 28,
                  ),
                  onPressed: onRightCornerButtonPressed,
                  splashRadius: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
