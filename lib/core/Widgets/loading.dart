import 'dart:io';

import 'package:chat/core/constant.dart';
import 'package:flutter/material.dart';

class LoadingItem extends StatelessWidget {
  const LoadingItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isAndroid
          ? CircularProgressIndicator(
              color: mainColor,
            )
          : const CircularProgressIndicator.adaptive(),
    );
  }
}
