import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Widget untuk toggle button koneksi
class ConnectionToggle extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onTap;

  const ConnectionToggle({
    super.key,
    required this.isConnected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isConnected 
        ? AppConstants.connectedGreen 
        : AppConstants.disconnectedRed;
    final IconData statusIcon = isConnected ? Icons.check : Icons.close;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: AppConstants.toggleWidth,
        height: AppConstants.toggleHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppConstants.greyBackground,
            borderRadius: BorderRadius.circular(AppConstants.toggleBorderRadius),
            boxShadow: const [
              BoxShadow(
                color: AppConstants.shadowColor,
                blurRadius: AppConstants.shadowBlur,
                offset: Offset(0, AppConstants.shadowOffset),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.horizontalPadding),
            child: AnimatedAlign(
              alignment: isConnected
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              duration: AppConstants.toggleAnimationDuration,
              curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: AppConstants.toggleAnimationDuration,
                width: AppConstants.toggleButtonSize,
                height: AppConstants.toggleButtonSize,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.4),
                      blurRadius: AppConstants.shadowBlur,
                      offset: const Offset(0, AppConstants.shadowOffset),
                    ),
                  ],
                ),
                child: Icon(
                  statusIcon,
                  color: Colors.white,
                  size: AppConstants.iconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
