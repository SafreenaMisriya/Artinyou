// ignore_for_file: must_be_immutable

import 'package:art_inyou/core/data/model/messagemodel.dart';
import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/data/repository/chat_repository.dart';
import 'package:art_inyou/core/presentation/pages/chatshow_screen.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:flutter/material.dart';

ChatRepository chat = ChatRepository();

class CustomListView extends StatelessWidget {
  final List<ProfileModel> items;
  final double height;
  final String userid;

  const CustomListView({
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
            toid: items[index].userid,
            height: height,
            fromid: userid,
          ),
          onTap: () {
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
  final String fromid;
  final String toid;

  CustomListTile({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.height,
    required this.fromid,
    required this.toid,
  });
  MessageModel? message;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: chat.getLastMessages(toid, fromid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: redcolor,
              ),
            );
          } else if (snapshot.hasData) {
            final List<MessageModel>? messages = snapshot.data;
            if (messages != null && messages.isNotEmpty) {
              final MessageModel lastMessage = messages.first;

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
                subtitle: Text(lastMessage.message),
                trailing: Text(lastMessage.time),
              );
            } else {
              return Text('');
            }
          } else {
            return Text('No message');
          }
        });
  }
}
