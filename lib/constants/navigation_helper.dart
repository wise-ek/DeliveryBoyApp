// navigation_helper.dart

import 'package:flutter/material.dart';

class NavigationHelper {
  // Push a new screen
  static void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  // Replace current screen with new one
  static void replaceWith(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}
