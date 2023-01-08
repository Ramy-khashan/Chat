import 'package:chat/core/Widgets/loading.dart';
import 'package:chat/cubit/group_chat/group_chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

import '../../../core/Widgets/chat_textfield.dart';
import '../../../core/app_keys.dart';
import '../../../core/constant.dart';
import '../../../data/reaction_data.dart';
import 'widgets/group_chat_head.dart';
import 'widgets/group_msg_shape.dart';

class GroupChatScreen extends StatelessWidget {
  final String groupId;
  final String userId;
  final String groupName;
  final List groupMember;
  final String groupImage;
  const GroupChatScreen(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.groupImage,
      required this.userId,
      required this.groupMember})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => GroupChatCubit()
        ..initScrollController()
        ..initializeValue(
            groupIdInitial: groupId,
            groupImageInitial: groupImage,
            groupMemberInitial: groupMember,
            groupNameInitial: groupName,
            userIdInitial: userId),
      child: BlocBuilder<GroupChatCubit, GroupChatState>(
        builder: (context, state) {
          final controller = GroupChatCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              return controller.systemBackButton();
            },
            child: Scaffold(
              backgroundColor: mainColor,
              body: Stack(
                children: [
                  SafeArea(
                      child: Column(
                    children: [
                      GroupChatHeadItem(
                        size: size,
                      ),
                      Expanded(
                          child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: decoration,
                        child: Column(
                          children: [
                            Expanded(
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("group")
                                      .doc(controller.groupId)
                                      .collection("group_chat")
                                      .orderBy("date", descending: true)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        controller: controller.chatController,
                                        physics: const BouncingScrollPhysics(),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: size.shortestSide * .03,
                                            vertical: size.shortestSide * .02),
                                        reverse: true,
                                        itemBuilder: (context, index) {
                                          var item = snapshot.data!.docs[index];
                                          return item.get("msg") ==
                                                  AppKeys.likeKey
                                              ? Align(
                                                  alignment: controller
                                                              .userId ==
                                                          item.get("userId")
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                                  child: Image.asset(
                                                    "assets/image/like.png",
                                                    width:
                                                        size.shortestSide * .2,
                                                  ),
                                                )
                                              : GroupMsgShapeItem(
                                                  date: item.get("date")
                                                      as Timestamp,
                                                  userImage:
                                                      item.get("userImage"),
                                                  userName:
                                                      item.get("userName"),
                                                  isMyMsg: userId ==
                                                      item.get("userId"),
                                                  message: item.get("msg"),
                                                  size: size);
                                          //  ReactionContainer<String>(
                                          //     onReactionChanged:
                                          //         (String? value) {
                                          //       if (value!.isNotEmpty) {
                                          //         controller.msgReact(
                                          //             msgId: item.id,
                                          //             reactValue:
                                          //                 item.get("react"),
                                          //             selectedReact: value);
                                          //       }
                                          //     },
                                          //     reactions: reactions,
                                          //     child: Stack(
                                          //       children: [
                                          //         GroupMsgShapeItem(
                                          //             date: item.get("date")
                                          //                 as Timestamp,
                                          //             userImage: item
                                          //                 .get("userImage"),
                                          //             userName: item
                                          //                 .get("userName"),
                                          //             isMyMsg: userId ==
                                          //                 item.get(
                                          //                     "userId"),
                                          //             message:
                                          //                 item.get("msg"),
                                          //             size: size),
                                          //         item.get("react") == -1
                                          //             ? const SizedBox
                                          //                 .shrink()
                                          //             : Positioned(
                                          //                 bottom: 0,
                                          //                 right: 4,
                                          //                 child:
                                          //                     CircleAvatar(
                                          //                   radius:
                                          //                       size.shortestSide *
                                          //                           .03,
                                          //                   foregroundImage:
                                          //                       AssetImage(
                                          //                     imgs[item.get(
                                          //                         "react")],
                                          //                   ),
                                          //                 ))
                                          //       ],
                                          //     ),
                                          //   );
                                        },
                                        itemCount: snapshot.data!.docs.length,
                                      );
                                    } else {
                                      return const LoadingItem();
                                    }
                                  }),
                            ),
                            ChatTextFieldItem(
                                isEmpty: controller.isTextFieldEmpty,
                                onClickLike: () {
                                  controller.sendLike();
                                },
                                onChange: (val) {
                                  controller.getTextFieldifEmpty(val);
                                },
                                isdisable: controller.isdisable,
                                onTapEmoij: () {
                                  controller.setEmoji();
                                },
                                isEmoji: controller.isEmoji,
                                onSendMessage: () async {
                                  controller.sendMsg();
                                },
                                size: size,
                                messageController:
                                    controller.groupChatController),
                            Offstage(
                              offstage: !controller.isEmoji,
                              child: SizedBox(
                                  height: 250,
                                  child: EmojiPicker(
                                    textEditingController:
                                        controller.groupChatController,
                                    config: Config(
                                      columns: 7,
                                       
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
                                      loadingIndicator: const SizedBox.shrink(),
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
                      ))
                    ],
                  )),
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
