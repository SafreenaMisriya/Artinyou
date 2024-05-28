import 'package:art_inyou/utils/fonts/font.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

customAppbar(double height,double width,BuildContext context,String imageurl,String username,String activetime){
return AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            flexibleSpace: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
                SizedBox(
                  height: height * 0.05,
                  width: height * 0.05,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:  imageurl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: MyFonts.boldTextStyle,
                    ),
                     Text(
                      activetime,
                      style:const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          );
}