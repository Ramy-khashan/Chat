import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat/core/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageInitial());
  static MainPageCubit get(ctx) => BlocProvider.of(ctx);
  bool isOpenSearch = false;
  final searchController = TextEditingController();
  openSearch() {
    isOpenSearch = !isOpenSearch;
    searchController.clear();
    emit(ShowSearchState());
  }

  String img = "";
  update() {
    emit(UpdateValueState());
  }

  initialRegister(
      {required bool isFromReg,
      required BuildContext context,
      required Size size}) {
    if (isFromReg) {
      AwesomeDialog(
          context: context,
          body: Column(
            children: [
              Text(
                "Your Email is Private Form Now, For Change Go Change From Your Profile.",
                style: TextStyle(
                  color: mainColor,
                  fontSize: size.shortestSide * 0.04,
                ),
              ),
            ],
          ),
          btnCancel: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancle")));
    } else {}
  }

  int count = 0;
  ifNotExsist() {
    count++;
    emit(IfNotExsistState());
  }

  getImage({required String id}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((value) {
      img = value.get("img");
      emit(UserImageState());
    });
  }
}
