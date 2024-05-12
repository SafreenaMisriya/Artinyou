class LikeModel {
  final String userid;
  final bool isliked;
  LikeModel({
    required this.userid,
    required this.isliked,
  });
    factory LikeModel.fromJson(Map<String, dynamic> json,) {
    return LikeModel(
      userid:json['userid']??"" ,
      isliked:json['liked']??'',

    );
  }
}