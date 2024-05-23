import 'package:art_inyou/core/data/model/paymentmodel.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SellProductScreen extends StatelessWidget {
   final Future<List<PaymentModel>> postsFuture;
   final String userid;
  const SellProductScreen({super.key,required this.postsFuture,required this.userid});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
        future: postsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PaymentModel> buyprduct = snapshot.data!;
             double totalAmount = buyprduct.fold(0.0, (sum, item) => sum + item.amountAsDouble);
            return Column(
              children: [
                SizedBox(height: height*0.04,),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return  Padding(
                        padding: const EdgeInsets.only(left: 12,right: 12),
                        child: Divider(color: greycolor,),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: buyprduct.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                       leading:  CachedNetworkImage(
                                imageUrl: buyprduct[index].imageurl),
                          title: Text(buyprduct[index].title,style: MyFonts.boldTextStyle,),
                          trailing: Text('₹${buyprduct[index].amount}',style: MyFonts.boldTextStyle,),
                      );
                    },
                  ),
                ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(children: [
                   Divider(color: greycolor,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount :',style: MyFonts.headingTextStyle,),
                       Text("₹${totalAmount.toString()}",style: MyFonts.headingTextStyle,)  
                    ],
                  ),
                  Divider(color: greycolor,)
                 ],),
               )
              ],
            );
          } else {
            return Center(
                child: Shimmer.fromColors(
                    baseColor: Colors.blue,
                    highlightColor: Colors.white,
                    child: const Text(
                      'No Data Available',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    )));
          }
        },
      )),
    );
  }
}
