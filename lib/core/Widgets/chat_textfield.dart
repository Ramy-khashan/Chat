import 'package:flutter/material.dart';

import '../constant.dart';

class ChatTextFieldItem extends StatelessWidget {
  final Size size;
  final bool isEmoji;
  final bool isdisable;
  final VoidCallback onSendMessage;
  final Function(dynamic val) onChange;
  final VoidCallback onTapEmoij;
  final VoidCallback onClickLike;
  final bool isEmpty;
  final TextEditingController messageController;
  const ChatTextFieldItem({
    Key? key,
    required this.onSendMessage,
    required this.size,
    required this.messageController,
    required this.onTapEmoij,
    required this.isEmoji,
    required this.isdisable,
    required this.onChange,
    required this.onClickLike, required this.isEmpty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: size.longestSide * .01,
      ),
      child: Row(
        children: [
          IconButton(
              onPressed: onTapEmoij,
              icon: Icon(
                isEmoji ? Icons.keyboard : Icons.emoji_emotions,
                color: mainColor,
                size: size.shortestSide * .08,
              )),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4,
                        color: Colors.grey.shade400,
                        spreadRadius: 1,
                        offset: const Offset(2, 2))
                  ]),
              child: TextField(
                onChanged: onChange,
                controller: messageController,
                decoration: InputDecoration(
                  enabled: !isdisable,
                  hintText: "Write your message....",
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          SizedBox(
            width: size.shortestSide * .025,
          ),
        isEmpty
              ? InkWell(
                  onTap: onClickLike,
                  child: Image.asset(
                    "assets/image/like.png",
                    width: size.shortestSide * .1,
                  ))
              : IconButton(
                  onPressed: onSendMessage,
                  icon: Icon(
                    Icons.send,
                    size: size.shortestSide * .08,
                    color: mainColor.withOpacity(.7),
                  ),
                )
        ],
      ),
    );
  }
}
