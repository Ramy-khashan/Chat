import 'package:flutter/material.dart';
import '../../../core/Widgets/image_avatar.dart';
import '../../../core/constant.dart';

class FrindChatItem extends StatelessWidget {
  final String img;
  final String name;
  final bool status;
  final String lastmsg;
  final String date;
  final Size size;
  const FrindChatItem(
      {Key? key,
      required this.img,
      required this.name,
      required this.status,
      required this.lastmsg,
      required this.date, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          top: size.longestSide * .02,
        ),
        child: ListTile(
          leading: Stack(
            children: [
              ImageAvatarItem(
                img: img,
                size: size,
                bgColor: mainColor,
                radius: .07,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  backgroundColor: status
                      ? Colors.green
                      : Colors.grey.shade500,
                  radius: size.shortestSide * .02,
                ),
              )
            ],
          ),
          title: Text(
            name,
            style: TextStyle(
                color: Colors.white, fontSize: size.shortestSide * .05),
          ),
          // subtitle: Text(snapshotMsg.data!
          //     .get('last_msg')),
          // trailing: Text(snapshotMsg.data!
          //     .get('last_msg_date')
          //     .toString()
          //     .substring(0, 5)),
        ));
  }
}
