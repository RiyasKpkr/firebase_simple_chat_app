
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  Color backgroundColor;
  double circleRadius;
  String assetImage;
  double imageHeight;
  double imageScale;
   CircleImage({
    Key? key,
    required this.backgroundColor,
    required this.circleRadius,
    required this.assetImage,
    required this.imageHeight,
    required this.imageScale
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: circleRadius,
      child: Image.asset(
        assetImage,
        height: imageHeight,
        scale: imageScale,
      ),
    );
  }
}
