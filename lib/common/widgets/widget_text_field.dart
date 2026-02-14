import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/common/constants/app_colors.dart';

class WidgetTextField extends StatefulWidget {
  const WidgetTextField({
    super.key,
    required this.hintText,
    this.iconData,
    this.hintTextColor,
    required this.controller,
    this.validator,
    this.obscureText,
    this.keyboardType,
    this.maxLength,
    this.textAlign,
  });

  final TextEditingController controller;
  final String hintText;
  final Color? hintTextColor;
  final IconData? iconData;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final TextAlign? textAlign;

  @override
  State<WidgetTextField> createState() => _WidgetTextFieldState();
}

class _WidgetTextFieldState extends State<WidgetTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText ?? false;
  }

  void _toggleVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showToggle = widget.obscureText ?? false;
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: _isObscure,
      maxLength: widget.maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: widget.textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        counterText: '',
        hintText: widget.hintText,
        hintStyle: TextStyle(color: widget.hintTextColor ?? AppColors.grey),
        prefixIcon: widget.iconData != null ? Icon(widget.iconData) : null,
        prefixIconColor: AppColors.grey,
        suffixIcon: showToggle
            ? IconButton(
                icon: Icon(
                  _isObscure ? Ionicons.eye_off : Ionicons.eye,
                  color: AppColors.grey,
                ),
                onPressed: _toggleVisibility,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.grey),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
