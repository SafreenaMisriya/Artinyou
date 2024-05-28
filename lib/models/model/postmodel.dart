
class PostModel {
  final String imageUrl;
  final String title;
  final String softprice;
  final String hardprice;
  final String category;
  final String about;
  final String userid;
  final String postid;
  String username; 
  String profileImageUrl;
   

  PostModel({
    required this.imageUrl,
    required this.title,
    required this.softprice,
    required this .hardprice,
    required this.category,
    required this.about,
        this.postid='',
        this.userid = '',
        this.username='',
        this.profileImageUrl=''
      
      
  });

  factory PostModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return PostModel(
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? '',
      softprice: json['softprice'] ?? '',
      hardprice: json['hardprice']?? '',
      category: json['category'] ?? '',
      about: json['about'] ?? '',
      postid: id,
      userid: json['postId'] ?? '',
      username: json['username'] ?? '', 
      profileImageUrl: json['profileImageUrl'] ?? '', 
    );
  }
}


