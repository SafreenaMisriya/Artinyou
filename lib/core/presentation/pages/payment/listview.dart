import 'package:art_inyou/core/data/model/paymentmodel.dart';
import 'package:art_inyou/core/data/repository/payment_repository.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
PaymentRepo repo =PaymentRepo();
class OrdersScreen extends StatelessWidget {
   final Future<List<PaymentModel>> postsFuture;
   final String userid;
  const OrdersScreen({super.key,required this.postsFuture,required this.userid});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
        future: postsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PaymentModel> buyprduct = snapshot.data!;
            return Column(
              children: [
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          SizedBox(
                            height: height * 0.15,
                            width: width * 0.2,
                            child: CachedNetworkImage(
                                imageUrl: buyprduct[index].imageurl),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  buyprduct[index].title,
                                  style: MyFonts.boldTextStyle,
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Text('Purchased.On:${buyprduct[index].time}',style: TextStyle(color: greycolor),),
                                Align(alignment: Alignment.bottomRight,child: TextButton(onPressed: () => repo.cancelOrder(userid, buyprduct[index].id), child: const Text('Cancel the order')),)
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                          Text(
                            '₹${buyprduct[index].amount}',
                            style: MyFonts.headingTextStyle,
                          ),
                          
                        ]),
                      );
                    },
                  ),
                ),
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
