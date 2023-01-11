 
class UserModel {
  
  final String userName;
  final String userImg;
  final String userId;
  final String lastMsg;
  final bool status;
  final String date;

  UserModel(
      {required this.userName,
      required this.userImg,
      required this.userId,
      required this.status,
      required this.lastMsg,
      required this.date});
}
