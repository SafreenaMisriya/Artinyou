import 'package:art_inyou/models/model/commentmodel.dart';
import 'package:art_inyou/repositories/comment/comment_fetching.dart';
import 'package:art_inyou/blocs/post/bloc/post_bloc.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/date_and_time/date_time.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
bottompCommentsheet(BuildContext context, String postid, PostBloc postBloc,
    double height, String userid) {
  showModalBottomSheet(
    backgroundColor: color,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(40),
      ),
    ),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: height * 0.5,
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<PostBloc, PostState>(
                      builder: (context, state) {
                        return FutureBuilder(
                            future: getComments(postid),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return  Center(
                                    child:SpinKitFadingCircle(color: redcolor,));
                              } else if (snapshot.hasData) {
                                List<CommentModel> comments = snapshot.data!;
                                return ListView.builder(
                                  itemCount: comments.length,
                                  itemBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return ListTile(
                                        leading: SizedBox(
                                          height: height * 0.05,
                                          width: height * 0.05,
                                          child: ClipOval(
                                            child: comments[index]
                                                    .profileImageUrl
                                                    .isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl: comments[index]
                                                        .profileImageUrl,
                                                    fit: BoxFit.cover,
                                                  )
                                                : const Placeholder(),
                                          ),
                                        ),
                                        title: Text(
                                          comments[index].text,
                                          style: MyFonts.boldTextStyle,
                                        ),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(comments[index].username),
                                            Text(comments[index]
                                                .time
                                                .toString()),
                                          ],
                                        ),
                                        trailing: PopupMenuButton(
                                            itemBuilder: (context) => [
                                                  if (userid ==
                                                      comments[index].userid)
                                                    PopupMenuItem(
                                                      child:
                                                          const Text('Delete'),
                                                      onTap: () {
                                                        postBloc.add(
                                                            CommentdeleteEvent(
                                                                postid: postid,
                                                                commentid: comments[
                                                                        index]
                                                                    .commentid));
                                                      },
                                                    ),
                                                  const PopupMenuItem(
                                                    child: Text('Share'),
                                                  ),
                                                ]));
                                  },
                                );
                              } else {
                                return const Text('No Comments');
                              }
                            });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Add comment ..',
                      style: MyFonts.boldTextStyle,
                    ),
                    onTap: () {
                      showcommentdialog(context, postid, postBloc, userid);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}

showcommentdialog(
    BuildContext context, String id, PostBloc postBloc, String userid) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add Comment'),
      content: Form(
        key: formKey,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Write a Comment..',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Comment';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if(formKey.currentState!.validate()){
               String? formattedTime = dateAndtime();

            CommentModel commentModel = CommentModel(
              userid: userid,
              text: controller.text,
              time: formattedTime!,
            );

            postBloc.add(PostCommentEvent(comment: commentModel, postid: id));
            controller.text = "";
            Navigator.pop(context);
            }
          
          },
          child: const Text('Post'),
        ),
      ],
    ),
  );
}
