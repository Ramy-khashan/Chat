import 'package:flutter/material.dart';

 import '../../../core/Widgets/icon_button.dart';
import '../../../core/Widgets/image_avatar.dart'; 

class HeadMainPageItem extends StatelessWidget {
  final Size size;
  final VoidCallback onTap;
  final bool isOpenSearch;
  final IconData icon;
  final String img;
  final TextEditingController? searchController;
  final VoidCallback onEditProfile;
  final Function(String val)? onChangeValue;

  const HeadMainPageItem(
      {Key? key,
      this.searchController,
      this.onChangeValue,
      required this.isOpenSearch,
      required this.img,
      required this.icon,
      required this.onEditProfile,
      required this.onTap,
      required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.shortestSide * .045,
          vertical: size.longestSide * .02),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Let's Chat\n with friends",
                style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: size.shortestSide * .06,
                    fontWeight: FontWeight.w700),
              ),
              IconButtonItem(
                  icon: Icons.menu, onTap: onEditProfile, size: size),
            ],
          ),
          SizedBox(
            height: size.longestSide * .03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isOpenSearch
                  ? Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: size.shortestSide * .045,
                        ),
                        onChanged: (val) {
                          onChangeValue!(val);
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white30,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  width: 0, color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  width: 0, color: Colors.transparent),
                            ),
                            suffixIcon: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.longestSide * .01,
                                  horizontal: size.shortestSide * .03),
                              child: IconButtonItem(
                                iconColor: Colors.black,
                                icon: Icons.close,
                                onTap: onTap,
                                size: size,
                                bgColor: Colors.white,
                                iconSize: .05,
                              ),
                            )),
                      ),
                    )
                  : IconButtonItem(
                      icon: icon,
                      onTap: onTap,
                      size: size,
                    ),
              SizedBox(
                width: size.shortestSide * .03,
              ),
              ImageAvatarItem(
                size: size,
                bgColor: Colors.white,
                img: img,
              )
            ],
          )
        ],
      ),
    );
  }
}
/* 
TabBar(tabs: [Tab(text: "Chat",),Tab(text: "Groups",)]),

 */