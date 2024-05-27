// ignore_for_file: library_private_types_in_public_api

import 'package:art_inyou/core/data/repository/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:art_inyou/core/data/model/likemodel.dart';
import 'package:art_inyou/core/domain/likes_fetching.dart';
import 'package:art_inyou/core/presentation/bloc/post/bloc/post_bloc.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';

FirestoreService service = FirestoreService();

class LikeButtonWidget extends StatefulWidget {
  final String userId;
  final String postId;
  final PostBloc bloc;

  const LikeButtonWidget({super.key, 
    required this.userId,
    required this.postId,
    required this.bloc,
  });

  @override
  _LikeButtonWidgetState createState() => _LikeButtonWidgetState();
}

class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  late Future<int> _likeCountFuture;
  late Future<bool> _isLikedFuture;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    setState(() {
      _likeCountFuture = getPostLikeCount(widget.postId);
      _isLikedFuture = service.getUserLikeStatus(widget.userId, widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostlikeEvent) {
          _loadInitialData();
        }
      },
      child: FutureBuilder<int>(
        future: _likeCountFuture,
        builder: (context, likeCountSnapshot) {
          if (likeCountSnapshot.hasError) {
            return Text('Error: ${likeCountSnapshot.error}');
          } else {
            int likeCount = likeCountSnapshot.data ?? 0;
            return FutureBuilder<bool>(
              future: _isLikedFuture,
              builder: (context, isLikedSnapshot) {
                if (isLikedSnapshot.hasError) {
                  return Text('Error: ${isLikedSnapshot.error}');
                } else {
                  bool isLiked = isLikedSnapshot.data ?? false;
                  return  LikeButton(
                        size: 25,
                        circleColor: CircleColor(
                          start: redcolor,
                          end: Colors.blue,
                        ),
                        bubblesColor: BubblesColor(
                          dotPrimaryColor: color,
                          dotSecondaryColor: redcolor,
                        ),
                        isLiked: isLiked,
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.favorite_outlined,
                            color: isLiked ? redcolor : iconcolor,
                            size: 25,
                          );
                        },
                        likeCount: likeCount,
                        onTap: (bool isLiked) async {
                          LikeModel model = LikeModel(
                            userid: widget.userId,
                            isliked: !isLiked,
                          );
                          widget.bloc.add(PostlikeEvent(
                            model: model,
                            postid: widget.postId,
                          ));
                          return !isLiked;
                        },
                      );
                }
              },
            );
          }
        },
      ),
    );
  }
}
