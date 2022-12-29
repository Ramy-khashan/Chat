import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
 
import 'image_avatar.dart';
import '../constant.dart';

class MessageShapeItem extends StatelessWidget {
  final Size size;
  final String message;
  final String senderImage;
  final String reciverImage;
  final Timestamp date;
  final bool isMyMsg;
  const MessageShapeItem(
      {Key? key,
      required this.message,
      required this.size,
      required this.isMyMsg,
      required this.senderImage,
      required this.reciverImage,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isMyMsg ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: size.longestSide * .01,
            top: size.longestSide * .01,
            left: isMyMsg ? size.shortestSide * .15 : 0,
            right: isMyMsg ? 0 : size.shortestSide * .15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageAvatarItem(
              size: size,
              img: isMyMsg ? senderImage : reciverImage,
              bgColor: isMyMsg ? mainColor : Colors.grey.shade300,
              radius: .05,
            ),
            Expanded(
              flex: message.length>20?1:0,
              child: Container(
                margin: EdgeInsets.only(
                    left: size.shortestSide * .01,
                    right: size.shortestSide * .01),
                padding: EdgeInsets.symmetric(
                    horizontal: size.shortestSide * .03,
                    vertical: size.longestSide * .01),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.trim(),
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: size.shortestSide*.042,
                    
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
