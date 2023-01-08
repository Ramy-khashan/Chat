import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Widgets/image_avatar.dart';
import '../../../core/constant.dart';
import '../../../cubit/edit_profile_cubit/edit_profile_cubit.dart';
import '../../../cubit/edit_profile_cubit/edit_profile_state.dart';

class SelectedImageItem extends StatelessWidget {
  final Size size;
  const SelectedImageItem({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        final controller = EditProfileCubit.get(context);
        return Column(
          children: [
            SizedBox(
              height: size.longestSide * .035,
            ),
            Text(
              "Or choose photo from",
              style: TextStyle(
                  fontSize: size.shortestSide * .05, color: Colors.grey),
            ),
            SizedBox(
              height: size.longestSide * .02,
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  controller.images.length,
                  (index) => InkWell(
                    onTap: () {
                      controller.selectImage(index);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.shortestSide * .02,
                      ),
                      child: Stack(
                        children: [
                          ImageAvatarItem(
                            size: size,
                            bgColor: mainColor,
                            radius: .11,
                            img: controller.images[index],
                          ),
                          controller.selectedImage == index
                              ? Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  top: 0,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(size.shortestSide * .06),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.grey.shade300,
                                        child: Icon(
                                          Icons.done,
                                          color: Colors.green,
                                          size: size.shortestSide * .08,
                                        )),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            controller.selectedImage == -1
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 10),
                    child: Row(
                      children: [
                        const Text(
                          "Cancel Selected Image",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            controller.cancelSelected();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            primary: mainColor,
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      ],
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
            ),
            SizedBox(
              height: size.longestSide * .02,
            ),
          ],
        );
      },
    );
  }
}
