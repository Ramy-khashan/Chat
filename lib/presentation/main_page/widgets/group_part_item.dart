 
import 'package:chat/core/Widgets/create_group.dart';
import 'package:chat/presentation/group_chat/view/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Widgets/button.dart';
import '../../../core/Widgets/image_avatar.dart';
import '../../../core/Widgets/loading.dart';
import '../../../core/constant.dart';
import '../../../cubit/main_page_cubit/main_page_cubit.dart';
import '../../../cubit/main_page_cubit/main_page_state.dart';

class GroupPartItem extends StatefulWidget {
  final String id;
  const GroupPartItem({Key? key, required this.id}) : super(key: key);

  @override
  State<GroupPartItem> createState() => _GroupPartItemState();
}

class _GroupPartItemState extends State<GroupPartItem>
    with SingleTickerProviderStateMixin {
  late AnimationController sheetController;
  @override
  void initState() {
    sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    sheetController.animateTo(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<MainPageCubit, MainPageState>(
      builder: (context, state) {
        final controller = MainPageCubit.get(context);
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.shortestSide * .06,
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("group")
                .where(
                  "users",
                  arrayContains: widget.id,
                )
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.docs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Spacer()
,
                            Image.asset("assets/image/empty1.png",color: Colors.grey.shade300, scale: 1.5,),
                                SizedBox(
                              height: size.longestSide*.05,
                            ),
                            Text(
                              "You not in any Group",
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                  fontSize: size.shortestSide * .05,
                                  fontWeight: FontWeight.bold),
                            ),
                          
                            Spacer()
,                            ButtonITem(
                                size: size,
                                onTap: () {
                                  createGroupModelSheet(
                                      context: context,
                                      sheetController: sheetController,
                                      size: size,
                                      controller: controller,
                                      id: widget.id);
                                  setState(() {});
                                },
                                head: "Crate Group")
                          ],
                        ))
                    : ListView.builder(
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupChatScreen(
                                      groupMember: List.from(snapshot.data!.docs[index].get("users")),
                                        userId: widget.id,
                                        groupId: snapshot.data!.docs[index].id,
                                        groupName: snapshot.data!.docs[index]
                                            .get("group_name"),
                                        groupImage: snapshot.data!.docs[index]
                                            .get("group_img")),
                                  ));
                            },
                            child: Padding(
                               padding: EdgeInsets.only(
                                    top: size.longestSide * .02,
                                  ),
                              child: ListTile(
                                  leading: ImageAvatarItem(
                                    img: snapshot.data!.docs[index]
                                        .get("group_img"),
                                    size: size,
                                    bgColor: mainColor,
                                    radius: .07,
                                  ),
                                  title: Text(
                                    snapshot.data!.docs[index].get("group_name"),
                                    style: TextStyle(
                                        fontSize: size.shortestSide * .05 ,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ),
                        ),
                        itemCount: snapshot.data!.docs.length,
                      );
              } else {
                return const LoadingItem();
              }
            },
          ),
        );
      },
    );
  }
}
