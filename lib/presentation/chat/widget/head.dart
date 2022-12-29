import 'package:flutter/material.dart';

import '../../../core/Widgets/icon_button.dart';
import '../../../core/Widgets/image_avatar.dart';

class ChatHeadItem extends StatelessWidget {
  final Size size;
  final String friendImg;
  final String tag;
  final String friendName;
  final Function() onTap;
  const ChatHeadItem(
      {Key? key,
      required this.size,
      required this.friendImg,
      required this.friendName, required this.onTap, required this.tag})
      : super(key: key);

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
          InkWell(
            onTap: onTap,
            child: Hero(
              tag:tag,
              child: ImageAvatarItem(
                size: size,
                img: friendImg,
                bgColor: Colors.white,
                radius: .065,
              ),
            ),
          ),
          SizedBox(width: size.shortestSide * .035),
          Text(
            friendName,
            style: TextStyle(
                fontSize: size.shortestSide * .06,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
