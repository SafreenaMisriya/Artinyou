// ignore_for_file: avoid_unnecessary_containers, must_be_immutable


import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CaroselScreen extends StatefulWidget {
  final List<String> imageUrlList;
  final int itemCount;
  final double? screenHeight;
  final bool? isautoPlay;

  const   CaroselScreen({super.key,required  this.itemCount,required this.imageUrlList,this.screenHeight,this.isautoPlay});

  @override
  State<CaroselScreen> createState() => _CaroselScreenState();
}

class _CaroselScreenState extends State<CaroselScreen> {
    int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
   double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context); 
     return Container(
      child: Column(
        children: [
             CarouselSlider.builder(
              itemCount: widget.itemCount,
              itemBuilder: (context, index, realIndex) {
                final imageUrl =
                   widget.imageUrlList[index];
                return SizedBox(
                  height: height *0.6,
                  width: width *0.5,
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Placeholder(child: Image.network(imageUrl, fit: BoxFit.cover)),
                    )), 
                );
              },
              options: CarouselOptions(
                  autoPlay: true ,
                height:widget.screenHeight ?? height*0.3 ,
                 onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              },
                
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
        count: widget.itemCount,
      );
}
