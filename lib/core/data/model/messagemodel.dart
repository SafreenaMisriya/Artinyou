
class MessageModel {
  final String fromId;
  final String toId;
  final String message;
  final String time;
  final String toIdname;
  final String read;
  final String messageid;
  final Type type;
  MessageModel({
    required this.fromId,
    required this.message,
    required this.toId,
    required this.time,
    required this.toIdname,
    required this.read,
    required this.type,
    this.messageid='',
     

  });
  factory MessageModel.fromJson(Map<String, dynamic> json,{String id = ''}) {
    return MessageModel(
      fromId: json['fromId']??'',
      message:json['message']??" " ,
      toId:json['toId']??" " ,
      time: json['time']?? '',
      toIdname: json['toIdname']??"",
      read: json['read']??'',
      messageid: id,
      type: json['type']==Type.image.name? Type.image:Type.text,
    );
  }
   Map<String, dynamic> toJson() => {
        'fromId': fromId,
        'message': message,
        'toId': toId,
        'time': time,
        'toIdname': toIdname,
        'read':read,
        'messageid': messageid,
        'type': type.name,
      };
}
enum Type{image,text}
