import 'package:art_inyou/core/presentation/bloc/softcopy/softcopy_bloc.dart';
import 'package:art_inyou/core/presentation/utils/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay razorpay;
  final BuildContext context;

  PaymentService(this. context) {
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
      'external': {
        'wallets': ['paytm']
      },
    };

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    showfluttertoast('Payment Successful: ${response.paymentId}');
     context.read<SoftcopyBloc>().add(PaymentSuccessEvent());
  }

  void handlePaymentError(PaymentFailureResponse response) {
    showErrorfluttertoast('Payment Failed: ${response.message}');
     context.read<SoftcopyBloc>().add(PaymentFailureEvent());
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    showfluttertoast('External Wallet Selected: ${response.walletName}');
  }
}

