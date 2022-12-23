import 'package:flutter/material.dart';

import '../../../core/Widgets/icon_button.dart';
import '../../../core/Widgets/image_avatar.dart';

class ChatHeadItem extends StatelessWidget {
  final Size size;
  const ChatHeadItem({Key? key,required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.shortestSide * .05,
        vertical: size.longestSide * .03,
      ),
      child: Row(
        children: [
          IconButtonItem(
            icon: Icons.arrow_back,
            onTap: () {
              Navigator.pop(context);
            },
            size: size,
            bgColor: Colors.transparent,
          ),
          const Spacer(),
          ImageAvatarItem(
            size: size,
            bgColor: Colors.white,
            radius: .065,
          ),
          SizedBox(width: size.shortestSide * .035),
          Text(
            "Name",
            style: TextStyle(
                fontSize: size.shortestSide * .06,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          const Spacer(),
          IconButtonItem(
            icon: Icons.menu,
            onTap: () {},
            size: size,
          ),
        ],
      ),
    );
  }
}
