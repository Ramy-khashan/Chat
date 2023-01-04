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

class ChatPageScreen extends StatefulWidget {
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
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
 
  
 
  
  @override
  Widget build(BuildContext context) {
   
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => ChatCubit()..initScrollController()
        ..getChatId(mineId: widget.mineId, friendId: widget.friendId)
        ..getUserImage(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final controller = ChatCubit.get(context);
          return Scaffold(
            body: Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      ChatHeadItem(
                        tag: controller.tag,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowFrindImage(
                                    friendId: widget.friendId,
                                    friendImg: widget.friendImg),
                              ));
                        },
                        size: size,
                        friendImg: widget.friendImg,
                        friendName: widget.friendName,
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
                                              controller: controller.chatController,
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
                                                    controller.selectedInex ==
                                                            index
                                                        ? controller
                                                                .isClickingMsg
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 8),
                                                                child: Center(
                                                                  child: Text(
                                                                    // intl.DateFormat.jm().format(date.toDate()),
                                                                    Jiffy((snapshotMsg.data!.docs[index].get("date") as Timestamp).toDate().toString())
                                                                            .MEd
                                                                            .toString() +
                                                                        " - " +
                                                                        Jiffy((snapshotMsg.data!.docs[index].get("date") as Timestamp).toDate().toString())
                                                                            .jm
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          size.shortestSide *
                                                                              .03,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox
                                                                .shrink()
                                                        : const SizedBox
                                                            .shrink(),
                                                    InkWell(
                                                      onTap: () {
                                                        controller
                                                            .showMessageTime();
                                                        controller
                                                                .selectedInex =
                                                            index;
                                                      },
                                                      child: MessageShapeItem(
                                                          date: snapshotMsg
                                                                  .data!
                                                                  .docs[index]
                                                                  .get("date")
                                                              as Timestamp,
                                                          senderImage:
                                                              controller
                                                                  .userImg,
                                                          reciverImage:
                                                              widget.friendImg,
                                                          isMyMsg: widget
                                                                  .mineId ==
                                                              snapshotMsg.data!
                                                                  .docs[index]
                                                                  .get(
                                                                      "userId"),
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
                                                    mineId: widget.mineId,
                                                    friendId: widget.friendId)
                                                .whenComplete(() {
                                              controller
                                                  .sendMessage(widget.mineId);
                                            });
                                          } else {
                                            if (controller
                                                .messageController.text
                                                .trim()
                                                .isNotEmpty) {
                                              controller
                                                  .sendMessage(widget.mineId);
                                            }
                                          }
                                        },
                                  size: size,
                                  messageController:
                                      controller.messageController)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            !    controller.isBottom
                    ? Positioned(
                        bottom: size.longestSide * .11,
                        right: size.shortestSide * .06,
                        child: FloatingActionButton(
                          backgroundColor: mainColor,
                          onPressed: () {
                            controller.chatController!.animateTo(
                            controller.chatController!.position.minScrollExtent,

                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut);
                          },
                          child: const Icon(Icons.keyboard_arrow_down_rounded),
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
          );
        },
      ),
    );
  }
}
