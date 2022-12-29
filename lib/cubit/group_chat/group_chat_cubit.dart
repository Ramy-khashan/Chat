import 'dart:developer';
import 'dart:io';

import 'package:chat/core/app_keys.dart';
import 'package:chat/presentation/group_chat/view/group_chat_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'group_chat_state.dart';

class GroupChatCubit extends Cubit<GroupChatState> {
  GroupChatCubit() : super(GroupChatInitial());
  static GroupChatCubit get(context) => BlocProvider.of(context);
  final groupChatController = TextEditingController();
  String image = "";

  final groupNewMembereController = TextEditingController();
  final groupNameController = TextEditingController();
  String userName = "";
  String userImage = "";
  bool isChangeGroupInfo = false;
  File? imageFile;

  String? imageName;
  final picker = ImagePicker();
  Future getGroupImage() async {
    try {
      XFile? value = await picker.pickImage(source: ImageSource.gallery);
      int ranNum = math.Random().nextInt(10000000);
      imageName = path.basename(value!.path) + ranNum.toString();
      imageFile = File(value.path);
      emit(GetGroupImageState());
    } catch (e) {
      log(e.toString());
    }
  }

  bool isLodingGroupData = false;
  Future uplodingImage(context, id, groupName) async {
    log(imageName!);
    var ref = FirebaseStorage.instance.ref("GroupImage/$imageName");
    log("Enter2");
    await ref.putFile(
      File(imageFile!.path),
    );
    await ref.getDownloadURL().then((value) async {
      image = value;

      await updateGroupInf(context, id, image, groupName);
    }).onError<FirebaseException>((error, stackTrace) {
      isLodingGroupData = false;
      Fluttertoast.showToast(msg: error.message!);
    });
  }

  Future updateGroupInf(context, id, img, groupName) async {
    log(groupNameController.text);
    log(img);
    log(id);
   await FirebaseFirestore.instance.collection("group").doc(id).update({
      "group_name": groupNameController.text.trim().isEmpty
          ? groupName
          : groupNameController.text.trim(),
      "group_img": img
    }).whenComplete(() {
      groupImage = img;
      groupName = groupNameController.text.trim().isEmpty
      
          ? groupName
          : groupNameController.text.trim();
          emit(ChangeGroupInfoSuccessfullyState(img: groupImage,head: groupName));
      log(groupImage);
      log(groupName);
      groupNameController.clear();
      imageFile = null;
      imageName = "";
      image = "";
    
      Fluttertoast.showToast(msg: "Save Update");
      Navigator.pop(context);

      // Navigator.(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => GroupChatScreen(
      //           groupId: groupId,
      //           groupName: groupName,
      //           groupImage: groupImage,
      //           userId: userId,
      //           groupMember: groupMember),
      //     ));
    }).onError<FirebaseException>((error, stackTrace) {
      Fluttertoast.showToast(msg: error.message!);
    });
            

  }

  goGroupOptions() {
    isChangeGroupInfo = false;
    emit(ChangeGroupOptionsState());
  }

  String groupId = "";
  String userId = "";
  String groupName = "";
  List groupMember = [];
  String groupImage = "";
  initializeValue(
      {required String groupIdInitial,
      required String groupNameInitial,
      required String groupImageInitial,
      required String userIdInitial,
      required List groupMemberInitial}) async {
    groupId = groupIdInitial;
    groupImage = groupImageInitial;
    groupMember = groupMemberInitial;
    groupName = groupNameInitial;
    userId = userIdInitial;
    emit(GetGroupDataState());
    await SharedPreferences.getInstance().then((value) {
      userName = value.getString(AppKeys.nameKey)!;
      userImage = value.getString(AppKeys.personalImageKey)!;
    });
    emit(GetUserDataState());
  }

  showGroupMember(
      {required BuildContext context,
      required Size size,
      required List groupMember}) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => SizedBox(
        height: size.longestSide * .2,
        child: AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(
                groupMember.length,
                (index) => StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(groupMember[index])
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListTile(
                        // dense: true,
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data!.get("img"),
                          ),
                        ),
                        title: Text(snapshot.data!.get("name")),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("cancel"))
          ],
        ),
      ),
    );
  }

  bool? containId;
  RegExp upperCaseRegex = RegExp(r'[A-Z]');
  RegExp lowerCaseRegex = RegExp(r'[a-z]');
  RegExp containNumberRegex = RegExp(r'[0-9]');
  Future addFriend(
      {required BuildContext context,
      required String id,
      required String groupId}) async {
    if (groupNewMembereController.text.trim() == id) {
      Fluttertoast.showToast(msg: "Enter Friend Id Not Yours");
    } else if (groupNewMembereController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "This field must be fill with friend id");
    } else if (!groupNewMembereController.text
            .trim()
            .contains(upperCaseRegex) ||
        !groupNewMembereController.text.trim().contains(lowerCaseRegex) ||
        groupNewMembereController.text.trim().length != 20 ||
        !groupNewMembereController.text.trim().contains(containNumberRegex)) {
      Fluttertoast.showToast(msg: "Enter Your");
    } else {
      containId = false;
      await FirebaseFirestore.instance
          .collection("group")
          .doc(groupId)
          .get()
          .then((value) {
        for (var element in value.get("users")) {
          if (element == groupNewMembereController.value.text.trim()) {
            containId = true;
          }
        }
      });
      if (containId!) {
        Fluttertoast.showToast(msg: "No One with this id");
      } else {
        Fluttertoast.showToast(msg: "No One with this id");
      }
    }
  }
}
