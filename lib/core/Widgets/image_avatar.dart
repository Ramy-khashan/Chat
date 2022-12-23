import 'package:flutter/material.dart';

class ImageAvatarItem extends StatelessWidget {
  final Size size;
  final Color bgColor;
  final double radius;
  final String img;
  const ImageAvatarItem({
    Key? key,
    this.img = "",
    required this.size,
    required this.bgColor,
    this.radius = 0.06,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: img == ""
          ? null
          : NetworkImage(
              img,
            ),
      radius: size.shortestSide * radius,
      backgroundColor: bgColor,
    );
  }
}
