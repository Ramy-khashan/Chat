 
import 'package:chat/core/Widgets/loading.dart';
import 'package:chat/cubit/chat_cubit/chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constant.dart';
import '../../cubit/chat_cubit/chat_state.dart';
import 'widget/chat_textfield.dart';
import 'widget/head.dart';
import 'widget/message_shape.dart';

class ChatPageScreen extends StatelessWidget {
  final String friendId;
  final String mineId;
  final String friendImg;
  final String friendName;
  const ChatPageScreen(
      {Key? key,
      required this.friendId,
      required this.friendImg,
      required this.friendName,
      required this.mineId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => ChatCubit()..getUserImage(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              final controller = ChatCubit.get(context);
              return Column(
                children: [
                  ChatHeadItem(
                    size: size,
                    friendImg: friendImg,
                    friendName: friendName,
                  ),
                  Expanded(
                    child: Container(
                      decoration: decoration,
                      child: Column(
                        children: [
                          FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("chats")
                                  // .where("users", arrayContains: friendId)
                                  .where("users", arrayContainsAny: [
                                mineId,
                                friendId
                              ]).get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  controller.docsId =
                                      (snapshot.data!.docs[0].id);
                                  return StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("chats")
                                        .doc(snapshot.data!.docs[0].id)
                                        .collection("friedchat").orderBy("date",descending: true)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot>
                                            snapshotMsg) {
                                      if (snapshotMsg.hasData) {
                                      
                                        return Expanded(
                                          child: ListView.builder(
                                            reverse: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    size.shortestSide * .03,
                                                vertical:
                                                    size.shortestSide * .02),
                                            itemBuilder: (context, index) {
                                               
                                              return MessageShapeItem(
                                                  date: snapshotMsg
                                                        .data!.docs[index]
                                                        .get("date") as Timestamp,
                                                  senderImage:controller.userImg,
                                                  reciverImage:friendImg,
                                                  isMyMsg:mineId==snapshotMsg
                                                        .data!.docs[index]
                                                        .get("userId"),
                                                    message: snapshotMsg
                                                        .data!.docs[index]
                                                        .get("msg"),
                                                    size: size);
                                            },
                                           
                                            itemCount:
                                                snapshotMsg.data!.docs.length,
                                          ),
                                        );
                                      } else {
                                        return const Expanded(
                                            child: LoadingItem());
                                      }
                                    },
                                  );
                                } else {
                                  return const Expanded(child: SizedBox());
                                }
                              }),
                          ChatTextFieldItem(
                              onSendMessage: () {
                                controller.sendMessage(mineId);
                              },
                              size: size,
                              messageController: controller.messageController)
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
