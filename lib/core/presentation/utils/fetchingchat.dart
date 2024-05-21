 import 'package:art_inyou/core/data/model/chatlist.dart';
import 'package:art_inyou/core/data/model/chatlistinfo.dart';
import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/data/repository/profile_repository.dart';

Future<List<ChatItem>> fetchChatItems(List<ChatInfo> chatInfos) async {
  Profilestorage storage = Profilestorage();
  List<ChatItem> chatItems = [];

  for (var chatInfo in chatInfos) {
    ProfileModel? profile = await storage.getProfile(chatInfo.member);
    if (profile != null) {
      chatItems.add(ChatItem(
        userid: chatInfo.member,
        imageurl: profile.imageurl ?? '',
        username: profile.username,
      ));
    }
  }
  return chatItems;
}
