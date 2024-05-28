import 'package:art_inyou/models/model/paymentmodel.dart';
import 'package:art_inyou/repositories/payment/payment_repository.dart';
import 'package:art_inyou/blocs/orders/orders_cubit.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/utils/snakbar/snakbar.dart';
import 'package:art_inyou/widgets/alertdialog/alertdialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
PaymentRepo repo = PaymentRepo();
class OrdersScreen extends StatelessWidget {
  final String userid;
  const OrdersScreen({super.key, required this.userid});
  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);

    return SafeArea(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => OrdersCubit()..loadOrders(userid),
          child: BlocBuilder<OrdersCubit, OrdersState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OrderLoaded) {
                List<PaymentModel> buyProducts = state.orders;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12),
                            child: Divider(color: greycolor),
                          );
                        },
                        shrinkWrap: true,
                        itemCount: buyProducts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                              SizedBox(
                                height: height * 0.15,
                                width: width * 0.2,
                                child: CachedNetworkImage(
                                    imageUrl: buyProducts[index].imageurl),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      buyProducts[index].title,
                                      style: MyFonts.boldTextStyle,
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Text(
                                      'P.On:${buyProducts[index].time}',
                                      style: TextStyle(color: greycolor),
                                    ),
                                    buyProducts[index].hardcopy.isEmpty
                                        ? Container()
                                        : Align(
                                            alignment: Alignment.bottomRight,
                                            child: TextButton(
                                              onPressed: () => showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ConfirmationDialog(
                                                    message:
                                                        'Are you sure you want to cancel this order?',
                                                    onYesPressed: () {
                                                      BlocProvider.of<OrdersCubit>(
                                                              context)
                                                          .cancelOrder(
                                                              userid,
                                                              buyProducts[index]
                                                                  .id);
                                                    snakbarDeleteMessage(context, 'Order Cancel Successfully');
                                                    },
                                                    
                                                  );
                                                },
                                              ),
                                              child: Text(
                                                'Cancel the order',
                                                style: TextStyle(
                                                    color: redcolor,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              Text(
                                '₹${buyProducts[index].amount}',
                                style: MyFonts.headingTextStyle,
                              ),
                            ]),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is OrderError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('No Data Available'));
              }
            },
          ),
        ),
      ),
    );
  }
}
