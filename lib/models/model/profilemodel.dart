
class ProfileModel {
  final String? imageurl;
  final String username;
  final String bio;
  final String userid;
  
  ProfileModel(
      {required this.username,
      required this.bio,
      required this.imageurl,
      required this.userid,
});

  factory ProfileModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return ProfileModel(
      imageurl: json['imageUrl'] ?? '',
      username: json['username'] ?? '',
      bio: json['bio'] ?? '',
      userid: id,

    );
  }
}

