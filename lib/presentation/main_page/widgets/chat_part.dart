import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../core/Widgets/image_avatar.dart';
import '../../../core/Widgets/loading.dart';
import '../../../core/constant.dart';
import '../../chat/chat_page.dart';

class ChatPartItem extends StatelessWidget {
  final Size size;
  final String id;
  const ChatPartItem({Key? key, required this.size, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.shortestSide * .06,
      ),
      child: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("users").doc(id).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            List<String> frinds = List.from(snapshot.data!.get("connections"));
            return frinds.isEmpty
                ? Center(
                    child: Text(
                      "Add frinds to chat with them",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: size.shortestSide * .06),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(frinds[index])
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPageScreen(
                                          mineId: id,
                                          friendId: snapshot.data!.id,
                                          friendImg: snapshot.data!.get("img"),
                                          friendName:
                                              snapshot.data!.get("name"),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                        top: size.longestSide * .01,
                                      ),
                                      child: ListTile(
                                        leading: ImageAvatarItem(
                                          img: snapshot.data!.get("img"),
                                          size: size,
                                          bgColor: mainColor,
                                          radius: .07,
                                        ),
                                        title: Text(snapshot.data!.get("name")),
                                        // subtitle: const Text("Last Message"),
                                        // trailing: const Text("date"),
                                      )),
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                    itemCount:
                        List.from(snapshot.data!.get("connections")).length,
                  );
          } else {
            return const LoadingItem();
          }
        },
      ),
    );
  }
}
