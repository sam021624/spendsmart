import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WidgetIcon extends StatelessWidget {
  const WidgetIcon({
    super.key,
    required this.imageLoc,
    this.height,
    this.width,
    this.isSvg,
    this.boxFit,
  });
  final String imageLoc;
  final double? height;
  final double? width;
  final bool? isSvg;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    const double defaultSize = 250;
    final double iconWidth = width ?? defaultSize;
    final double iconHeight = height ?? defaultSize;

    Widget imageWidget;

    switch (isSvg ?? true) {
      case true:
        imageWidget = SvgPicture.asset(
          imageLoc,
          width: iconWidth,
          height: iconHeight,
        );
        break;
      case false:
        imageWidget = ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(8.r),
          child: Image.asset(
            imageLoc,
            width: iconWidth,
            height: iconHeight,
            fit: boxFit,
          ),
        );
        break;
    }

    return Center(child: imageWidget);
  }
}
