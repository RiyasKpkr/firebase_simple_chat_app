import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  Color iconColor;
  double? iconSize;
  IconData icons;

   IconWidget({
    Key? key, required this.iconColor, this.iconSize,required this.icons
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icons,
      size: iconSize,
      color: iconColor,
    );
  }
}