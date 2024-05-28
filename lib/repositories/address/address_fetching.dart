import 'package:art_inyou/models/model/addressmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<AddressModel?> getAddress(String userid) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('users_collection')
            .doc(userid)
            .collection('address')
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data();
      var id= querySnapshot.docs.first.id;
      return AddressModel.fromJson(data,id: id);
    } else {
      return null; 
    }
  } catch (e) {
    throw Exception('Failed to fetch address: $e');
  }
}