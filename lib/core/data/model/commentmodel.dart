

class CommentModel {
  final String text;
  final String userid;
  final String time;
   String username; 
  String profileImageUrl;
  String commentid;

  CommentModel({
    required this.text,
    required this.userid,
    required this.time,
     this.profileImageUrl ="",
     this.username= '',
     this.commentid=""
  });

  factory CommentModel.fromJson(Map<String, dynamic> json,{String id = ''}) {
    return CommentModel(
      text: json['comment'] ?? " ",
      commentid: id,
      time: json['commenttime'] ?? " ",
      username: json['commentedby'] ?? '',
      profileImageUrl: json['commentedprofile']??"",
      userid: json['commenteduserId']??""
    );
  }
}
