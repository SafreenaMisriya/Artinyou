import 'package:art_inyou/core/data/model/addressmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressStorage {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addAddress(AddressModel addressModel, String userid) async {
    try {
      Map<String, dynamic> addressData = {
        'name': addressModel.name,
        'phone': addressModel.phone,
        'house': addressModel.house,
        'state': addressModel.state,
        'city': addressModel.city,
        'pincode': addressModel.pincode,
        'price': addressModel.price,
        'postid': addressModel.postid,
      };
      await firestore
          .collection('users_collection')
          .doc(userid)
          .collection('address')
          .add(addressData);
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

  Future<void> updateaddress(
    String id,
    AddressModel addressModel,
    String userid,
  ) async {
    try {
      Map<String, dynamic> updateData = {
        'name': addressModel.name,
        'phone': addressModel.phone,
        'house': addressModel.house,
        'state': addressModel.state,
        'city': addressModel.city,
        'pincode': addressModel.pincode,
        'price': addressModel.price,
        'postid': addressModel.postid,
      };

      await firestore
          .collection('users_collection')
          .doc(userid)
          .collection('address')
          .doc(id)
          .update(updateData);
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }
}
