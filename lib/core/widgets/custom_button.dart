import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go/core/constants/color_manager.dart';
import 'package:go/core/constants/font_manager.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  const CustomButton({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primaryColor,
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: FontSize.s16),
          ),
        ),
      ),
    );
  }
}
