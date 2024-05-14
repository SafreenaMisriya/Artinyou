 import 'package:art_inyou/core/data/model/chatlist.dart';
import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/data/repository/profile_repository.dart';

Future<List<ChatItem>> fetchChatItems(List<String> userIds) async {
  Profilestorage storage=Profilestorage();
    List<ChatItem> chatItems = [];

    for (String userId in userIds) {
      ProfileModel? profile = await storage.getProfile(userId);
      if (profile != null) {
        chatItems.add(ChatItem(
          userid: userId,
          imageurl: profile.imageurl ?? '',
          username: profile.username,
        ));
      }
    }

    return chatItems;
  }