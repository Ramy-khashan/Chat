import 'package:chat/core/Widgets/button.dart';
import 'package:chat/cubit/main_page_cubit/main_page_cubit.dart';
import 'package:chat/presentation/edit_profile/edit_profile_page.dart';
import 'package:chat/presentation/main_page/widgets/chat_part.dart';
import 'package:chat/presentation/main_page/widgets/group_part_item.dart';
import 'package:chat/presentation/main_page/widgets/head_main_page.dart';
import 'package:chat/presentation/main_page/widgets/search_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
      create: (context) => MainPageCubit()..getFriends(id)
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
                    child: DefaultTabController(
                      length: 2,
                      child: Container(
                          decoration: decoration,
                          child: controller.isOpenSearch
                              ? SearchSection(size: size, id: id)
                              : Column(children: [
                                  TabBar(
                                      indicatorColor: Colors.blue.shade600,
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * .02),
                                      labelColor: Colors.amber.shade700,
                                      labelStyle: TextStyle(
                                          fontSize: size.shortestSide * .043,
                                          fontWeight: FontWeight.bold),
                                      onTap: controller.onChangeTap,
                                      tabs: const [
                                        Tab(
                                          text: "Chat",
                                        ),
                                        Tab(
                                          text: "Groups", 
                                        )
                                      ]),
                                  Expanded(
                                    child: TabBarView(
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        ChatPartItem(size: size, id: id),
                                        GroupPartItem(id: id)
                                           ],
                                    ),
                                  )
                                ])),
                    ),
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
