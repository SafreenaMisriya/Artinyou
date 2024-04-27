// ignore_for_file: avoid_unnecessary_containers, must_be_immutable


import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CaroselScreen extends StatelessWidget {
  final List<String> imageUrlList;
  final int itemCount;
  final double? screenHeight;

   CaroselScreen({super.key,required  this.itemCount,required this.imageUrlList,this.screenHeight});
    int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
   double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context); 
     return Container(
      child: Column(
        children: [
             CarouselSlider.builder(
              itemCount: itemCount,
              itemBuilder: (context, index, realIndex) {
                final imageUrl =
                   imageUrlList[index];
                return SizedBox(
                  height: height *0.8,
                  width: width *0.8,
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(imageUrl, fit: BoxFit.cover)), 
                );
              },
              options: CarouselOptions(
                // autoPlay: true,
                height:screenHeight ,
                
              ),
            ),
          
           SizedBox(height:height*0.01),
          builderIndicator(),
        ],
      ),
    );
  }
  Widget builderIndicator() => AnimatedSmoothIndicator(
        effect:  SwapEffect(
          activeDotColor: redcolor,
          type: SwapType.yRotation,
          dotWidth: 6,
          dotHeight: 6,
        ),
        activeIndex: activeIndex, 
        count: 3,
      );
}
