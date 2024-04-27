import 'package:art_inyou/core/data/model/postmodel.dart';
import 'package:art_inyou/core/presentation/pages/showimage_screen.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/carosel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GridViewScreen extends StatelessWidget {
    final Future<List<PostModel>> postsFuture;
  const GridViewScreen({
    super.key,
    required this.postsFuture,
  });

  @override
  Widget build(BuildContext context) {
    double height=Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return Scaffold(
      body: FutureBuilder(
        future: postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: posts[index].imageUrl.contains(',')
                                ? _buildCarousel(posts[index].imageUrl)
                                : GestureDetector(
                                    child: SizedBox(
                                      height: height *0.3,
                                      child: Image.network(
                                        posts[index].imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FullimageScreen(
                                              title: posts[index].title,
                                              about: posts[index].about,
                                              price: posts[index].price,
                                                imagePath:
                                                    posts[index].imageUrl)))),
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
                            child: PopupMenuButton(
                              iconColor: Colors.white,
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  child: Text('Save'),
                                ),
                                const PopupMenuItem(
                                  child: Text('Share'),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: Text(
                              '₹${posts[index].price}',
                              style: MyFonts.iconTextStyle,
                            ),
                          ),
                          Positioned(
                            bottom: 55,
                            right: 4,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '2k',
                                  style: TextStyle(color: color),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 25,
                            right: 4,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.comment_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '23',
                                  style: TextStyle(color: color),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: CircleAvatar(
                            child: Image.network(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh7ogUYtR66AVscPGclBkMHRagtzJ9D0w04Q&s'),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        const Text('Angelina'),
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

  Widget _buildCarousel(String imageUrl) {
    List<String> imageUrlList = imageUrl.split(',');
    return GestureDetector(
      // onDoubleTap: () {
      //    Navigator.push(context, MaterialPageRoute(builder: (context)=>FullimageScreen(imagePath:imageUrlList )));
      // },
      child: CaroselScreen(
        screenHeight: 250,
        itemCount: imageUrlList.length,
        imageUrlList: imageUrlList,
      ),
    );
  }


}
