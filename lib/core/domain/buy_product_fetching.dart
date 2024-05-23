import 'package:art_inyou/core/data/model/paymentmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<PaymentModel>> getbuyproducts(String userid) async {
  List<PaymentModel> posts = [];
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users_collection')
        .doc(userid)
        .collection('buy_products')
        .get();
    for (var doc in querySnapshot.docs) {
      PaymentModel p = PaymentModel.fromJson(doc.data(), id: doc.id);
      posts.add(p);
    }
  } catch (e) {
    throw Exception('Failed to fetch posts: $e');
  }
  return posts;
}

Future<List<PaymentModel>> getSellProduct(String userid) async {
  List<PaymentModel> posts = [];
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users_collection')
        .doc(userid)
        .collection('buy_products')
        .where('userid', isEqualTo: userid)
        .where('status', isNotEqualTo: 'Cancelled') 
        .get();
  for (var doc in querySnapshot.docs) {
      var paymentmodel = PaymentModel.fromJson(doc.data(), id: doc.id);
      posts.add(paymentmodel);
    }
  } catch (e) {
    throw Exception('Failed to fetch posts: $e');
  }
  return posts;
}
