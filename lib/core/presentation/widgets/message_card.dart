// ignore_for_file: unrelated_type_equality_checks

import 'package:art_inyou/core/data/model/messagemodel.dart';
import 'package:art_inyou/core/data/repository/chat_repository.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:flutter/material.dart';

ChatRepository chat = ChatRepository();

class MessageCard extends StatelessWidget {
  final MessageModel messages;
  final String userid;
  const MessageCard({
    super.key,
    required this.messages,
    required this.userid,
  });

  @override
  Widget build(BuildContext context) {
    return userid == messages.fromId ? sendCustom() : receiveCustom();
  }

  Widget receiveCustom() {
    if (messages.read != 'true') {
      chat.updateMessageReadStatus(userid, messages.toId, messages.messageid);
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13.0),
                topRight: Radius.circular(13.0),
                bottomRight: Radius.circular(13.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messages.message,
                  style: MyFonts.bodyTextStyle,
                ),
                const SizedBox(height: 4.0),
                Text(
                  messages.time,
                  style: TextStyle(
                    color: greycolor,
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sendCustom({String? message, String? time}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: redcolor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(13.0),
                  topRight: Radius.circular(13.0),
                  bottomLeft: Radius.circular(13.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    messages.message,
                    style: MyFonts.iconTextStyle,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (messages.read.isNotEmpty)
                        const Icon(Icons.done_all, color: Colors.black),
                      Text(
                        messages.time,
                        style: TextStyle(
                          color: greycolor,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
