import 'package:chat/core/Widgets/loading.dart';
import 'package:chat/cubit/group_chat/group_chat_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        ..initializeValue(
            groupIdInitial: groupId,
            groupImageInitial: groupImage,
            groupMemberInitial: groupMember,
            groupNameInitial: groupName,
            userIdInitial: userId),
      child: Scaffold(
        backgroundColor: Colors.blue.shade700,
        body: SafeArea(
            child: Column(
          children: [
            GroupChatHeadItem( 
              size: size, 
            ),
            BlocBuilder<GroupChatCubit, GroupChatState>(
              builder: (context, state) {
                final controller = GroupChatCubit.get(context);
                return Expanded(
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
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.shortestSide * .03,
                                      vertical: size.shortestSide * .02),
                                  reverse: true,
                                  itemBuilder: (context, index) =>
                                      GroupMsgShapeItem(
                                          date: snapshot.data!.docs[index]
                                              .get("date") as Timestamp,
                                          userImage: snapshot.data!.docs[index]
                                              .get("userImage"),
                                          userName: snapshot.data!.docs[index]
                                              .get("userName"),
                                          isMyMsg: userId ==
                                              snapshot.data!.docs[index]
                                                  .get("userId"),
                                          message: snapshot.data!.docs[index]
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
                          onSendMessage: () async {
                            if (controller.groupChatController.text
                                .trim()
                                .isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection("group")
                                  .doc(controller.groupId)
                                  .collection("croup_chat")
                                  .add({
                                "msg":
                                    controller.groupChatController.text.trim(),
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
                          messageController: controller.groupChatController)
                    ],
                  ),
                ));
              },
            ),
          ],
        )),
      ),
    );
  }
}
