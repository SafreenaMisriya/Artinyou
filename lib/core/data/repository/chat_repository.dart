import 'dart:async';
import 'package:art_inyou/core/data/model/chatlist.dart';
import 'package:art_inyou/core/data/model/messagemodel.dart';
import 'package:art_inyou/core/data/repository/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Profilestorage profile = Profilestorage();

class ChatRepository {
  User? user = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addMessages(
    MessageModel message,
  ) async {
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
            .add(message.toJson())
            .then(
          //after the write succes saving the id inside another collection
          (value) async {
            updateUserChatList(userId, chatroomsid, message.toId);
          },
        );
      }
    } catch (e) {
      throw Exception('Failed to send messages: $e');
    }
  }
  Future<void> updateUserChatList(String userId, String chatroomId, String otherUserId) async {
  final dataDoc = await firestore.collection("chatList").doc(userId).get();
  final Map<String, dynamic>? data = dataDoc.data();

  if (data == null) {
    await firestore.collection("chatList").doc(userId).set({
      chatroomId: otherUserId,
    });
  } else if (!data.containsKey(chatroomId)) {
    await firestore.collection("chatList").doc(userId).update({
      chatroomId: otherUserId,
    });
  }

  // Update the other user's chat list
  final otherDataDoc = await firestore.collection("chatList").doc(otherUserId).get();
  final otherData = otherDataDoc.data();

  if (otherData == null ||!otherData.containsKey(chatroomId)) {
    await firestore.collection("chatList").doc(otherUserId).set({
      chatroomId: userId,
    });
  } else {
    await firestore.collection("chatList").doc(otherUserId).update({
      chatroomId: userId,
    });
  }
}

  Stream<List<MessageModel>> getMessages(String toId, String fromid) {
    List<String> ids = [fromid, toId];
    ids.sort();
    String chatroomsid = ids.join("_");
    return firestore
        .collection('conversations')
        .doc(chatroomsid)
        .collection('message')
        .orderBy('time', descending: false)
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
  Stream<List<MessageModel>> getLastMessages(String toId, String fromid) {
    List<String> ids = [fromid, toId];
    ids.sort();
    String chatroomsid = ids.join("_");
    return firestore
        .collection('conversations')
        .doc(chatroomsid)
        .collection('message')
        .orderBy('time', descending: true)
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


Future<void> addConversation(ConversationModel conversation) async {
  try {
    await FirebaseFirestore.instance
        .collection('conversations')
        .add({
      'initiatedAt': conversation.initiatedAt,
      'initiatedBy': conversation.initiatedBy,
      'lastMessage': conversation.lastMessage,
      'lastUpdatedAt': conversation.lastUpdatedAt,
      'participants': conversation.participants,
      'participantIds': conversation.participantIds,
    });
  } catch (e) {
    rethrow; 
  }
}



}
