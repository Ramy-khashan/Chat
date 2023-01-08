import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Widgets/image_avatar.dart';
import '../../../core/Widgets/loading.dart';
import '../../../core/constant.dart';
import '../../../cubit/main_page_cubit/main_page_cubit.dart';
import '../../../cubit/main_page_cubit/main_page_state.dart';

class SearchSection extends StatelessWidget {
  final Size size;
  final String id;

  const SearchSection({Key? key, required this.size, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    log(id);
    return BlocBuilder<MainPageCubit, MainPageState>(
      builder: (context, state) {
        final controller = MainPageCubit.get(context);
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where(
                  "userId",
                  isNotEqualTo: id,
                )
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshotSearch) {
              controller.count = 0;
              if (snapshotSearch.hasData) {
                if (controller.count == snapshotSearch.data!.docs.length) {
                  return const SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "No Result Found",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemBuilder: (context, index) {
                        if (!snapshotSearch.data!.docs[index]
                            .get("isPrivate")) {
                          if (snapshotSearch.data!.docs[index]
                              .get("name")
                              .toString()
                              .trim()
                              .contains(
                                  controller.searchController.text.trim())) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: ListTile(
                                onTap: () {},
                                leading: ImageAvatarItem(
                                  img: snapshotSearch.data!.docs[index]
                                      .get("img"),
                                  size: size,
                                  bgColor: mainColor,
                                  radius: .07,
                                ),
                                title: Text(
                                  snapshotSearch.data!.docs[index].get("name"),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(id)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshotMine) {
                                      if (snapshotMine.hasData) {
                                        return InkWell(
                                          onTap: snapshotMine.data!
                                                  .get("connections")
                                                  .toString()
                                                  .contains(snapshotSearch
                                                      .data!.docs[index].id)
                                              ? () {}
                                              : () {
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(
                                                          snapshotMine.data!.id)
                                                      .update({
                                                    "connections":
                                                        FieldValue.arrayUnion([
                                                      snapshotSearch
                                                          .data!.docs[index].id
                                                    ])
                                                  });
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(snapshotSearch
                                                          .data!.docs[index].id)
                                                      .update({
                                                    "connections":
                                                        FieldValue.arrayUnion([
                                                      snapshotMine.data!.id
                                                    ])
                                                  });

                                                  FirebaseFirestore.instance
                                                      .collection("chats")
                                                      .add({
                                                    "last_msg": "",
                                                    "last_msg_date":
                                                        DateTime.now(),
                                                    "user1":
                                                        snapshotMine.data!.id,
                                                    "user2": snapshotSearch
                                                        .data!.docs[index].id,
                                                    "users": [
                                                      snapshotMine.data!.id,
                                                      snapshotSearch
                                                          .data!.docs[index].id
                                                    ],
                                                  });
                                                },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1)),
                                              padding: EdgeInsets.all(
                                                  size.shortestSide * .03),
                                              child: snapshotMine.data!
                                                      .get("connections")
                                                      .toString()
                                                      .contains(snapshotSearch
                                                          .data!.docs[index].id)
                                                  ? const Icon(
                                                      Icons.done,
                                                      color: Colors.white,
                                                    )
                                                  : const Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    )),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    }),
                              ),
                            );
                          } else {
                            controller.ifNotExsist();
                            return const SizedBox.shrink();
                          }
                        } else {
                          return const SizedBox();
                        }
                      },
                      itemCount: snapshotSearch.data!.docs.length,
                    ),
                  );
                }
              } else {
                return const LoadingItem();
              }
            });
      },
    );
  }
}
