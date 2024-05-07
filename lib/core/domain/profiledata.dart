import 'dart:async';

import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Stream<List<ProfileModel>> getAllProfile() {
  User? currentUser = FirebaseAuth.instance.currentUser;
  String userId = currentUser?.uid ?? '';
  try {
    return FirebaseFirestore.instance.collection('profile').where('userId',isNotEqualTo:userId).snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((doc) => ProfileModel.fromJson(doc.data(), id: doc.id)).toList());
  } catch (e) {
    throw Exception('Failed to fetch profiles: $e');
  }
}

