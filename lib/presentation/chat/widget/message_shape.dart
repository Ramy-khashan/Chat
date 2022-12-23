import 'package:flutter/material.dart';

import '../../../core/Widgets/image_avatar.dart';
import '../../../core/constant.dart';

class MessageShapeItem extends StatelessWidget {
  final Size size;
  final String message;
  const MessageShapeItem({Key? key, required this.message, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.longestSide * .01),
      child: Row(
        children: [
          ImageAvatarItem(
            size: size,
            bgColor: mainColor,
            radius: .05,
          ),
          Container(
            margin: EdgeInsets.only(
              left: size.shortestSide * .01,
              right: size.shortestSide * .15,
            ),
            padding: EdgeInsets.symmetric(
                horizontal: size.shortestSide * .03,
                vertical: size.longestSide * .015),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
