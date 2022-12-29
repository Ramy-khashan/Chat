import 'package:flutter/material.dart';

import '../constant.dart';

class BottomSheetHead extends StatelessWidget {
  final Size size;
  final String head;
  const BottomSheetHead({Key? key, required this.size, required this.head}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size.shortestSide * .26,
          height: size.height * .01,
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
        ),
        SizedBox(
          height: size.longestSide * .06,
          child: Center(
            child: Text(
              head,
              style: TextStyle(
                  color: mainColor,
                  fontSize: size.shortestSide * .045,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
