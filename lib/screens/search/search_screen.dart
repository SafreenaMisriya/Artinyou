// ignore_for_file: must_be_immutable
import 'package:art_inyou/blocs/post/bloc/post_bloc.dart';
import 'package:art_inyou/screens/search/price_select_dropdown.dart';
import 'package:art_inyou/screens/home/showimage_screen.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/widgets/image_handling/carosel.dart';
import 'package:art_inyou/widgets/comment/comment_post.dart';
import 'package:art_inyou/widgets/dropdown/dropdown_select_screen.dart';
import 'package:art_inyou/widgets/like/like_buttonscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatelessWidget {
  final String userid;
  SearchScreen({super.key, required this.userid});
  TextEditingController searchcontroller = TextEditingController();
  late PostBloc postbloc;
  @override
  Widget build(BuildContext context) {
    postbloc = BlocProvider.of<PostBloc>(context);
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Column(
            children: [
               SizedBox(height: height*0.02,),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: searchcontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    focusColor: color,
                    fillColor: color,
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintText: 'Search Here..',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    postbloc.add(PostSearchEvent(value: value));
                  },
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: width * 0.05,
                  ),
                  const DropDownSelect(),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  const PriceRangeDropdown()
                ],
              ),
              SizedBox(height: height*0.04,),
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if(state is SearchLoaded){
                    
                  return Expanded(
                    child: state.post.isNotEmpty
                    ?MasonryGridView.builder(
                      
                      itemCount: state .post.length,
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
                                  child:state. post[index].imageUrl.contains(',')
                                      ? buildCarousel(
                                         state. post[index].imageUrl,
                                          context,
                                         state .post[index].title,
                                         state .post[index].about,
                                         state .post[index].softprice,
                                         state.post[index].hardprice,
                                         state.post[index].username)
                                      : GestureDetector(
                                          child: SizedBox(
                                            height: height * 0.3,
                                            child: Placeholder(
                                              child: Image.network(
                                              state.  post[index].imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => 
                                                      FullimageScreen(
                                                        title:state. post[index].title,
                                                        about:state .post[index].about,
                                                        softprice: state.post[index].softprice,
                                                        hardprice: state.post[index].hardprice,
                                                        singleImagePath:
                                                            state.post[index].imageUrl,
                                                        postBloc: postbloc,
                                                        postid:state .post[index].postid,
                                                        userid: userid,
                                                      )))),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 50,
                                  child: Text(
                                   state. post[index].title,
                                    style: MyFonts.iconTextStyle,
                                  ),
                                ),
                                Positioned(
                                  bottom: 30,
                                  right: 4,
                                  child: Text(
                                    '₹${state.post[index].softprice}',
                                    style: MyFonts.iconTextStyle,
                                  ),
                                ),
                                Positioned(
                                  bottom: 85,
                                  right: 4,
                                  child: LikeButtonWidget(userId: userid, postId:  state.post[index].postid, bloc:postbloc)
                                ),
                                Positioned(
                                    bottom: 40,
                                    right: 3,
                                    child: commentFunction(
                                        context,
                                       state .post[index].postid,
                                        postbloc,
                                        height,
                                        userid)),
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
                                  child: state.post[index].profileImageUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: state.post[index].profileImageUrl,
                                          fit: BoxFit.cover,
                                        )
                                      : const Placeholder(),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(
                                state.post[index].username,
                                style: MyFonts.bodyTextStyle,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                    : Center(child: Shimmer.fromColors(baseColor: Colors.blue,highlightColor: Colors.white,child: const Text('No Data Found',style:TextStyle(fontSize: 18,fontWeight: FontWeight.w300) ,)))
                  );
                  
                  }else{
                    return const Center(child: Text(''),);
                  }
                }
              )
             
            ],
          ),
        ),
      ),
    );
  }


}
