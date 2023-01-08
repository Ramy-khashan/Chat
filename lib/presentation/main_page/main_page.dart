import 'package:chat/cubit/main_page_cubit/main_page_cubit.dart';
import 'package:chat/presentation/edit_profile/edit_profile_page.dart';
import 'package:chat/presentation/main_page/widgets/chat_part.dart';
import 'package:chat/presentation/main_page/widgets/group_part_item.dart';
import 'package:chat/presentation/main_page/widgets/head_main_page.dart';
import 'package:chat/presentation/main_page/widgets/search_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/Widgets/create_group.dart';
import '../../core/constant.dart';
import '../../cubit/main_page_cubit/main_page_state.dart';

class MainPageScreen extends StatefulWidget {
  final String id;
  final bool isFromReg;
  const MainPageScreen({Key? key, required this.id, this.isFromReg = false})
      : super(key: key);

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController sheetController;

  void setStatus(bool status) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id)
        .update({"status": status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus(true);
    } else {
      // offline
      setStatus(false);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    setStatus(true);
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

    return BlocProvider(
      create: (context) => MainPageCubit()
        ..getFriends(widget.id)
        ..initialRegister(
            isFromReg: widget.isFromReg, context: context, size: size)
        ..getImage(id: widget.id),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<MainPageCubit, MainPageState>(
            builder: (context, state) {
              final controller = MainPageCubit.get(context);
              return Column(
                children: [
                  HeadMainPageItem(
                      isNeedCreateOrder: true,
                      onTapCreateGroup: () {
                        setState(() {
                          controller.isNextStepGroup = false;
                        });
                        createGroupModelSheet(
                            context: context,
                            sheetController: sheetController,
                            size: size,
                            controller: controller,
                            id: widget.id);
                        setState(() {});
                      },
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
                            ? SearchSection(size: size, id: widget.id)
                            : Column(
                                children: [
                                  TabBar(
                                      indicatorColor: const Color.fromARGB(
                                              255, 119, 204, 230)
                                          .withOpacity(.6),
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * .02),
                                      labelColor: const Color.fromARGB(
                                          255, 206, 33, 85),
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
                                        ChatPartItem(size: size, id: widget.id),
                                        GroupPartItem(id: widget.id)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                      ),
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
