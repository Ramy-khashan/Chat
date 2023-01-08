import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName;
  final String userrImg;
  final String lastMsg;
  final bool status;
  final Timestamp date;

  UserModel(this.status,
      {required this.userName,
      required this.userrImg,
      required this.lastMsg,
      required this.date});
}
