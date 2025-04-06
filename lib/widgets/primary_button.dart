import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/values/colors.dart';
import 'package:mashatel/values/radii.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback
      onPressed; // Changed to VoidCallback for better type safety
  final String textKey;
  final Color color;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.textKey,
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Replaced deprecated 'color'
          foregroundColor: Colors.white, // Text/icon color
          shape: RoundedRectangleBorder(
            borderRadius: Radii.k8pxRadius,
          ),
          padding: EdgeInsets.symmetric(
              vertical: 12.h), // Added padding for better touch area
          textStyle: TextStyle(
              height: 0.5,
              color: Colors.white,
              fontSize: 16.sp, // Added responsive font size
              fontFamily: "DIN"),
        ),
        child: AutoSizeText(
          textKey,
          maxLines: 1,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
