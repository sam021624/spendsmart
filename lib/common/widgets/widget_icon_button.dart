import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetIconButton extends StatelessWidget {
  const WidgetIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize,
  });

  final void Function()? onPressed;
  final IconData icon;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: iconSize ?? 24.sp,
    );
  }
}
