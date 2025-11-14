import 'package:flutter/material.dart';

class CustomScrollBehavior extends ScrollBehavior {
  // Delete Glow Effect
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
