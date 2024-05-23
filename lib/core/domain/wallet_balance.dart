import 'package:cloud_firestore/cloud_firestore.dart';

Future<double> getWalletBalance(String userId) async {
  try {
    DocumentReference walletRef = FirebaseFirestore.instance
        .collection('users_collection')
        .doc(userId)
        .collection('wallet')
        .doc('wallet_balance');

    DocumentSnapshot walletSnapshot = await walletRef.get();

    if (walletSnapshot.exists) {
      Map<String, dynamic>? walletData = walletSnapshot.data() as Map<String, dynamic>?;
      if (walletData != null && walletData.containsKey('balance')) {
        if (walletData['balance'] is String) {
          return double.parse(walletData['balance']);
        } else if (walletData['balance'] is double) {
          return walletData['balance'];
        } else {
          throw Exception('Wallet balance is not in a valid format');
        }
      } else {
        return 0.0;
      }
    } else {
      return 0.0;
    }
  } catch (e) {
    throw Exception('Failed to fetch wallet balance: $e');
  }
}
