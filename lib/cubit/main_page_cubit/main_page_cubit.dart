import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'dart:math' as math;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat/core/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../presentation/main_page/models/users_model.dart';
import 'main_page_state.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageInitial());
  static MainPageCubit get(ctx) => BlocProvider.of(ctx);
  bool isOpenSearch = false;
  final searchController = TextEditingController();
  final groupNameController = TextEditingController();
  bool isNextStepGroup = false;
  String image = "";
  File? imageFile;
  String? imageName;
  final picker = ImagePicker();
  openSearch() {
    isOpenSearch = !isOpenSearch;
    searchController.clear();
    emit(ShowSearchState());
  }

  int selectedTap = 0;
  onChangeTap(index) {
    selectedTap = index;
    emit(ChangeTapState());
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

  Future getGroupImage() async {
    try {
      log("enter1");
      XFile? value = await picker.pickImage(source: ImageSource.gallery);
      int ranNum = math.Random().nextInt(10000000);
      imageName = path.basename(value!.path) + ranNum.toString();
      imageFile = File(value.path);
      emit(GetGroupImageState());
      log("enter2");
    } catch (e) {
      log(e.toString());
    }
  }

  bool isLodingGroupData = false;
  Future uplodingImage(context, id) async {
    log(imageName!);
    var ref = FirebaseStorage.instance.ref("GroupImage/$imageName");
    log("Enter2");
    await ref.putFile(
      File(imageFile!.path),
    );
    await ref.getDownloadURL().then((value) async {
      image = value;
      await createGroup(context, image, id);
    }).onError<FirebaseException>((error, stackTrace) {
      isLodingGroupData = false;
      Fluttertoast.showToast(msg: error.message!);
    });
  }

  List connections = [];
  List connectionsChecks = [];
  List selectedConnections = [];

  Future createGroup(context, img, id) async {
    await FirebaseFirestore.instance.collection("group").add({
      "users": selectedConnections,
      "group_name": groupNameController.value.text.trim(),
      "group_img": img,
      "admin": id
    }).then((value) {
      FirebaseFirestore.instance
          .collection("group")
          .doc(value.id)
          .update({"group_id": value.id}).whenComplete(() {
        isLodingGroupData = false;

        Fluttertoast.showToast(msg: "Group Created Successfully");
        Navigator.pop(context);
      }).onError<FirebaseException>((error, stackTrace) {
        isLodingGroupData = false;

        Fluttertoast.showToast(
            msg: error.message ?? "Something went wrong, Check your network");
      });
    });
  }

  getFriends(id) async {
    connections = [];
    connectionsChecks = [];
    selectedConnections = [];
    selectedConnections.add(id);
    FirebaseFirestore.instance.collection("users").doc(id).get().then((value) {
      for (var element in List.from(value.get("connections"))) {
        connectionsChecks.add(0);
        connections.add(element);
      }
    });
    emit(GetFriendsState());
  }

  bool isLoadinUsers = false;
  List<UserModel>? users;
  getFriendData({required String id}) async {
    isLoadinUsers = true;
    emit(GetFriendDataLoadingState());

    users = [];

    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((value) async {
      for (var element in List.from(value.get("connections"))) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(element)
            .get()
            .then((value) {
          users!.add(UserModel(
              status: value.get('status'),
              userName: value.get('name'),
              userImg: value.get('img'),
              userId: value.get('userId'),
              lastMsg: "",
              date: ""));
        });
      }
      isLoadinUsers = false;

      emit(GetFriendDataSuccessState());
    }).onError<FirebaseException>((error, stackTrace) {
      isLoadinUsers = false;

      emit(GetFriendDataFaildState());

      Fluttertoast.showToast(msg: error.message!);
    });
  }

  addToSelected(index) {
    if (connectionsChecks[index] == 0) {
      connectionsChecks[index] = 1;
      selectedConnections.add(connections[index]);
    } else if (connectionsChecks[index] == 1) {
      connectionsChecks[index] = 0;
      selectedConnections.remove(connections[index]);
    }
  }

  getChatId({required String mineId, required String friendId}) async {
    await FirebaseFirestore.instance.collection("chats").get().then((value) {
      for (var element in value.docs) {
        List connectons = List.from(element.get("users"));
        log(connectons.toString());
        if (connectons.contains(mineId) && connectons.contains(friendId)) {
          return element;
        }
      }
    });
    emit(GetLastMsgState());
  }

  List<Map<String, dynamic>> item = [
    {"name": "ahmed", "phone": 01011738544},
    {"name": "ramy", "phone": 01011738541},
    {"name": "hussein", "phone": 01011738542},
  ];
printString(){
  print(item[0]["name"]);
}
  // List<UserModel> users = [];
}
