import 'package:chat/core/constant.dart';
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
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      width: size.shortestSide * radius * 2,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Image.network(
        img,
          width: size.shortestSide * radius * 2,
                fit: BoxFit.fill,
        loadingBuilder: (context, child, c) {
          if (c == null) return child;
          return Image.asset(
                "assets/image/user.jpeg",
                width: size.shortestSide * radius * 2,
                fit: BoxFit.fill,
              );
        },
         errorBuilder: (context, child, error) => Image.asset(
                "assets/image/user.jpeg",
                width: size.shortestSide * radius * 2,
                fit: BoxFit.fill,
              )
      ),
    );
   
  }
} 