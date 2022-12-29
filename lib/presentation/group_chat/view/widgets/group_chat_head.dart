import 'dart:developer';

import 'package:chat/core/Widgets/bottom_sheet_head.dart';
import 'package:chat/core/Widgets/button.dart';
import 'package:chat/cubit/group_chat/group_chat_cubit.dart';
import 'package:chat/presentation/edit_profile/widgets/add_friend_by_id_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Widgets/icon_button.dart';
import '../../../../core/Widgets/image_avatar.dart';
import '../../../../core/constant.dart';

class GroupChatHeadItem extends StatefulWidget {
  final Size size;
  const GroupChatHeadItem({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  State<GroupChatHeadItem> createState() => _GroupChatHeadItemState();
}

class _GroupChatHeadItemState extends State<GroupChatHeadItem> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupChatCubit, GroupChatState>(
      listener: (context, state) {
        if (state is ChangeGroupInfoSuccessfullyState) {
          setState(() {
            GroupChatCubit.get(context).groupName = state.head;
            GroupChatCubit.get(context).groupImage = state.img;
          });
        }
      },
      builder: (context, state) {
        final controller = GroupChatCubit.get(context);
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.size.shortestSide * .05,
            vertical: widget.size.longestSide * .03,
          ),
          child: Row(
            children: [
              IconButtonItem(
                icon: Icons.arrow_back,
                onTap: () {
                  Navigator.pop(context);
                },
                size: widget.size,
                bgColor: Colors.transparent,
              ),
              const Spacer(),
              ImageAvatarItem(
                size: widget.size,
                img: controller.groupImage,
                bgColor: Colors.white,
                radius: .065,
              ),
              SizedBox(width: widget.size.shortestSide * .035),
              Text(
                controller.groupName,
                style: TextStyle(
                    fontSize: widget.size.shortestSide * .06,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const Spacer(),
              IconButtonItem(
                icon: Icons.adaptive.more,
                onTap: () {
                  controller.goGroupOptions();
                  showModalBottomSheet(
                    context: context,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    enableDrag: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BottomSheetHead(
                                  size: widget.size,
                                  head: controller.isChangeGroupInfo
                                      ? "Update Group Info"
                                      : "Group Options"),
                              controller.isChangeGroupInfo
                                  ? Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextField(
                                                controller: controller
                                                    .groupNameController,
                                                decoration: InputDecoration(
                                                  hintText: "Group Name",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide(
                                                        color: mainColor,
                                                        width: 1),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: widget
                                                            .size.longestSide *
                                                        .025),
                                                child: Text("Group Image",
                                                    style: TextStyle(
                                                        fontSize: widget.size
                                                                .shortestSide *
                                                            .045,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await controller
                                                      .getGroupImage()
                                                      .whenComplete(() {
                                                    setState(() {});
                                                  });
                                                },
                                                child: Container(
                                                  width:
                                                      widget.size.shortestSide *
                                                          .45,
                                                  height:
                                                      widget.size.longestSide *
                                                          .16,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            spreadRadius: 3,
                                                            blurRadius: 4,
                                                            color: Colors
                                                                .grey.shade300)
                                                      ]),
                                                  child: controller.imageFile ==
                                                          null
                                                      ? const Center(
                                                          child: Icon(Icons
                                                              .add_a_photo),
                                                        )
                                                      : Image.file(controller
                                                          .imageFile!),
                                                ),
                                              ),
                                              const Spacer(),
                                              ButtonITem(
                                                  size: widget.size,
                                                  onTap: () {
                                                    if (controller.imageFile ==
                                                        null) {
                                                      log(controller.groupId);
                                                      controller.updateGroupInf(
                                                          context,
                                                          controller.groupId
                                                              .trim(),
                                                          controller.groupImage,
                                                          controller.groupName);
                                                    } else {
                                                      controller.uplodingImage(
                                                          context,
                                                          controller.groupId,
                                                          controller.groupName);
                                                    }
                                                    setState(() {});
                                                  },
                                                  head: "Update")
                                            ]),
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          left: widget.size.shortestSide * .02,
                                          right: widget.size.shortestSide * .02,
                                          bottom:
                                              widget.size.shortestSide * .025),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AddFriendById(
                                              controller: controller
                                                  .groupNewMembereController,
                                              onTap: () {
                                                controller.addFriend(
                                                    context: context,
                                                    id: controller.userId,
                                                    groupId:
                                                        controller.groupId);
                                              },
                                              size: widget.size),
                                          Card(
                                            child: ListTile(
                                              onTap: () async {
                                                controller.showGroupMember(
                                                    context: context,
                                                    size: widget.size,
                                                    groupMember:
                                                        controller.groupMember);
                                              },
                                              title: const Text(
                                                  "See Group Member"),
                                              trailing: const Icon(Icons
                                                  .arrow_forward_ios_rounded),
                                            ),
                                          ),
                                          Card(
                                            child: ListTile(
                                              onTap: () {
                                                setState(() {
                                                  controller.isChangeGroupInfo =
                                                      true;
                                                });
                                              },
                                              title: const Text(
                                                  "Change Group Name Or Photo"),
                                              trailing: const Icon(Icons
                                                  .arrow_forward_ios_rounded),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                size: widget.size,
                bgColor: Colors.transparent,
              ),
            ],
          ),
        );
      },
    );
  }
}
