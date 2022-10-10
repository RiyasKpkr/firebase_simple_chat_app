import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  Color containerColor;
  BoxBorder containerBorder;
  BorderRadiusGeometry containerRadius;
  InputBorder inputBorder;
  String hintText;
  IconData icon;
  Color iconColor;
  bool obscureText ;
  ContainerWidget({
    Key? key,
    required this.passwordController,
    required this.containerColor,
    required this.containerBorder,
    required this.containerRadius,
    required this.inputBorder,
    required this.hintText,
    required this.icon,
    required this.iconColor,
    required this.obscureText,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: containerColor,
          border: containerBorder,
          borderRadius: containerRadius),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: TextField(
          controller: passwordController,
          decoration: InputDecoration(
              border: inputBorder,
              hintText: hintText,
              icon: Icon(
                icon,
                color: iconColor,
              )),
          obscureText: obscureText,
        ),
      ),
    );
  }
}