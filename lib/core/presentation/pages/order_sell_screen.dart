import 'package:art_inyou/core/domain/buy_product_fetching.dart';
import 'package:art_inyou/core/presentation/pages/payment/listview.dart';
import 'package:art_inyou/core/presentation/pages/payment/sell_products.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
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
        body: Column(
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                const Padding(
                  padding: EdgeInsets.only(right: 130),
                  child: Text('MY COLLECTIONS',style: MyFonts.headingTextStyle,),
                )
                  
                ],
              ),
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
                         OrdersScreen(postsFuture: getbuyproducts(userId), userid: userId),
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