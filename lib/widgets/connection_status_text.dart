import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Widget untuk menampilkan status koneksi
class ConnectionStatusText extends StatelessWidget {
  final bool isConnected;

  const ConnectionStatusText({
    super.key,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isConnected 
        ? AppConstants.connectedGreen 
        : AppConstants.disconnectedRed;
    final String statusText = isConnected 
        ? AppConstants.connectedText 
        : AppConstants.disconnectedText;

    return AnimatedSwitcher(
      duration: AppConstants.textAnimationDuration,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Text(
        statusText,
        key: ValueKey<bool>(isConnected),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
