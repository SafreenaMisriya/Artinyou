import 'package:art_inyou/core/data/model/likemodel.dart';
import 'package:art_inyou/core/domain/likes_fetching.dart';
import 'package:art_inyou/core/presentation/bloc/post/bloc/post_bloc.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';

likeFunction(final String userId, final String postId, final PostBloc bloc) {
  return BlocBuilder<PostBloc, PostState>(
    builder: (context, state) {
      return FutureBuilder<int>(
        future: getPostLikeCount(postId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            int likeCount = snapshot.data?? 0;
            return LikeButton(
              size: 25,
              circleColor: CircleColor(
                start: redcolor,
                end: Colors.blue,
              ),
              bubblesColor: BubblesColor(
                dotPrimaryColor: color,
                dotSecondaryColor: redcolor,
              ),
              likeBuilder: (bool isliked) {
                return Icon(
                  Icons.favorite_outlined,
                  color: isliked? redcolor : Colors.grey, 
                  size: 25,
                );
              },
              likeCount: likeCount,
              onTap: (bool isLiked) async {
                LikeModel model = LikeModel(userid: userId, isliked:isLiked); 
                bloc.add(PostlikeEvent(model: model, postid: postId));
                 return !isLiked;
              },
            );
          }
        },
      );
    },
  );
}
