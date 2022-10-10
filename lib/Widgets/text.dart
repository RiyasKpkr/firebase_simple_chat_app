
import 'package:flutter/material.dart';

class textWidget extends StatelessWidget {
  String textdata;
  double? fontSize;
  FontWeight? fontWeight;
  Color? fontColor;
  
  textWidget({
    Key? key, required this.textdata,  this.fontSize,  this.fontWeight, this.fontColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textdata,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: fontColor
      ),
    );
  }
}

