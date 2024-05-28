// ignore_for_file: must_be_immutable

import 'package:art_inyou/models/model/postmodel.dart';
import 'package:art_inyou/blocs/bloc/post/bloc/post_bloc.dart';
import 'package:art_inyou/blocs/bloc/save/bloc/save_bloc.dart';
import 'package:art_inyou/screens/post/post_screen.dart';
import 'package:art_inyou/screens/home/showimage_screen.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/widgets/alertdialog/alertdialog.dart';
import 'package:art_inyou/widgets/image_handling/carosel.dart';
import 'package:art_inyou/widgets/comment/comment_post.dart';
import 'package:art_inyou/widgets/like/like_buttonscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class DropdownPrice extends StatelessWidget {
  final Future<List<PostModel>>? postsFuture;
  final bool visible;
  final List<PostModel>? posts;
  final String? title;
  DropdownPrice(
      {super.key,
      this.postsFuture,
      this.title,
      this.posts,
      required this.visible});
  String selectedPriceRange = 'All';
  late PostBloc postbloc;
  late SaveBloc saveBloc;
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';
    double height = Responsive.screenHeight(context);
    postbloc = BlocProvider.of<PostBloc>(context);
    saveBloc = BlocProvider.of<SaveBloc>(context);
    double width = Responsive.screenWidth(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            visible
                ? Row(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back)),
                      SizedBox(
                        width: width * 0.1,
                      ),
                      Text(
                        title ?? "Post",
                        style: MyFonts.headingTextStyle,
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                    ],
                  )
                : Container(),
            Expanded(
              child: FutureBuilder(
                future: postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LinearProgressIndicator(
                        color: redcolor,
                      ),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                        child: Shimmer.fromColors(
                            baseColor: Colors.blue,
                            highlightColor: Colors.white,
                            child: const Text(
                              'No Data Available',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            )));
                  } else if (snapshot.hasData) {
                    List<PostModel>? posts = snapshot.data;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MasonryGridView.builder(
                        itemCount: posts?.length,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: posts![index].imageUrl.contains(',')
                                        ? buildCarousel(
                                            posts[index].imageUrl,
                                            context,
                                            posts[index].title,
                                            posts[index].about,
                                            posts[index].softprice,
                                            posts[index].username,
                                            posts[index].hardprice)
                                        : GestureDetector(
                                            child: SizedBox(
                                              height: height * 0.3,
                                              child: Placeholder(
                                                child: Image.network(
                                                  posts[index].imageUrl,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullimageScreen(
                                                          title: posts[index]
                                                              .title,
                                                          about: posts[index]
                                                              .about,
                                                         softprice: posts[index]
                                                              .softprice,
                                                              hardprice: posts[index].hardprice,
                                                          singleImagePath:
                                                              posts[index]
                                                                  .imageUrl,
                                                          postBloc: postbloc,
                                                          postid: posts[index]
                                                              .postid,
                                                          userid: userId,
                                                          name: posts[index].username,
                                                        )))),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 50,
                                    child: Text(
                                      posts[index].title,
                                      style: MyFonts.iconTextStyle,
                                    ),
                                  ),
                                  Positioned(
                                    top: 3,
                                    right: 0,
                                    child: BlocBuilder<PostBloc, PostState>(
                                      builder: (context, state) {
                                        if (state is Postdeletesuccessstate) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                      'Deleted Successfully')));
                                        }
                                        return PopupMenuButton(
                                          iconColor: Colors.white,
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: const Text('Save '),
                                              onTap: () => saveBloc.add(
                                                  SavePostEvent(
                                                      postid:
                                                          posts[index].postid,
                                                      userid: userId)),
                                            ),
                                            const PopupMenuItem(
                                              child: Text('Share'),
                                            ),
                                            if (posts[index].userid == userId)
                                              PopupMenuItem(
                                                child: const Text('Edit'),
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PostScreen(
                                                                edit: posts[
                                                                    index],
                                                                postid:
                                                                    posts[index]
                                                                        .postid,
                                                              )));
                                                },
                                              ),
                                            if (posts[index].userid == userId)
                                              PopupMenuItem(
                                                child: const Text('Delete'),
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return ConfirmationDialog(
                                                            message:
                                                                'Are You sure you want to delete this ?',
                                                            onYesPressed: () {
                                                              postbloc.add(PostdeleteEvent(
                                                                  postid: posts[
                                                                          index]
                                                                      .postid));
                                                            });
                                                      });
                                                },
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 30,
                                    right: 4,
                                    child: Text(
                                      '₹${posts[index].softprice}',
                                      style: MyFonts.iconTextStyle,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 85,         
                                    right: 4,
                                    child: LikeButtonWidget(userId: userId, postId:posts[index].postid, bloc: postbloc)
                                  ),
                                  Positioned(
                                      bottom: 40,
                                      right: 3,
                                      child: commentFunction(
                                          context,
                                          posts[index].postid,
                                          postbloc,
                                          height,
                                          userId)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height * 0.03,
                                  width: height * 0.03,
                                  child: ClipOval(
                                    child: posts[index]
                                            .profileImageUrl
                                            .isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                posts[index].profileImageUrl,
                                            fit: BoxFit.cover,
                                          )
                                        : const Placeholder(),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Text(
                                  posts[index].username,
                                  style: MyFonts.bodyTextStyle,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'No data available',
                        style: MyFonts.boldTextStyle,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
