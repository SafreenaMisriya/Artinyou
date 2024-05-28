import 'package:art_inyou/models/model/postmodel.dart';
import 'package:art_inyou/repositories/post/post_repository.dart';
import 'package:art_inyou/blocs/bloc/post/bloc/post_bloc.dart';
import 'package:art_inyou/blocs/bloc/save/bloc/save_bloc.dart';
import 'package:art_inyou/screens/post/post_screen.dart';
import 'package:art_inyou/screens/home/showimage_screen.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/utils/snakbar/snakbar.dart';
import 'package:art_inyou/widgets/alertdialog/alertdialog.dart';
import 'package:art_inyou/widgets/image_handling/carosel.dart';
import 'package:art_inyou/widgets/comment/comment_post.dart';
import 'package:art_inyou/widgets/like/like_buttonscreen.dart';
import 'package:art_inyou/utils/loading_view/loadining.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

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
          } else if (snapshot.data!.isEmpty) {
            return Center(
                child: Shimmer.fromColors(
                    baseColor: Colors.blue,
                    highlightColor: Colors.white,
                    child: const Text(
                      'No Data Available',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    )));
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
                                    posts[index].softprice,
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
                                                  title: posts[index].title,
                                                  about: posts[index].about,
                                                  softprice:
                                                      posts[index].softprice,
                                                  hardprice:
                                                      posts[index].hardprice,
                                                  singleImagePath:
                                                      posts[index].imageUrl,
                                                  postBloc: postbloc,
                                                  postid: posts[index].postid,
                                                  userid: widget.userId,
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
                                  snakbarDeleteMessage(
                                      context, 'Post Deleted Successfully');
                                }
                                return PopupMenuButton(
                                  iconColor: Colors.white,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                        child: const Text('Save '),
                                        onTap: () {
                                          saveBloc.add(SavePostEvent(
                                              postid: posts[index].postid,
                                              userid: widget.userId));
                                          snakbarSuccessMessage(context,
                                              'Post Saved Successfully');
                                        }),
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
                            bottom: 70,
                            right: 4,
                            child: LikeButtonWidget(
                              bloc: postbloc,
                              postId: posts[index].postid,
                              userId:  widget.userId,
                                ),
                          ),
                          Positioned(
                              bottom: 20,
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
                     Padding(
                       padding: const EdgeInsets.only(left: 8,right: 8,bottom: 25),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                            ),
                            
                            Row(
                              children: [
                                Shimmer.fromColors(
                                    baseColor: redcolor,
                                    highlightColor: Colors.white,
                                    child: Text(
                                      '₹${posts[index].softprice}',
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.w300),
                                    )),
                              ],
                            ),
                          ],
                        ),
                     ),
                    
                    
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
    String about, String softprice, String hardprice) {
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
                    softprice: softprice,
                    hardprice: hardprice,
                  )));
    },
    child: CaroselScreen(
      screenHeight: 260,
      itemCount: imageUrlList.length,
      imageUrlList: imageUrlList,
    ),
  );
}
