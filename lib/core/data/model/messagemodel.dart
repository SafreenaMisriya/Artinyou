import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String fromId;
  final String toId;
  final String message;
  final Timestamp timestamp;
  MessageModel({
    required this.fromId,
    required this.message,
    required this.toId,
    required this.timestamp,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      fromId: json['fromId']??'',
      message:json['message']??" " ,
      toId:json['toId']??" " ,
      timestamp: json['timestamp']?? Timestamp.now(),
    );
  }
}
