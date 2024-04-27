import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/label.dart';
import 'package:flutter/material.dart';

class FullimageScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final String about ;
  final String? price;
   const FullimageScreen({super.key, required this.imagePath,required this.title,required this.about, this.price});

  @override
  Widget build(BuildContext context) {
     double height = Responsive.screenHeight(context);
     double width = Responsive.screenWidth(context);
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
                 SizedBox(
                height: height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                   Text(title,style: MyFonts.boldTextStyle,),
                  IconButton(onPressed: (){}, icon:const Icon(Icons.menu) )
                ],
              ),
             Padding(
               padding: const EdgeInsets.all( 20),
               child: Stack(
                 children:[
                  ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    height: height*0.4,
                    child: Image.network(imagePath))),
            ]),
             ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_sharp,color: redcolor,),
                    const Text('2k likes',style: MyFonts.normalTextStyle,),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.comment_outlined,),
                    Text('2 ',style: MyFonts.normalTextStyle,),
                  ],
                )
              ],
             ),
             SizedBox(
                height: height * 0.02,
              ),
               Text(about,style: MyFonts.boldTextStyle,),
              SizedBox(
                height: height * 0.03,
              ),
          labelwidget(labelText: 'Download', onTap: (){})
            ],
          ),
        ),
      ) ,
    );
  }
}