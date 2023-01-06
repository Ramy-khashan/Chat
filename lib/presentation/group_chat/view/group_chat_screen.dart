import 'package:chat/core/Widgets/loading.dart';
import 'package:chat/cubit/group_chat/group_chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../../../core/Widgets/chat_textfield.dart';
import '../../../core/constant.dart';
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
                                      .collection("croup_chat")
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
                                        itemBuilder: (context, index) =>
                                            GroupMsgShapeItem(
                                                date: snapshot.data!.docs[index]
                                                    .get("date") as Timestamp,
                                                userImage: snapshot
                                                    .data!.docs[index]
                                                    .get("userImage"),
                                                userName: snapshot
                                                    .data!.docs[index]
                                                    .get("userName"),
                                                isMyMsg: userId ==
                                                    snapshot.data!.docs[index]
                                                        .get("userId"),
                                                message: snapshot
                                                    .data!.docs[index]
                                                    .get("msg"),
                                                size: size),
                                        itemCount: snapshot.data!.docs.length,
                                      );
                                    } else {
                                      return const LoadingItem();
                                    }
                                  }),
                            ),
                            ChatTextFieldItem(
                                isdisable: controller.isdisable,
                                onTapEmoij: () {
                                  controller.setEmoji();
                                },
                                isEmoji: controller.isEmoji,
                                onSendMessage: () async {
                                  if (controller.groupChatController.text
                                      .trim()
                                      .isNotEmpty) {
                                    await FirebaseFirestore.instance
                                        .collection("group")
                                        .doc(controller.groupId)
                                        .collection("croup_chat")
                                        .add({
                                      "msg": controller.groupChatController.text
                                          .trim(),
                                      "userImage": controller.userImage.trim(),
                                      "userName": controller.userName.trim(),
                                      "date": DateTime.now(),
                                      "userId": userId
                                    }).whenComplete(() {
                                      controller.groupChatController.clear();
                                    });
                                  }
                                },
                                size: size,
                                messageController:
                                    controller.groupChatController),
                           Offstage(
                offstage: !controller.isEmoji,
                child: SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      textEditingController: controller.groupChatController,
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
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        loadingIndicator: const SizedBox.shrink(),
                        tabIndicatorAnimDuration: kTabScrollDuration,
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
                            child: const Icon(Icons.keyboard_arrow_down_rounded),
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
