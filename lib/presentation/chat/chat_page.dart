import 'dart:developer';

import 'package:chat/core/Widgets/loading.dart';
import 'package:chat/core/app_keys.dart';
import 'package:chat/cubit/chat_cubit/chat_cubit.dart';
import 'package:chat/data/reaction_data.dart';
import 'package:chat/presentation/chat/widget/show_friend_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:jiffy/jiffy.dart';

import 'package:flutter/foundation.dart' as foundation;
import '../../core/constant.dart';
import '../../cubit/chat_cubit/chat_state.dart';
import '../../core/Widgets/chat_textfield.dart';
import 'widget/head.dart';
import '../../core/Widgets/message_shape.dart';

class ChatPageScreen extends StatefulWidget {
  final String friendId;
  final String mineId;
  final String friendImg;
  final bool status;
  final String friendName;
  const ChatPageScreen(
      {Key? key,
      required this.friendId,
      required this.friendImg,
      required this.friendName,
      required this.mineId,
      required this.status})
      : super(key: key);

  @override
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => ChatCubit()
        ..initScrollController()
        ..getChatId(mineId: widget.mineId, friendId: widget.friendId)
        ..getUserImage(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final controller = ChatCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              return controller.systemBackButton();
            },
            child: Scaffold(
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
                          status: widget.status,
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
                                                controller:
                                                    controller.chatController,
                                                reverse: true,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.shortestSide * .03,
                                                    vertical:
                                                        size.shortestSide *
                                                            .02),
                                                itemBuilder: (context, index) {
                                                  final item = snapshotMsg
                                                      .data!.docs[index];
                                                  return Column(
                                                    children: [
                                                      controller.selectedInex ==
                                                              index
                                                          ? controller
                                                                  .isClickingMsg
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8),
                                                                  child: Center(
                                                                    child: Text(
                                                                      // intl.DateFormat.jm().format(date.toDate()),
                                                                      Jiffy((item.get("date") as Timestamp).toDate().toString())
                                                                              .MEd
                                                                              .toString() +
                                                                          " - " +
                                                                          Jiffy((item.get("date") as Timestamp).toDate().toString())
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
                                                        child: item.get(
                                                                    "msg") ==
                                                                AppKeys.likeKey
                                                            ? Align(
                                                                alignment: widget
                                                                            .mineId ==
                                                                        item.get(
                                                                            "userId")
                                                                    ? Alignment
                                                                        .centerRight
                                                                    : Alignment
                                                                        .centerLeft,
                                                                child:
                                                                    Image.asset(
                                                                  "assets/image/like.png",
                                                                  width:
                                                                      size.shortestSide *
                                                                          .2,
                                                                ),
                                                              )
                                                            : ReactionContainer<
                                                                String>(
                                                                onReactionChanged:
                                                                    (String?
                                                                        value) {
                                                                  if (value!
                                                                      .isNotEmpty) {
                                                                    controller.msgReact(
                                                                        msgId: item
                                                                            .id,
                                                                        reactValue:
                                                                            item.get(
                                                                                "react"),
                                                                        selectedReact:
                                                                            value);
                                                                  }
                                                                },
                                                                reactions:
                                                                    reactions,
                                                                child: Stack(
                                                                  children: [
                                                                    MessageShapeItem(
                                                                        date: item.get("date")
                                                                            as Timestamp,
                                                                        senderImage:
                                                                            controller
                                                                                .userImg,
                                                                        reciverImage:
                                                                            widget
                                                                                .friendImg,
                                                                        isMyMsg: widget
                                                                                .mineId ==
                                                                            item.get(
                                                                                "userId"),
                                                                        message:
                                                                            item.get(
                                                                                "msg"),
                                                                        size:
                                                                            size),
                                                                    item.get("react") ==
                                                                            -1
                                                                        ? const SizedBox
                                                                            .shrink()
                                                                        : Positioned(
                                                                            bottom:
                                                                                0,
                                                                            right:
                                                                               widget
                                                                                .mineId ==
                                                                            item.get(
                                                                                "userId")?  4:size.shortestSide*.87,
                                                                            child:
                                                                                CircleAvatar(
                                                                              radius: size.shortestSide * .03,
                                                                              foregroundImage: AssetImage(
                                                                                imgs[item.get("react")],
                                                                              ),
                                                                            ))
                                                                  ],
                                                                ),
                                                              ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                itemCount: snapshotMsg
                                                    .data!.docs.length,
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
                                    isEmpty: controller.isTextFieldEmpty,
                                    onClickLike: () {
                                      controller.sendLike(widget.mineId);
                                    },
                                    onChange: (val) =>
                                        controller.getTextFieldifEmpty(val),
                                    onTapEmoij: () {
                                      controller.setEmoji();
                                    },
                                    isdisable: controller.isdisable,
                                    isEmoji: controller.isEmoji,
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
                                        controller.messageController),
                                Offstage(
                                  offstage: !controller.isEmoji,
                                  child: SizedBox(
                                      height: 250,
                                      child: EmojiPicker(
                                        textEditingController:
                                            controller.messageController,
                                        onEmojiSelected: (category, emoji) {
                                          controller.getTextFieldifEmpty(
                                              controller.messageController.text
                                                  .trim());
                                        },
                                        config: Config(
                                          columns: 7,
                                          // Issue: https://github.com/flutter/flutter/issues/28894
                                          emojiSizeMax: 32 *
                                              (foundation.defaultTargetPlatform ==
                                                      TargetPlatform.iOS
                                                  ? 1.30
                                                  : 1.0),
                                          verticalSpacing: 0,
                                          horizontalSpacing: 0,
                                          gridPadding: EdgeInsets.zero,
                                          initCategory: Category.RECENT,
                                          bgColor: const Color(0xFFF2F2F2),
                                          indicatorColor: Colors.blue,
                                          iconColor: Colors.grey,
                                          iconColorSelected: Colors.blue,
                                          backspaceColor: Colors.blue,
                                          skinToneDialogBgColor: Colors.white,
                                          skinToneIndicatorColor: Colors.grey,
                                          enableSkinTones: true,
                                          showRecentsTab: true,

                                          recentsLimit: 28,
                                          replaceEmojiOnLimitExceed: false,
                                          noRecents: const Text(
                                            'No Recents',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black26),
                                            textAlign: TextAlign.center,
                                          ),
                                          loadingIndicator:
                                              const SizedBox.shrink(),
                                          tabIndicatorAnimDuration:
                                              kTabScrollDuration,
                                          categoryIcons: const CategoryIcons(),
                                          buttonMode: ButtonMode.MATERIAL,
                                          checkPlatformCompatibility: true,
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  !controller.isBottom
                      ? Positioned(
                          bottom: size.longestSide * .11,
                          right: size.shortestSide * .06,
                          child: FloatingActionButton(
                            backgroundColor: mainColor,
                            onPressed: () {
                              controller.chatController!.animateTo(
                                  controller
                                      .chatController!.position.minScrollExtent,
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOut);
                            },
                            child:
                                const Icon(Icons.keyboard_arrow_down_rounded),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
