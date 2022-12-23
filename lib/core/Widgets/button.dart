import '../constant.dart';
import 'package:flutter/material.dart';

class ButtonITem extends StatelessWidget {
  final Size size;
  final VoidCallback onTap;
  final String head;
  final Color? color;
  final bool isNeedColor;
  const ButtonITem({
    Key? key,
    required this.size,
    this.isNeedColor = false,
    this.color,
    required this.onTap,
    required this.head,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size.width,
        padding: EdgeInsets.symmetric(vertical: size.longestSide * .013),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: size.longestSide * .018,
              horizontal: size.shortestSide * .05,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            primary: isNeedColor ? color : mainColor,
          ),
          child: Text(
            head,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.shortestSide * .06,
              fontWeight: FontWeight.w700,
            ),
          ),
        ));
  }
}
