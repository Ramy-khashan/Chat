import 'package:flutter/material.dart';

import '../../../core/Widgets/icon_button.dart';
import '../../../core/Widgets/image_avatar.dart';

class ChatHeadItem extends StatelessWidget {
  final Size size;
  final String friendImg;
  final String tag;
  final String friendName;
  final bool status;

  final Function() onTap;
  const ChatHeadItem(
      {Key? key,
      required this.size,
      required this.friendImg,
      required this.friendName,
      required this.onTap,
      required this.tag,
      required this.status})
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
          Stack(
            children: [
              InkWell(
                onTap: onTap,
                child: Hero(
                  tag: tag,
                  child: ImageAvatarItem(
                    size: size,
                    img: friendImg,
                    bgColor: Colors.white,
                    radius: .065,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 6,
                child: CircleAvatar(
                  backgroundColor: status ? Colors.green : Colors.grey.shade500,
                  radius: size.shortestSide * .02,
                ),
              )
            ],
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
