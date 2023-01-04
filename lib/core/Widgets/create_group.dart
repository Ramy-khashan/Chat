import 'dart:developer';

import 'package:chat/cubit/main_page_cubit/main_page_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant.dart';
import 'bottom_sheet_head.dart';
import 'button.dart';
import 'loading.dart';

createGroupModelSheet(
    {required BuildContext context,
    sheetController,
    required Size size,
    required MainPageCubit controller,
    required String id}) {
  return showModalBottomSheet(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    transitionAnimationController: sheetController,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          child: Column(
            children: [
              BottomSheetHead(
                size: size,
                head: controller.isNextStepGroup
                    ? "Enter Group Info"
                    : "Choose Group Member",
              ),
              controller.isNextStepGroup
                  ? Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: controller.groupNameController,
                              decoration: InputDecoration(
                                hintText: "Group Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(color: mainColor, width: 1),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.longestSide * .025),
                              child: Text("Group Image",
                                  style: TextStyle(
                                      fontSize: size.shortestSide * .045,
                                      fontWeight: FontWeight.w600)),
                            ),
                            InkWell(
                              onTap: () async {
                                await controller
                                    .getGroupImage()
                                    .whenComplete(() {
                                  log("enter0");

                                  setState(() {});
                                });
                              },
                              child: Container(
                                width: size.shortestSide * .45,
                                height: size.longestSide * .16,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 3,
                                          blurRadius: 4,
                                          color: Colors.grey.shade300)
                                    ]),
                                child: controller.imageFile == null
                                    ? const Center(
                                        child: Icon(Icons.add_a_photo),
                                      )
                                    : Image.file(controller.imageFile!),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : controller.connections.isEmpty
                      ? Expanded(
                          child: Center(
                              child: Text(
                          "You have no Frinds to create group",
                          style: TextStyle(
                              fontSize: size.shortestSide * .05,
                              fontWeight: FontWeight.w600),
                        )))
                      : Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => StreamBuilder<
                                    DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(controller.connections[index])
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot>
                                        userSnapshot) {
                                  if (userSnapshot.hasData) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            userSnapshot.data!.get("img")),
                                      ),
                                      title:
                                          Text(userSnapshot.data!.get("name")),
                                      trailing: Checkbox(
                                        value: controller
                                                    .connectionsChecks[index] ==
                                                0
                                            ? false
                                            : true,
                                        onChanged: (value) {
                                          controller.addToSelected(index);
                                          setState(() {});
                                        },
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                }),
                            itemCount: controller.connections.length,
                          ),
                        ),
              controller.connections.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.shortestSide * 0.05),
                      child: controller.isLodingGroupData
                          ? const LoadingItem()
                          : ButtonITem(
                              head: controller.isNextStepGroup
                                  ? "Create"
                                  : "Next",
                              onTap: controller.isNextStepGroup
                                  ? () async {
                                      setState(() {
                                        controller.isLodingGroupData = true;
                                      });
                                      await controller.uplodingImage(
                                          context, id);
                                    }
                                  : () {
                                      if (controller
                                              .selectedConnections.length >
                                          1) {
                                        log(controller.selectedConnections
                                            .toString());
                                        setState(() {
                                          controller.isNextStepGroup = true;
                                        });
                                        log(controller.isNextStepGroup
                                            .toString());
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Chosse Frinds To Create Group");
                                      }
                                    },
                              size: size,
                            ),
                    ),
            ],
          ),
        );
      });
    },
  );
}
