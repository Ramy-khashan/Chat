import 'package:flutter/material.dart';

Color mainColor = Colors.blue.shade700;
BoxDecoration decoration = BoxDecoration(
    boxShadow: [
      BoxShadow(
          spreadRadius: 6, blurRadius: 15, color: Colors.black.withOpacity(.2))
    ],
    borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40), topRight: Radius.circular(40)),
    color: Colors.white);
