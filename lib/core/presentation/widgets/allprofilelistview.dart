

// ignore_for_file: must_be_immutable

import 'package:art_inyou/core/data/model/chatlist.dart';
import 'package:art_inyou/core/data/model/messagemodel.dart';
import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/data/repository/chat_repository.dart';
import 'package:art_inyou/core/presentation/pages/chatshow_screen.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

ChatRepository chat = ChatRepository();

class CustomProfilesListView extends StatelessWidget {
  final List<ProfileModel> items;
  final double height;
  final String userid;

  const CustomProfilesListView({
    super.key,
    required this.items,
    required this.height,
    required this.userid,
  });

  @override
  Widget build(BuildContext context) {
        
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: CustomListTile(
            imageUrl: items[index].imageurl,
            username: items[index].username,
            height: height,
          ),
          onTap: () {
            ConversationModel conveseration=ConversationModel(
              
              initiatedAt: DateTime.now(),
              initiatedBy: userid,
              lastUpdatedAt: DateTime.now(),
              participantIds: [userid,items[index].userid],
              participants: [userid,items[index].username],
              lastMessage: {},
            
               );
               chat.addConversation(conveseration);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatShowScreen(
                          items: items,
                          selecteditem: index,
                          userid: userid,
                        )));
          },
        );
      },
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String imageUrl;
  final String username;
  final double height;

  CustomListTile({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.height,
  });
  MessageModel? message;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: height * 0.05,
        width: height * 0.05,
        child: ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        username,
        style: MyFonts.boldTextStyle,
      ),
      trailing:Shimmer.fromColors( baseColor:Colors.blue,highlightColor: Colors.white, child: const Text( 'Chat',style: MyFonts.boldTextStyle,),),
    );
  }
}
