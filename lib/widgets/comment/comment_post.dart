import 'package:art_inyou/repositories/comment/comment_fetching.dart';
import 'package:art_inyou/blocs/post/bloc/post_bloc.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/widgets/comment/commect_dialoge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

commentFunction(BuildContext context, String postid, PostBloc postbloc,
    double height, String userid) {
  return BlocBuilder<PostBloc, PostState>(
    builder: (context, state) {
      return FutureBuilder(
          future: getCommentCount(postid),
          builder: (context, snapshot) {
            int? commentCount = snapshot.data ?? 0;
            return Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        bottompCommentsheet(
                            context, postid, postbloc, height, userid);
                      },
                      icon:  Icon(
                        Icons.comment_rounded,
                        color:iconcolor ,
                      ),
                    ),
                    Text(
                      commentCount.toString(),
                      style: TextStyle(color:iconcolor ),
                    ),
                  ],
                ),
              ],
            );
          });
    },
  );
}
