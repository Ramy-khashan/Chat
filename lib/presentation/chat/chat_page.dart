import 'dart:developer';

import 'package:chat/core/Widgets/loading.dart';
import 'package:chat/cubit/chat_cubit/chat_cubit.dart';
import 'package:chat/presentation/chat/widget/show_friend_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../core/constant.dart';
import '../../cubit/chat_cubit/chat_state.dart';
import '../../core/Widgets/chat_textfield.dart';
import 'widget/head.dart';
import '../../core/Widgets/message_shape.dart';

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
    log(mineId);
    log(friendId);
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => ChatCubit()
        ..getChatId(mineId: mineId, friendId: friendId)
        ..getUserImage(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final controller = ChatCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  ChatHeadItem(
                    tag: controller.tag,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context) => ShowFrindImage(friendId: friendId, friendImg: friendImg),));
                    },
                    size: size,
                    friendImg: friendImg,
                    friendName: friendName,
                  ),
                  Expanded(
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: decoration,
                      child: Column(
                        children: [
                          !controller.isLoadingDocsId
                              ? StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("chats")
                                      .doc(controller.docsId)
                                      .collection("friedchat")
                                      .orderBy("date", descending: true)
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
                                            return Column(
                                              children: [
                                                controller.selectedInex == index
                                                    ? controller.isClickingMsg
                                                        ? Center(
                                                            child: Text(
                                                              // intl.DateFormat.jm().format(date.toDate()),
                                                              Jiffy((snapshotMsg
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .get(
                                                                              "date") as Timestamp)
                                                                      .toDate()
                                                                      .toString())
                                                                  .jm
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.shortestSide *
                                                                        .03,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink()
                                                    : const SizedBox.shrink(),
                                                InkWell(
                                                  onTap: () {
                                                    controller
                                                        .showMessageTime();
                                                    controller.selectedInex =
                                                        index;
                                                  },
                                                  child: MessageShapeItem(
                                                      date: snapshotMsg
                                                              .data!.docs[index]
                                                              .get("date")
                                                          as Timestamp,
                                                      senderImage:
                                                          controller.userImg,
                                                      reciverImage: friendImg,
                                                      isMyMsg: mineId ==
                                                          snapshotMsg
                                                              .data!.docs[index]
                                                              .get("userId"),
                                                      message: snapshotMsg
                                                          .data!.docs[index]
                                                          .get("msg"),
                                                      size: size),
                                                ),
                                              ],
                                            );
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
                                )
                              : const Expanded(child: SizedBox()),
                          ChatTextFieldItem(
                              onSendMessage: controller.isLoadingDocsId
                                  ? () {}
                                  : () async {
                                      log("docsId" + controller.docsId);
                                      if (controller.docsId.isEmpty) {
                                        await controller
                                            .getChatId(
                                                mineId: mineId,
                                                friendId: friendId)
                                            .whenComplete(() {
                                          controller.sendMessage(mineId);
                                        });
                                      } else {
                                        if (controller.messageController.text
                                            .trim()
                                            .isNotEmpty) {
                                          controller.sendMessage(mineId);
                                        }
                                      }
                                    },
                              size: size,
                              messageController: controller.messageController)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
