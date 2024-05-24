import 'package:art_inyou/core/data/model/paymentmodel.dart';
import 'package:art_inyou/core/data/repository/payment_repository.dart';
import 'package:art_inyou/core/domain/wallet_balance.dart';
import 'package:art_inyou/core/presentation/pages/payment/payment_screen.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/date_time.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/snakbar.dart';
import 'package:flutter/material.dart';

PaymentRepo repo = PaymentRepo();

void handlePayment(BuildContext context, String price, String postid, String name, String product, PaymentService pay, String currentuserId) {
  showModalBottomSheet(
    backgroundColor: color,
    context: context,
    builder: (context) {
      return FutureBuilder<double>(
        future: getWalletBalance(currentuserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
              double walletBalance = snapshot.data ?? 0.0;
            return  Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Wallet'),
                       Text(
                    ' Balance: ₹$walletBalance',
                    style: MyFonts.bodyTextStyle,
                  ),
                    ],
                  ),
                  onTap: () {
                    double totalAmount = double.parse(price);
                    if(walletBalance >= totalAmount){
                      PaymentModel paymentModel = PaymentModel(
                        hardcopy: 'yes',
                      amount: price,
                      time: dateAndtime(),
                      postid: postid,
                    );
                    repo.payUsingWallet(currentuserId, paymentModel);
                    snakbarSuccessMessage(context, 'Payment Completed Successfully');
                    Navigator.pop(context); 
                    }else{
                      snakbarDeleteMessage(context, 'Insufficient wallet balance');
                    }
                   
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.currency_rupee_rounded),
                  title: const Text('Net Banking'),
                  onTap: () {
                    int amount = int.parse(price);
                    pay.openCheckout(amount, name, product);
                    Navigator.pop(context); 
                  },
                ),
              ],
            );
          }else{
            return snakbarDeleteMessage(context, 'Insufficient wallet balance');
          }
        },
      );
    },
  );
}

