import 'package:art_inyou/repositories/buyandsell/buy_product_fetching.dart';
import 'package:art_inyou/screens/buyandsell.dart/listview.dart';
import 'package:art_inyou/screens/buyandsell.dart/sell_products.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/widgets/appbar/customappbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabBarOrderandSell extends StatelessWidget {
  const TabBarOrderandSell({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';

    return SafeArea(
      child: Scaffold(
        appBar: customAppbartop(context,'MY COLLECTIONS'),
        body: 
        Column(
          children: [
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                     const TabBar(
                      indicatorColor: Colors.red,
              
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                      tabs: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Tab(
                            child: Text('Buy Products',style: MyFonts.boldTextStyle,),
                          ),
                        ),
                       
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Tab(
                            child: Text('Sell Products',style: MyFonts.boldTextStyle,),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                         OrdersScreen(userid: userId),
                          SellProductScreen(postsFuture: getSellProduct(userId), userid: userId),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}