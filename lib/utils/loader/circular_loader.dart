import 'package:doplsnew/utils/constant/custom_size.dart';
import 'package:doplsnew/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCircularLoader extends StatelessWidget {
  const CustomCircularLoader({
    super.key,
    this.foregroundColor = AppColors.white,
    this.backgroundColor = AppColors.primary,
    this.size = 50.0,
  });

  final Color? foregroundColor;
  final Color? backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(CustomSize.sm),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: CircularProgressIndicator(
          color: foregroundColor,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
