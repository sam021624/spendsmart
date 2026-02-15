import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void navigateTo(Widget page) {
    Navigator.of(this).push(MaterialPageRoute(builder: (context) => page));
  }

  void pushReplace(Widget page) {
    Navigator.of(
      this,
    ).pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  void pushAndClear(Widget page) {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  void goBack() {
    Navigator.of(this).pop();
  }
}
