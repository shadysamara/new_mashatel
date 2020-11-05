import 'package:mashatel/features/messanger/models/message_model.dart';

class Chat {
  String userName;
  Message lastMessage;
  String userId;

  Chat(this.lastMessage, this.userName);
  Chat.fromMap(Map map) {
    this.userName = map['userName'];
    this.lastMessage = map['lastMessage'];
    this.userId = map['userId'];
  }
}
