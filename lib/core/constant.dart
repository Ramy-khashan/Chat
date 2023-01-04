import 'package:flutter/material.dart';

Color mainColor = const Color.fromARGB(255, 32, 129, 159).withOpacity(.7);
BoxDecoration decoration = BoxDecoration(
    boxShadow: [
      BoxShadow(
          spreadRadius: 6, blurRadius: 15, color: Colors.black.withOpacity(.2))
    ],
    borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(40), topRight: Radius.circular(40)),
    color: Colors.black);
