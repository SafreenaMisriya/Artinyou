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
    this.messageid = '',
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return MessageModel(
      fromId: json['fromId'] ?? '',
      message: json['message'] ?? '',
      toId: json['toId'] ?? '',
      time: json['time'] ?? '',
      toIdname: json['toIdname'] ?? '',
      read: json['read'] ?? '',
      messageid: id,
      type: json['type'] == Type.image.name ? Type.image : Type.text,
    );
  }

  Map<String, dynamic> toJson() => {
        'fromId': fromId,
        'message': message,
        'toId': toId,
        'time': time,
        'toIdname': toIdname,
        'read': read,
        'messageid': messageid,
        'type': type.name,
      };

  MessageModel copyWith({
    String? fromId,
    String? message,
    String? toId,
    String? time,
    String? toIdname,
    String? read,
    String? messageid,
    Type? type,
  }) {
    return MessageModel(
      fromId: fromId ?? this.fromId,
      message: message ?? this.message,
      toId: toId ?? this.toId,
      time: time ?? this.time,
      toIdname: toIdname ?? this.toIdname,
      read: read ?? this.read,
      messageid: messageid ?? this.messageid,
      type: type ?? this.type,
    );
  }
}

enum Type { image, text }
