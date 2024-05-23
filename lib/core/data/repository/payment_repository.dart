import 'package:art_inyou/core/data/model/paymentmodel.dart';
import 'package:art_inyou/core/data/model/postmodel.dart';
import 'package:art_inyou/core/data/repository/post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
FirestoreService service=FirestoreService();
class PaymentRepo{
   final FirebaseFirestore firestore = FirebaseFirestore.instance;
   Future<void>broughtproduct(PaymentModel paymentModel,String userid,String postid)async{
    PostModel? post= await service.getPostDetails(postid);
     try {
      Map<String, dynamic> paymentdata = {
        'amount': paymentModel.amount,
        'payedtime': paymentModel.time,
        // 'paymentid': paymentModel.paymentid,
        'postid':paymentModel.postid,
        "image":post.imageUrl,
        'title':post.title,
        'userid':post.userid,

      };
      await firestore
          .collection('users_collection')
          .doc(userid)
          .collection('buy_products')
          .add(paymentdata);
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
   }
  Future<void> cancelOrder(String userid, String paymentId) async {
  try {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users_collection')
        .doc(userid)
        .collection('buy_products')
        .doc(paymentId);

    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? orderData = docSnapshot.data() as Map<String, dynamic>?;

      if (orderData != null && orderData.containsKey('amount')) {
        // Ensure the amount is parsed as a double
        double amount;
        if (orderData['amount'] is String) {
          amount = double.parse(orderData['amount']);
        } else if (orderData['amount'] is double) {
          amount = orderData['amount'];
        } else {
          throw Exception('Order amount is not in a valid format');
        }

        await docRef.update({'status': 'Cancelled'});

        await refundToWallet(userid, amount);
      } else {
        throw Exception('Order amount not found');
      }
    } else {
      throw Exception('Order not found');
    }
  } catch (e) {
    throw Exception('Failed to cancel order: $e');
  }
}

Future<void> refundToWallet(String userid, double amount) async {
  try {
    DocumentReference walletRef = FirebaseFirestore.instance
        .collection('users_collection')
        .doc(userid)
        .collection('wallet')
        .doc('wallet_balance');

    DocumentSnapshot walletSnapshot = await walletRef.get();

    if (walletSnapshot.exists) {
      Map<String, dynamic>? walletData = walletSnapshot.data() as Map<String, dynamic>?;
      if (walletData != null && walletData.containsKey('balance')) {
        double currentBalance;
        if (walletData['balance'] is String) {
          currentBalance = double.parse(walletData['balance']);
        } else if (walletData['balance'] is double) {
          currentBalance = walletData['balance'];
          print(currentBalance);
        } else {
          throw Exception('Wallet balance is not in a valid format');
        }
        double newBalance = currentBalance + amount;

        await walletRef.update({'balance': newBalance});
      } else {
        await walletRef.set({'balance': amount});
      }
    } else {
      await walletRef.set({'balance': amount});
    }
  } catch (e) {
    throw Exception('Failed to refund to wallet: $e');
  }
}



Future<void> payUsingWallet(String userid, PaymentModel paymentModel) async {
  try {
    DocumentReference walletRef = FirebaseFirestore.instance
        .collection('users_collection')
        .doc(userid)
        .collection('wallet')
        .doc('wallet_balance');

    DocumentSnapshot walletSnapshot = await walletRef.get();

    if (walletSnapshot.exists) {
      // Explicitly cast to Map<String, dynamic>
      Map<String, dynamic> walletData = walletSnapshot.data() as Map<String, dynamic>;
      double walletBalance = walletData['balance'] as double;

      if (walletBalance >= paymentModel.amountAsDouble) {
        // Deduct amount from wallet
        double newBalance = walletBalance - paymentModel.amountAsDouble;
        await walletRef.update({'balance': newBalance});

        // Proceed with the payment using wallet
        await broughtproduct(paymentModel, userid, paymentModel.postid);
      } else {
        throw Exception('Insufficient wallet balance');
      }
    } else {
      throw Exception('Wallet not found');
    }
  } catch (e) {
    throw Exception('Failed to pay using wallet: $e');
  }
}


 
}
