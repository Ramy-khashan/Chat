import 'package:chat/cubit/main_page_cubit/main_page_cubit.dart';
import 'package:chat/presentation/edit_profile/edit_profile_page.dart';
import 'package:chat/presentation/main_page/widgets/head_main_page.dart';
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
  const MainPageScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => MainPageCubit()..getImage(id: id),
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
                                builder: (context) => EditProfileScreen()));
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
                            ? StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .where(
                                      "userId",
                                      isNotEqualTo: id,
                                    )
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot>
                                        snapshotSearch) {
                                  if (controller
                                      .searchController.text.isEmpty) {
                                    return const SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                        child: Text("No Result Found"),
                                      ),
                                    );
                                  } else if (snapshotSearch.hasData) {
                                    return SizedBox(
                                      child: ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        itemBuilder: (context, index) {
                                          if (snapshotSearch.data!.docs[index]
                                              .get("name")
                                              .toString()
                                              .contains(controller
                                                  .searchController.text
                                                  .trim())) {
                                            return ListTile(
                                              onTap: () {},
                                              leading: ImageAvatarItem(
                                                img: snapshotSearch
                                                    .data!.docs[index]
                                                    .get("img"),
                                                size: size,
                                                bgColor: mainColor,
                                                radius: .07,
                                              ),
                                              title: Text(snapshotSearch
                                                  .data!.docs[index]
                                                  .get("name")),
                                            );
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        },
                                        itemCount:
                                            snapshotSearch.data!.docs.length,
                                      ),
                                    );
                                  } else {
                                    return const LoadingItem();
                                  }
                                })
                            : controller.frindes.isEmpty
                                ? Center(
                                    child: Text(
                                    "Add frinds to chat with them",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: size.shortestSide * .06),
                                  ))
                                : StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("users")
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ChatPageScreen()));
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: size.longestSide * .01,
                                                ),
                                                child: ListTile(
                                                  leading: ImageAvatarItem(
                                                    size: size,
                                                    bgColor: mainColor,
                                                    radius: .07,
                                                  ),
                                                  title: const Text("Name"),
                                                  subtitle: const Text(
                                                      "Last Message"),
                                                  trailing: const Text("date"),
                                                )),
                                          ),
                                          itemCount: 20,
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
