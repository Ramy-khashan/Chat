import 'package:flutter/material.dart';

class IconButtonItem extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Size size;
  final double iconSize;
  final Color bgColor;
  final Color iconColor;
  const IconButtonItem({
    Key? key,
    required this.icon,
    this.bgColor = Colors.white30,
    this.iconSize = .06,
    this.iconColor = Colors.white,
    required this.onTap,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size.shortestSide * iconSize,
      backgroundColor: bgColor,
      child: IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            
            size: size.shortestSide * iconSize,
            color: iconColor,
          )),
    );
  }
}
