
abstract class ChatState {}

class ChatInitial extends ChatState {}
class SendMessageState extends ChatState {}
class GetUserImageState extends ChatState {}
class StartGetChatIdState extends ChatState {}
class GetChatIdState extends ChatState {}
class FaildGetChatIdState extends ChatState {}
class ShowMsgTimeState extends ChatState {}
