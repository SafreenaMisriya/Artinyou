import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/label.dart';
import 'package:flutter/material.dart';

class FullimageScreen extends StatelessWidget {
  final String imagePath;
   const FullimageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
     double height = Responsive.screenHeight(context);
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
                  const Text('Photography',style: MyFonts.boldTextStyle,),
                  IconButton(onPressed: (){}, icon:const Icon(Icons.menu) )
                ],
              ),
             Padding(
               padding: const EdgeInsets.all(40.0),
               child: Stack(
                 children:[
                // const Positioned(
                //         bottom: 30,
                //         right: 20,
                //         child: Text(
                //           '₹199',
                //           style: MyFonts.iconTextStyle,
                //         )),
                  ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Center(child: Image.asset(imagePath))),
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
              const Text('Creative Photography',style: MyFonts.boldTextStyle,),
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