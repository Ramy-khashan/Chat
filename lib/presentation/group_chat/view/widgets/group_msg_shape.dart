import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/constant.dart';

class GroupMsgShapeItem extends StatelessWidget {
  final Size size;
  final String message;
  final String userImage;
  final String userName;
  final Timestamp date;
  final bool isMyMsg;
  const GroupMsgShapeItem(
      {Key? key,
      required this.message,
      required this.size,
      required this.isMyMsg,
      required this.date,
      required this.userImage,
      required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isMyMsg ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: size.longestSide * .015,
            top: size.longestSide * .01,
            left: isMyMsg ? size.shortestSide * .15 : 0,
            right: isMyMsg ? 0 : size.shortestSide * .15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: message.length > 20 ? 1 : 0,
              child: Container(
                margin: EdgeInsets.symmetric(
                 horizontal: size.shortestSide * .01),
                padding: EdgeInsets.symmetric(
                    horizontal: size.shortestSide * .035,
                    vertical: size.longestSide * .017),
                decoration: BoxDecoration(
                  color: isMyMsg ? mainColor : Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomLeft: Radius.circular(isMyMsg ? 10 : 0),
                    bottomRight: Radius.circular(isMyMsg ? 0 : 10),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isMyMsg
                        ? const SizedBox.shrink()
                        : Text(
                            userName.trim(),
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.shortestSide * .042,
                              color: isMyMsg ? Colors.white : Colors.black,
                            ),
                          ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      message.trim(),
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: size.shortestSide * .042,
                        color: isMyMsg ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
