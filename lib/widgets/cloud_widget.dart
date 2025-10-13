import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';

/// Widget untuk menampilkan cloud icon
class CloudWidget extends StatelessWidget {
  final bool isReady;
  final String assetPath;

  const CloudWidget({
    super.key,
    required this.isReady,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    if (isReady) {
      return SvgPicture.asset(
        assetPath,
        width: AppConstants.cloudWidth,
      );
    }

    return SizedBox(
      width: AppConstants.cloudWidth,
      height: AppConstants.cloudHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppConstants.greyBackground,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    );
  }
}
