import 'package:art_inyou/core/data/model/postmodel.dart';
import 'package:art_inyou/core/data/repository/post_repository.dart';
import 'package:art_inyou/core/presentation/bloc/post/bloc/post_bloc.dart';
import 'package:art_inyou/core/presentation/bloc/save/bloc/save_bloc.dart';
import 'package:art_inyou/core/presentation/pages/post_screen.dart';
import 'package:art_inyou/core/presentation/pages/showimage_screen.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/alertdialog.dart';
import 'package:art_inyou/core/presentation/widgets/carosel.dart';
import 'package:art_inyou/core/presentation/widgets/comment_post.dart';
import 'package:art_inyou/core/presentation/widgets/like_buttonscreen.dart';
import 'package:art_inyou/core/presentation/utils/loadining.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

FirestoreService service = FirestoreService();

class GridViewScreen extends StatefulWidget {
  final Future<List<PostModel>> postsFuture;
  final String userId;

  const GridViewScreen({
    super.key,
    required this.postsFuture,
    required this.userId,
  });

  @override
  State<GridViewScreen> createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  late PostBloc postbloc;
  late SaveBloc saveBloc;
  TextEditingController commentcontroller = TextEditingController();
  @override
  void initState() {
    postbloc = BlocProvider.of<PostBloc>(context);
    saveBloc = BlocProvider.of<SaveBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return Scaffold(
      body: FutureBuilder(
        future: widget.postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildShimmerGridView(height, width);
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<PostModel>? posts = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: MasonryGridView.builder(
                itemCount: posts!.length,
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
                            child: posts[index].imageUrl.contains(',')
                                ? _buildCarousel(
                                    posts[index].imageUrl,
                                    context,
                                    posts[index].title,
                                    posts[index].about,
                                    posts[index].price)
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
                                                  title: posts[index].title,
                                                  about: posts[index].about,
                                                  price: posts[index].price,
                                                  singleImagePath:
                                                      posts[index].imageUrl,
                                                  postBloc: postbloc,
                                                  postid: posts[index].postid,
                                                  userid: widget.userId,
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.red,
                                          content:
                                              Text('Deleted Successfully')));
                                }
                                return PopupMenuButton(
                                  iconColor: Colors.white,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: const Text('Save '),
                                      onTap: () => saveBloc.add(SavePostEvent(
                                          postid: posts[index].postid,
                                          userid: widget.userId)),
                                    ),
                                    const PopupMenuItem(
                                      child: Text('Share'),
                                    ),
                                    if (posts[index].userid == widget.userId)
                                      PopupMenuItem(
                                        child: const Text('Edit'),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostScreen(
                                                        edit: posts[index],
                                                        postid:
                                                            posts[index].postid,
                                                      )));
                                        },
                                      ),
                                    if (posts[index].userid == widget.userId)
                                      PopupMenuItem(
                                        child: const Text('Delete'),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ConfirmationDialog(
                                                    message:
                                                        'Are You sure you want to delete this ?',
                                                    onYesPressed: () {
                                                      postbloc.add(
                                                          PostdeleteEvent(
                                                              postid:
                                                                  posts[index]
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
                              '₹${posts[index].price}',
                              style: MyFonts.iconTextStyle,
                            ),
                          ),
                          Positioned(
                            bottom: 85,
                            right: 4,
                            child: likeFunction(
                                widget.userId, posts[index].postid, postbloc),
                          ),
                          Positioned(
                              bottom: 40,
                              right: 3,
                              child: commentFunction(
                                  context,
                                  posts[index].postid,
                                  postbloc,
                                  height,
                                  widget.userId)),
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
                            child: posts[index].profileImageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: posts[index].profileImageUrl,
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
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}

Widget _buildCarousel(String imageUrl, BuildContext context, String title,
    String about, String price) {
  List<String> imageUrlList = imageUrl.split(',');
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FullimageScreen(
                    imagePathList: imageUrlList,
                    title: title,
                    about: about,
                    price: price,
                  )));
    },
    child: CaroselScreen(
      screenHeight: 260,
      itemCount: imageUrlList.length,
      imageUrlList: imageUrlList,
    ),
  );
}
