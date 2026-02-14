import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendsmart/common/widgets/widget_icon.dart';
import 'package:spendsmart/common/widgets/widget_text.dart';

class CarouselItem extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const CarouselItem({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        WidgetIcon(imageLoc: image),
        SizedBox(height: 8.h),
        WidgetText(text: title, fontWeight: FontWeight.bold),
        SizedBox(height: 4.h),
        WidgetText(
          text: description,
          fontSize: 12.sp,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
