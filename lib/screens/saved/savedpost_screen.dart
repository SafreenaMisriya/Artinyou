// ignore_for_file: must_be_immutable

import 'package:art_inyou/models/model/postmodel.dart';
import 'package:art_inyou/repositories/save/savedpost_fetching.dart';
import 'package:art_inyou/blocs/post/bloc/post_bloc.dart';
import 'package:art_inyou/blocs/save/bloc/save_bloc.dart';
import 'package:art_inyou/screens/home/showimage_screen.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/widgets/alertdialog/alertdialog.dart';
import 'package:art_inyou/widgets/appbar/customappbar.dart';
import 'package:art_inyou/widgets/image_handling/carosel.dart';
import 'package:art_inyou/widgets/comment/comment_post.dart';
import 'package:art_inyou/widgets/like/like_buttonscreen.dart';
import 'package:art_inyou/utils/loading_view/loadining.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SavedPostScreen extends StatelessWidget {
  SavedPostScreen({super.key});

  late PostBloc postbloc;
  late SaveBloc saveBloc;
  @override
  Widget build(BuildContext context) {
    postbloc = BlocProvider.of<PostBloc>(context);
    saveBloc = BlocProvider.of<SaveBloc>(context);
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';
    return SafeArea(
      child: Scaffold(
        appBar: customAppbartop(context, 'Saved Post'),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: fetchSaved(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      List<PostModel>? post = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocConsumer<SaveBloc, SaveState>(
                          listener: (context, state) {
                            if (state is Savedeletesuccess) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Removed Successfully'),
                              ));
                            } else if (state is Savesuccess) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Saved Successfully'),
                              ));
                            } else if (state is Saveloading) {
                              buildShimmerGridView(height, width);
                            }
                          },
                          builder: (context, state) {
                            return BlocBuilder<SaveBloc, SaveState>(
                              builder: (context, state) {
                                return MasonryGridView.builder(
                                  itemCount: post!.length,
                                  gridDelegate:
                                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemBuilder: (context, index) => Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(11),
                                              child: post[index]
                                                      .imageUrl
                                                      .contains(',')
                                                  ? buildCarousel(
                                                      post[index].imageUrl,
                                                      context,
                                                      post[index].title,
                                                      post[index].about,
                                                      post[index].softprice,
                                                      post[index].username,
                                                      post[index].hardprice)
                                                  : GestureDetector(
                                                      child: SizedBox(
                                                          height: height * 0.3,
                                                          child: post[index]
                                                                  .imageUrl
                                                                  .isNotEmpty
                                                              ? CachedNetworkImage(
                                                                  imageUrl: post[
                                                                          index]
                                                                      .imageUrl,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : const Placeholder()),
                                                      onTap: () =>
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          FullimageScreen(
                                                                            title:
                                                                                post[index].title,
                                                                            about:
                                                                                post[index].about,
                                                                            softprice:
                                                                                post[index].softprice,
                                                                            hardprice:
                                                                                post[index].hardprice,
                                                                            singleImagePath:
                                                                                post[index].imageUrl,
                                                                            postBloc:
                                                                                postbloc,
                                                                            postid:
                                                                                post[index].postid,
                                                                            userid:
                                                                                userId,
                                                                            name:
                                                                                post[index].username,
                                                                          )))),
                                            ),
                                            Positioned(
                                              top: 10,
                                              left: 50,
                                              child: Text(
                                                post[index].title,
                                                style: MyFonts.iconTextStyle,
                                              ),
                                            ),
                                            Positioned(
                                              top: 3,
                                              right: 0,
                                              child: PopupMenuButton(
                                                iconColor: Colors.white,
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                    child: Text('Share'),
                                                  ),
                                                  PopupMenuItem(
                                                    child: const Text('Remove'),
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ConfirmationDialog(
                                                                message:
                                                                    'Are You sure you want to remove this ?',
                                                                onYesPressed:
                                                                    () {
                                                                  saveBloc.add(SavedeletePostEvent(
                                                                      postid: post[
                                                                              index]
                                                                          .postid,
                                                                      userid:
                                                                          userId));
                                                                });
                                                          });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 30,
                                              right: 4,
                                              child: Text(
                                                '₹${post[index].softprice}',
                                                style: MyFonts.iconTextStyle,
                                              ),
                                            ),
                                            Positioned(
                                                bottom: 85,
                                                right: 4,
                                                child: LikeButtonWidget(
                                                    userId: userId,
                                                    postId: post[index].postid,
                                                    bloc: postbloc)),
                                            Positioned(
                                                bottom: 40,
                                                right: 3,
                                                child: commentFunction(
                                                    context,
                                                    post[index].postid,
                                                    postbloc,
                                                    height,
                                                    userId)),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: height * 0.03,
                                            width: height * 0.03,
                                            child: ClipOval(
                                              child: post[index]
                                                      .profileImageUrl
                                                      .isNotEmpty
                                                  ? CachedNetworkImage(
                                                      imageUrl: post[index]
                                                          .profileImageUrl,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : const Placeholder(),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          Text(
                                            post[index].username,
                                            style: MyFonts.bodyTextStyle,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('No Saved Post'),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
