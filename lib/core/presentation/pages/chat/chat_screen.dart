// ignore_for_file: use_build_context_synchronously

import 'package:art_inyou/core/data/model/chatlist.dart';
import 'package:art_inyou/core/data/repository/chat_repository.dart';
import 'package:art_inyou/core/data/repository/profile_repository.dart';
import 'package:art_inyou/core/presentation/pages/chat/chatshow_screen.dart';
import 'package:art_inyou/core/presentation/pages/chat/showall_profile.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/loadinglistview.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/fetchingchat.dart';



Profilestorage storge = Profilestorage();
ChatRepository chat = ChatRepository();

class ChatScreen extends StatelessWidget {
  final String userid;
  const ChatScreen({super.key, required this.userid});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowAllProfile(
                          userid: userid,
                        )));
          },
          backgroundColor: color,
          child: Icon(
            Icons.group_add_rounded,
            color: redcolor,
          ),
        ),
        body: Column(children: [
          SizedBox(
            height: height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Chat',
                  style: MyFonts.headingTextStyle,
                ),
              ),
              IconButton(
                  onPressed: () async {},
                  icon: const Icon(Icons.more_vert_rounded))
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          const Divider(),
          StreamBuilder(
            stream: chat.getChats(userid),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (chatSnapshot.hasError) {
                return Center(child: Text('Error: ${chatSnapshot.error}'));
              }

              if (!chatSnapshot.hasData || chatSnapshot.data!.isEmpty) {
                return const Center(child: Text('No conversations found'));
              }

              List<String> userIds = chatSnapshot.data!;

              return FutureBuilder<List<ChatItem>>(
                future: fetchChatItems(userIds),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return shimmerChatListView();
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No conversations found'));
                  }

                  List<ChatItem> chatItems = snapshot.data!;

                  return Expanded(
                    child: ListView.builder(
                      itemCount: chatItems.length,
                      itemBuilder: (context, index) {
                        ChatItem? chatItem = chatItems[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(chatItem.imageurl),
                          ),
                          title: Text(chatItem.username),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatShowScreen(
                                  items: chatItems,
                                  selecteditem: index,
                                  userid: userid,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          )
        ]));
  }

 
}
