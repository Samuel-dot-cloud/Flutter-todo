import 'package:flutter/material.dart';

class NoGlowBehaviour extends ScrollBehavior {
  Widget buildViewPortChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
