import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendsmart/common/constants/app_colors.dart';

class WidgetText extends StatelessWidget {
  const WidgetText({
    super.key,
    required this.text,
    this.fontSize,
    this.overflow,
    this.textColor,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.textUnderline,
  });
  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? textUnderline;

  @override
  Widget build(BuildContext context) {
    final defaultColor = Colors.white;

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize ?? 14.sp,
        color: textColor ?? defaultColor,
        fontWeight: fontWeight ?? FontWeight.normal,
        overflow: overflow ?? TextOverflow.visible,

        decoration: (textUnderline == true)
            ? TextDecoration.underline
            : TextDecoration.none,
        decorationColor: AppColors.primary,
      ),
    );
  }
}
