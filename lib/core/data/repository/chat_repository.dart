import 'dart:async';
import 'package:art_inyou/core/data/model/messagemodel.dart';
import 'package:art_inyou/core/data/repository/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRepository {
  Profilestorage profile = Profilestorage();
  User? user = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // generating id
  String generateChatId({required String username1, required String username2}) {
    return username1.compareTo(username2) < 0
        ? '$username1-$username2'
        : '$username2-$username1';
  }

  // Check chat existence function
  Future<bool> checkChatExistsOrNot({
    required String username1,
    required String username2,
  }) async {
    String chatId = generateChatId(username1: username1, username2: username2);
    DocumentSnapshot doc = await firestore.collection('chats').doc(chatId).get();
    return doc.exists;
  }

  // Get chats for a user
Stream<List<String>> getChats(String userId) {
    return firestore
        .collection('chats')
        .where('members', arrayContains: userId)
        .orderBy('lastActive', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            List<String> members = List<String>.from(doc.data()['members']);
            members.remove(userId);
            return members.first;
          }).toList();
        });
  }

  // Get chat between two users
  Stream<List<MessageModel>> getChat(
    String userId,
     String myId,) {
    String chatId = generateChatId(username1: userId, username2: myId);
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return MessageModel.fromJson(doc.data(), id: doc.id);
          }).toList();
        });
  }

  // Send message function
  Future<void> sendMessage(
    String to,
     String from,
   MessageModel message,
  ) async {
    bool existsOrNot = await checkChatExistsOrNot(username1: to, username2: from);
    FirebaseFirestore tempDb = FirebaseFirestore.instance;
    String chatId = generateChatId(username1: from, username2: to);
    Timestamp now = Timestamp.now();

    if (!existsOrNot) {
      List<String> members = [to, from];
      var messageRef = tempDb.collection('chats').doc(chatId).collection('messages').doc();
      message = message.copyWith(messageid: messageRef.id);
      await messageRef.set(message.toJson());

      await tempDb.collection('chats').doc(chatId).set({
        'lastActive': now,
        'members': members,
      });
    } else {
      var messageRef = tempDb.collection('chats').doc(chatId).collection('messages').doc();
      message = message.copyWith(messageid: messageRef.id);
      await messageRef.set(message.toJson());

      await tempDb.collection('chats').doc(chatId).update({'lastActive': now});
    }
  }
  

}

