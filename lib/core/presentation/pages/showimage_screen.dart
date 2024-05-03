import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/carosel.dart';
import 'package:art_inyou/core/presentation/widgets/label.dart';
import 'package:flutter/material.dart';

class FullimageScreen extends StatelessWidget {
  final List<String>? imagePathList;
  final String? singleImagePath;
  final String? title;
  final String? about;
  final String? price;
  const FullimageScreen(
      {super.key,
      this.singleImagePath,
      this.imagePathList,
      this.title,
      this.about,
      this.price});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
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
                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    if (imagePathList != null)
                      CaroselScreen(
                        screenHeight: height * 0.4,
                        itemCount: imagePathList!.length,
                        imageUrlList: imagePathList!,
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          height: height * 0.4,
                          child:  Image.network(singleImagePath!)
                        ),
                      ),
                    if (price != null)
                      Positioned(
                        bottom: 40,
                        right: 10,
                        child: Text(
                          '₹$price',
                          style: MyFonts.iconTextStyle,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_sharp,
                        color: redcolor,
                      ),
                      const Text(
                        '2k likes',
                        style: MyFonts.normalTextStyle,
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.comment_outlined,
                      ),
                      Text(
                        '2 ',
                        style: MyFonts.normalTextStyle,
                      ),
                    ],
                  )
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
              labelwidget(labelText: 'Download', onTap: () {})
            ],
          ),
        ),
      ),
    );
  }
}
