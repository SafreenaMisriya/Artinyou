
class ProfileModel {
  final String? imageurl;
  final String username;
  final String bio;
  final String userid;
  final List following;
  final List followers;
  
  ProfileModel(
      {required this.username,
      required this.bio,
      required this.imageurl,
      required this.userid,
      required this.followers,
      required this.following,
});

  factory ProfileModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return ProfileModel(
      imageurl: json['imageUrl'] ?? '',
      username: json['username'] ?? '',
      bio: json['bio'] ?? '',
      userid: id,
      followers:List.from( json['followers']??[]),
      following: List.from(json['following']??[]),

    );
  }
}

