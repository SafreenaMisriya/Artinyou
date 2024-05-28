 import 'package:art_inyou/models/model/chatlist.dart';
import 'package:art_inyou/models/model/chatlistinfo.dart';
import 'package:art_inyou/models/model/profilemodel.dart';
import 'package:art_inyou/repositories/profile/profile_repository.dart';

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
