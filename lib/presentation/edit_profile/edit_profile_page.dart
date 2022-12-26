import 'dart:developer';
import 'package:chat/core/Widgets/loading.dart';
import 'package:chat/core/constant.dart';
import 'package:chat/cubit/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/Widgets/button.dart';
import '../../core/Widgets/image_avatar.dart';
import '../../cubit/edit_profile_cubit/edit_profile_state.dart';
import '../main_page/widgets/head_main_page.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
              return Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HeadMainPageItem(
                        img: controller.image,
                        isOpenSearch: false,
                        onEditProfile: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Card(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                contentPadding:
                                                    const EdgeInsets.all(10),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Your ID",
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.shortestSide *
                                                                  .055,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: mainColor),
                                                    ),
                                                    SizedBox(
                                                      height: size.height * .01,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            controller.userId,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  size.shortestSide *
                                                                      .05,
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              FlutterClipboard.copy(
                                                                      controller
                                                                          .userId)
                                                                  .whenComplete(
                                                                      () {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Id Copy Successfully");
                                                              });
                                                            },
                                                            icon: const Icon(
                                                                Icons.copy))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ));
                                    },
                                    title: const Text("Get Your Id"),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                contentPadding:
                                                    const EdgeInsets.all(10),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Add Your Frind",
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.shortestSide *
                                                                  .05,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: mainColor),
                                                    ),
                                                    SizedBox(
                                                      height: size.height * .02,
                                                    ),
                                                    TextFormField(
                                                      validator: (value) {
                                                        log("message");
                                                        if (controller
                                                                .friendIdController
                                                                .text
                                                                .trim() ==
                                                            controller.userId) {
                                                          return "Enter Friend Id Not Yours";
                                                        } else if (controller
                                                            .friendIdController
                                                            .text
                                                            .trim()
                                                            .isEmpty) {
                                                          return "This field must be fill with friend id";
                                                        }
                                                        return ";;";
                                                      },
                                                      controller: controller
                                                          .friendIdController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Frind Id",
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          borderSide:
                                                              BorderSide(
                                                                  color:
                                                                      mainColor,
                                                                  width: 1),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              controller
                                                                  .addFriend();
                                                                  setState(() {
                                                                    
                                                                  });
                                                            },
                                                            child: const Text(
                                                                "Confirm")),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Cancel")),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ));
                                    },
                                    title: const Text("Add Friend By Id"),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: const Text("Set Account To Private"),
                                    trailing: Switch(
                                        value: controller.isPrivacy!,
                                        onChanged: (value) {
                                          setState(() {
                                            controller.changePrivacy(value);
                                          });
                                        }),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
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
                                              child: controller.imageFile ==
                                                      null
                                                  ? CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              controller.image),
                                                      radius:
                                                          size.shortestSide *
                                                              .16,
                                                      backgroundColor:
                                                          mainColor,
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        color: Colors
                                                            .grey.shade200,
                                                        size:
                                                            size.shortestSide *
                                                                .13,
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage:
                                                          FileImage(controller
                                                              .imageFile!),
                                                      radius:
                                                          size.shortestSide *
                                                              .16,
                                                      backgroundColor:
                                                          mainColor,
                                                      child: Icon(
                                                        Icons.camera_alt,
                                                        color: Colors
                                                            .grey.shade200,
                                                        size:
                                                            size.shortestSide *
                                                                .13,
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: size.shortestSide * .02),
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
                                                    img: controller
                                                        .images[index],
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
                                            controller:
                                                controller.nameController,
                                            decoration: InputDecoration(
                                                fillColor: Colors.grey.shade200,
                                                filled: true,
                                                hintText: "Change your name",
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
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
                                                if (controller.imageFile !=
                                                    null) {
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
                                        ),
                                        ButtonITem(
                                            size: size,
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  content: Column(
                                                    children: [
                                                      TextFormField(
                                                        validator: (val) {
                                                          return val!.isEmpty
                                                              ? "lol"
                                                              : null;
                                                        },
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            controller.valid();
                                                          },
                                                          child: Text("child"))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            head: "valid")
                                      ],
                                    ),
                                  ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
