import 'package:art_inyou/blocs/post/bloc/post_bloc.dart';
import 'package:art_inyou/blocs/save/bloc/save_bloc.dart';
import 'package:art_inyou/utils/alertdialog/alert_dialogswitch.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/utils/snakbar/snakbar.dart';
import 'package:art_inyou/widgets/image_handling/carosel.dart';
import 'package:art_inyou/widgets/comment/comment_post.dart';
import 'package:art_inyou/widgets/label/label.dart';
import 'package:art_inyou/widgets/like/like_buttonscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class FullimageScreen extends StatelessWidget {
  final List<String>? imagePathList;
  final String? singleImagePath;
  final String? title;
  final String? about;
  final String? softprice;
  final String? hardprice;
  final String? userid;
  final String? postid;
  final String? name;
  final PostBloc? postBloc;
  const FullimageScreen(
      {super.key,
      this.singleImagePath,
      this.imagePathList,
      this.postBloc,
      this.userid,
      this.postid,
      this.title,
      this.about,
      this.softprice,
      this.hardprice,
      this.name});

  @override
  Widget build(BuildContext context) {
    late SaveBloc saveBloc;
    double height = Responsive.screenHeight(context);
    saveBloc = BlocProvider.of<SaveBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                  Text(
                    title ?? '',
                    style: MyFonts.boldTextStyle,
                  ),
                  PopupMenuButton(
                    color: color,
                    icon: const Icon(Icons.menu_rounded,color: Colors.black,),
                      iconColor: Colors.white,
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                child: const Text('Save '),
                                onTap: () {
                                  saveBloc.add(SavePostEvent(
                                      postid: postid!, userid: userid!));
                                  snakbarSuccessMessage(
                                      context, 'Post Saved Successfully');
                                }),
                          ])
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    if (imagePathList != null)
                      CaroselScreen(
                        screenHeight: height * 0.4,
                        itemCount: imagePathList!.length ,
                        imageUrlList: imagePathList!,
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                            height: height * 0.4,
                            child: Image.network(singleImagePath !)),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LikeButtonWidget(
                      userId: userid!, postId: postid !, bloc: postBloc !),
                  commentFunction(context, postid!, postBloc!, height, userid!),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'SoftCopy Price :',
                    style: GoogleFonts.aladin(fontSize: 17),
                  ),
                  Text(
                    '₹${softprice ?? " "}',
                    style: MyFonts.boldTextStyle,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'HardCopy Price :',
                    style: GoogleFonts.aladin(fontSize: 17),
                  ),
                  Text(
                    '₹${hardprice ?? " "}',
                    style: MyFonts.boldTextStyle,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                about ?? '',
                style: MyFonts.boldTextStyle,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              labelwidget(
                  labelText: 'Buy Now',
                  onTap: () {
                    showCustomDialog(context,imagePathList, softprice!, postid!, name!,
                        title!, singleImagePath, hardprice!, userid!, height);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
