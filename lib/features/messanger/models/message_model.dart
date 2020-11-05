import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String recieverId;
  String hour;
  String date;
  String text;
  FieldValue timestamp;

  Message(
      {this.senderId,
      this.text,
      this.hour,
      this.date,
      this.timestamp,
      this.recieverId});
  Message.frmMap(Map map) {
    this.senderId = map['senderId'];
    this.recieverId = map['recieverId'];
    this.hour = map['hour'];
    this.date = map['date'];
    this.text = map['text'];
  }
  toJson() {
    return {
      'senderId': this.senderId,
      'recieverId': this.recieverId,
      'hour': this.hour,
      'date': this.date,
      'text': this.text,
      'timeStamp': this.timestamp
    };
  }
}
