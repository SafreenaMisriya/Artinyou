import 'package:art_inyou/blocs/hardcopy/hardcopy_bloc.dart';
import 'package:art_inyou/models/model/paymentmodel.dart';
import 'package:art_inyou/repositories/payment/payment_repository.dart';
import 'package:art_inyou/repositories/wallet/wallet_balance.dart';
import 'package:art_inyou/screens/payment/payment_screen.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/date_and_time/date_time.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/snakbar/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

PaymentRepo repo = PaymentRepo();

void handlePayment(
  BuildContext context,
  String price,
  String postid,
  String name,
  String product,
  PaymentService pay,
  String currentuserId,
) {
  showModalBottomSheet(
    backgroundColor: color,
    context: context,
    builder: (context) {
      return FutureBuilder(
        future: getWalletBalance(currentuserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            double walletBalance = snapshot.data ?? 0.0;
            return Column(
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
                    if (walletBalance >= totalAmount) {
                      context.read<HardcopyBloc>().add(PaymentcompletedEvent());
                      PaymentModel paymentModel = PaymentModel(
                        hardcopy: 'yes',
                        amount: price,
                        time: dateAndtime(),
                        postid: postid,
                      );
                      repo.payUsingWallet(currentuserId, paymentModel);
                      snakbarSuccessMessage(
                          context, 'Payment Completed Successfully');
                      Navigator.pop(context);
                    } else {
                      snakbarDeleteMessage(
                          context, 'Insufficient wallet balance');
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
          } else {
            return snakbarDeleteMessage(context, 'Insufficient wallet balance');
          }
        },
      );
    },
  );
}
