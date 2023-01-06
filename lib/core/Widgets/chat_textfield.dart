import 'package:flutter/material.dart';

import '../constant.dart';

class ChatTextFieldItem extends StatelessWidget {
  final Size size;
  final bool isEmoji;
  final bool isdisable;
  final VoidCallback onSendMessage;
  final VoidCallback onTapEmoij;
  final TextEditingController messageController;
  const ChatTextFieldItem({
    Key? key,
    required this.onSendMessage,
    required this.size,
    required this.messageController,
    required this.onTapEmoij,
    required this.isEmoji, required this.isdisable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: size.longestSide * .01,
      ),
      child: Row(
        children: [ IconButton(
                      onPressed: onTapEmoij,
                      icon:   Icon(isEmoji?Icons.keyboard:Icons.emoji_emotions,color:mainColor,size: size.shortestSide*.08,)),
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
          IconButton(
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
