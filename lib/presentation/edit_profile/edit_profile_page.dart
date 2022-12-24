import 'dart:developer';
 import 'package:chat/core/Widgets/loading.dart'; 
 import 'package:chat/core/constant.dart';
import 'package:chat/cubit/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/Widgets/button.dart';
import '../../core/Widgets/image_avatar.dart';
import '../../cubit/edit_profile_cubit/edit_profile_state.dart';
import '../main_page/widgets/head_main_page.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => EditProfileCubit()
        ..getStaticImage()
        ..getInitialValues(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<EditProfileCubit, EditProfileState>(
            builder: (context, state) {
              final controller = EditProfileCubit.get(context);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeadMainPageItem(
                      img: controller.image,
                      isOpenSearch: false,
                      onEditProfile: () {},
                      icon: Icons.arrow_back,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      size: size),
                  Expanded(
                    child: Container(
                      decoration: decoration,
                      child: controller.isUpdateData
                          ? const LoadingItem()
                          : controller.isGettingDataLoad
                              ? const LoadingItem()
                              : SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(
                                    vertical: size.longestSide * .02,
                                  ),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              controller.getImage();
                                            },
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  controller.image),
                                              radius: size.shortestSide * .16,
                                              backgroundColor: mainColor,
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey.shade200,
                                                size: size.shortestSide * .13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: size.shortestSide * .02),
                                      Text(
                                        controller.name,
                                        style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: size.shortestSide * .055,
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.longestSide * .035,
                                      ),
                                      Text(
                                        "Or choose photo from",
                                        style: TextStyle(
                                            fontSize: size.longestSide * .02,
                                            color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: size.longestSide * .02,
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: List.generate(
                                            controller.images.length,
                                            (index) => InkWell(
                                              onTap: () {
                                                log(controller.images[index]);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.shortestSide * .02,
                                                ),
                                                child: ImageAvatarItem(
                                                  size: size,
                                                  bgColor: mainColor,
                                                  radius: .12,
                                                  img: controller.images[index],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.longestSide * .03,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: size.shortestSide * .1,
                                        ),
                                        child: TextField(
                                          controller: controller.nameController,
                                          decoration: InputDecoration(
                                              fillColor: Colors.grey.shade200,
                                              filled: true,
                                              hintText: "Change your name",
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.longestSide * .02,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: size.shortestSide * .1,
                                        ),
                                        child: ButtonITem(
                                            size: size,
                                            onTap: () {
                                              if (controller.imageFile!=null) {
                                                controller
                                                    .uplodingImage(context);
                                              } else {
                                                controller
                                                    .editUserData(context);
                                              }
                                            },
                                            head: "Save"),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: size.shortestSide * .1,
                                        ),
                                        child: ButtonITem(
                                            size: size,
                                            isNeedColor: true,
                                            onTap: () {
                                              controller.logout(
                                                  context: context);
                                            },
                                            color: Colors.red.shade800,
                                            head: "Log Out"),
                                      )
                                    ],
                                  ),
                                ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
