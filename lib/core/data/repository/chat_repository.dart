
import 'package:art_inyou/core/data/model/messagemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRepository {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addMessages(MessageModel message) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        List<String> ids = [userId, message.toId];
        ids.sort();
        String chatroomsid = ids.join("_");
        await firestore
            .collection('conversations')
            .doc(chatroomsid)
            .collection('message')
            .add(message.toJson());
      }
    } catch (e) {
      throw Exception('Failed to send messages: $e');
    }
  }
  Stream<List<MessageModel>> getMessages(String toId,String fromid) {
      List<String> ids = [fromid, toId];
      ids.sort();
      String chatroomsid = ids.join("_");
      return firestore
          .collection('conversations')
          .doc(chatroomsid)
          .collection('message')
          .orderBy('time',descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return MessageModel.fromJson(
            doc.data(),
            id: doc.id,
          );
        }).toList();
      });
    }
  //    Future<void> updateMessageReadStatus(String fromid,String toId, String messageId) async {
  //     List<String> ids = [fromid, toId];
  //     ids.sort();
  //     String chatroomsid = ids.join("_");
  //   try {
  //     await firestore
  //         .collection('conversations')
  //         .doc(chatroomsid)
  //         .collection('message')
  //         .doc(messageId)
  //         .update({'read': 'true'});
  //   } catch (e) {
  //     throw Exception('Failed to update message read status: $e');
  //   }
  // } 
  Stream<List<MessageModel>> getLastMessages(String toId,String fromid) {
      List<String> ids = [fromid, toId];
      ids.sort();
      String chatroomsid = ids.join("_");
      return firestore
          .collection('conversations')
          .doc(chatroomsid)
          .collection('message')
          .orderBy('time',descending: true)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return MessageModel.fromJson(
            doc.data(),
          );
        }).toList();
      });
    }
  }


