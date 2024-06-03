// ignore_for_file: library_private_types_in_public_api

import 'package:art_inyou/models/model/chatlist.dart';
import 'package:art_inyou/models/model/chatlistinfo.dart';
import 'package:art_inyou/repositories/chat/chat_repository.dart';
import 'package:art_inyou/repositories/profile/profile_repository.dart';
import 'package:art_inyou/screens/chat/chat_view.dart';
import 'package:art_inyou/screens/chat/showall_profile.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/date_and_time/date_time.dart';
import 'package:art_inyou/screens/chat/fetchingchat.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/loading_view/loadinglistview.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Profilestorage storge = Profilestorage();
ChatRepository chat = ChatRepository();

class ChatScreen extends StatefulWidget {
  final String userid;
  const ChatScreen({super.key, required this.userid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<ChatItem>> _chatItemsFuture;

  @override
  void initState() {
    super.initState();
    _chatItemsFuture = _fetchChatItems();
  }

  Future<List<ChatItem>> _fetchChatItems() async {
    List<ChatInfo> chatInfos = await chat.getChats(widget.userid).first;
    return fetchChatItems(chatInfos);
  }

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
                userid: widget.userid,
              ),
            ),
          );
        },
        backgroundColor: color,
        child: Icon(
          Icons.group_add_rounded,
          color: redcolor,
        ),
      ),
      body: Column(
        children: [
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
             Container(),
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          const Divider(),
          StreamBuilder<List<ChatInfo>>(
            stream: chat.getChats(widget.userid),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return  Center(child:SpinKitFadingCircle(color: redcolor,));
              }
              if (chatSnapshot.hasError) {
                return Center(child: Text('Error: ${chatSnapshot.error}'));
              }
              if (!chatSnapshot.hasData || chatSnapshot.data!.isEmpty) {
                return const Center(child: Text('Start Your Conversation'));
              }
              return FutureBuilder<List<ChatItem>>(
                future: _chatItemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return shimmerChatListView();
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Start Your Conversation'));
                  }
                  List<ChatItem> chatItems = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: chatItems.length,
                      itemBuilder: (context, index) {
                        ChatItem chatItem = chatItems[index];
                        ChatInfo chatInfoItem = chatSnapshot.data![index];
                        bool isImageLink =
                            chatInfoItem.lastMessage.startsWith('http://') ||
                                chatInfoItem.lastMessage.startsWith('https://');
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(chatItem.imageurl),
                          ),
                          title: Text(
                            chatItem.username,
                            style: MyFonts.boldTextStyle,
                          ),
                          subtitle: Text(
                            isImageLink ? 'Image 📷' : chatInfoItem.lastMessage,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            formatDateTime(chatInfoItem.lastMessageTime),
                            style: TextStyle(color: greycolor),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatShowScreen(
                                  activetime: chatInfoItem.lastActive,
                                  items: chatItems,
                                  selecteditem: index,
                                  userid: widget.userid,
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
          ),
        ],
      ),
    );
  }
}
