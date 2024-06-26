import 'package:art_inyou/blocs/hardcopy/hardcopy_bloc.dart';
import 'package:art_inyou/models/model/paymentmodel.dart';
import 'package:art_inyou/repositories/payment/payment_repository.dart';
import 'package:art_inyou/blocs/softcopy/softcopy_bloc.dart';
import 'package:art_inyou/utils/date_and_time/date_time.dart';
import 'package:art_inyou/utils/snakbar/snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
PaymentRepo repo= PaymentRepo();
class PaymentService {
  late Razorpay razorpay;
  final BuildContext context;
  final dynamic price;
  final String postid;
  final String userid;
  final  String hardcopy;

  PaymentService(this. context , {required this.price,required this.postid,required this.userid,required this.hardcopy}) {
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  void dispose() {
    razorpay.clear();
  }

  void openCheckout(int amount,String name,String product) {
    var options = {
      'key': 'rzp_test_yJFAeBzCqlRAoY',
      'amount': amount * 100, 
      'name': name,
      'description': product,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response,) {
    showfluttertoast('Payment Successful: ${response.paymentId},');
      User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';
    PaymentModel model= PaymentModel(amount: price, time: dateAndtime(),postid: postid,userid: userId,hardcopy: hardcopy);
    repo.broughtproduct(model, userId,postid);
     context.read<SoftcopyBloc>().add(PaymentSuccessEvent());
     context.read<HardcopyBloc>().add(PaymentcompletedEvent());
     
  }

  void handlePaymentError(PaymentFailureResponse response) {
    showErrorfluttertoast('Payment Failed: ${response.message}');
     context.read<SoftcopyBloc>().add(PaymentFailureEvent());
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    showfluttertoast('External Wallet Selected: ${response.walletName}');
  }
}

