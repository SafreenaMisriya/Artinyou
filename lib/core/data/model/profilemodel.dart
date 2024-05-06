
class ProfileModel {
  final String imageurl;
  final String username;
  final String bio;
  final String userid;
  // final String createdAt;
  // final bool isOnline;
  // final String lastActive;
  // final String pushToken;
  
  ProfileModel(
      {required this.username,
      required this.bio,
      required this.imageurl,
      required this.userid,
      // this.createdAt,
      // this.isOnline,
      // this.lastActive,
      // this.pushToken,
});

  factory ProfileModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return ProfileModel(
      imageurl: json['imageUrl'] ?? '',
      username: json['username'] ?? '',
      // createdAt: json['createdAt']?? '',
      // isOnline: json['isOnline']?? '',
      // lastActive: json['lastActive']??'',
      // pushToken: json['pushToken'] ??'',
      bio: json['bio'] ?? '',
      userid: id,

    );
  }
}

