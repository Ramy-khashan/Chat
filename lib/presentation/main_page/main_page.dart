import 'package:chat/cubit/main_page_cubit/main_page_cubit.dart';
import 'package:chat/presentation/edit_profile/edit_profile_page.dart';
import 'package:chat/presentation/main_page/widgets/head_main_page.dart';
import 'package:chat/presentation/main_page/widgets/search_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/Widgets/image_avatar.dart';
import '../../core/Widgets/loading.dart';
import '../../core/constant.dart';
import '../../cubit/main_page_cubit/main_page_state.dart';
import '../chat/chat_page.dart';

class MainPageScreen extends StatelessWidget {
  final String id;
  final bool isFromReg;
  const MainPageScreen({Key? key, required this.id, this.isFromReg = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => MainPageCubit()
        ..initialRegister(isFromReg: isFromReg, context: context, size: size)
        ..getImage(id: id),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<MainPageCubit, MainPageState>(
            builder: (context, state) {
              final controller = MainPageCubit.get(context);
              return Column(
                children: [
                  HeadMainPageItem(
                      img: controller.img,
                      icon: Icons.search,
                      onChangeValue: (val) {
                        controller.update();
                      },
                      searchController: controller.searchController,
                      isOpenSearch: controller.isOpenSearch,
                      onEditProfile: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditProfileScreen()));
                      },
                      onTap: () {
                        controller.openSearch();
                      },
                      size: size),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.shortestSide * .06,
                        ),
                        decoration: decoration,
                        child: controller.isOpenSearch
                            ? SearchSection(size: size, id: id)
                            : StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(id)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    List<String> frinds = List.from(
                                        snapshot.data!.get("connections"));
                                    return frinds.isEmpty
                                        ? Center(
                                            child: Text(
                                              "Add frinds to chat with them",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      size.shortestSide * .06),
                                            ),
                                          )
                                        : ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                StreamBuilder<DocumentSnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection("users")
                                                        .doc(frinds[index])
                                                        .snapshots(),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                                DocumentSnapshot>
                                                            snapshot) {
                                                      if (snapshot.hasData) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ChatPageScreen(
                                                                  mineId: id,
                                                                  friendId:
                                                                      snapshot
                                                                          .data!
                                                                          .id,
                                                                  friendImg:
                                                                      snapshot
                                                                          .data!
                                                                          .get(
                                                                              "img"),
                                                                  friendName:
                                                                      snapshot
                                                                          .data!
                                                                          .get(
                                                                              "name"),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top:
                                                                    size.longestSide *
                                                                        .01,
                                                              ),
                                                              child: ListTile(
                                                                leading:
                                                                    ImageAvatarItem(
                                                                  img: snapshot
                                                                      .data!
                                                                      .get(
                                                                          "img"),
                                                                  size: size,
                                                                  bgColor:
                                                                      mainColor,
                                                                  radius: .07,
                                                                ),
                                                                title: Text(snapshot
                                                                    .data!
                                                                    .get(
                                                                        "name")),
                                                                subtitle:
                                                                    const Text(
                                                                        "Last Message"),
                                                                trailing:
                                                                    const Text(
                                                                        "date"),
                                                              )),
                                                        );
                                                      } else {
                                                        return const SizedBox();
                                                      }
                                                    }),
                                            itemCount: List.from(snapshot.data!
                                                    .get("connections"))
                                                .length,
                                          );
                                  } else {
                                    return const LoadingItem();
                                  }
                                })),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
