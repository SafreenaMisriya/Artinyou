
class MessageModel {
  final String fromId;
  final String toId;
  final String message;
  final String time;
  final String toIdname;
  final bool read;
  MessageModel({
    required this.fromId,
    required this.message,
    required this.toId,
    required this.time,
    required this.toIdname,
    required this.read

  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      fromId: json['fromId']??'',
      message:json['message']??" " ,
      toId:json['toId']??" " ,
      time: json['time']?? '',
      toIdname: json['toIdname']??"",
      read: json['read']??'',
    );
  }
   Map<String, dynamic> toJson() => {
        'fromId': fromId,
        'message': message,
        'toId': toId,
        'time': time,
        'toIdname': toIdname,
        'read':read,
      };
}
