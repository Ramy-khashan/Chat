import 'dart:developer';

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
      create: (context) => ChatCubit(),
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
                                // List messages =
                                //     snapshot.data!.docs[0].get("chat")[0];

                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("chats")
                                      .doc(snapshot.data!.docs[0].id)
                                      .collection("friedchat")
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot>
                                          snapshotMsg) {
                                    if (snapshotMsg.hasData) {
                                      return Expanded(
                                        child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  size.shortestSide * .03,
                                              vertical:
                                                  size.shortestSide * .02),
                                          itemBuilder: (context, index) =>
                                              MessageShapeItem(
                                                  message:
                                                      "aadwokdoapkdwapodko $index",
                                                  size: size),
                                          reverse: true,
                                          itemCount:
                                              snapshotMsg.data!.docs.length,
                                        ),
                                      );
                                    } else {
                                      return const LoadingItem();
                                    }
                                  },
                                );
                              }),
                          ChatTextFieldItem(
                              onSendMessage: () {
                                FirebaseFirestore.instance
                                    .collection("chats")
                                    .doc()
                                    .update({
                                  "chat": FieldValue.arrayUnion([
                                    controller.messageController.value.text
                                        .trim()
                                  ])
                                });
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
