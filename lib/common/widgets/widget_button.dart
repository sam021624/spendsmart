import 'package:flutter/material.dart';
import 'package:spendsmart/common/constants/app_colors.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';

class WidgetButton extends StatelessWidget {
  const WidgetButton({
    super.key,
    required this.text,
    this.onPressed,
    this.height,
    this.width,
    this.color,
    this.textColor,
    this.child,
  });

  final String text;
  final Color? textColor;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 60,
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: color == Colors.white
                ? const BorderSide(color: AppColors.grey, width: 1)
                : BorderSide.none,
          ),
          elevation: 0,
        ),

        child:
            child ??
            WidgetText(
              text: text,
              fontWeight: FontWeight.bold,
              textColor: textColor ?? AppColors.white,
            ),
      ),
    );
  }
}
