import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  // final MessageModel message;
  const MessageCard({super.key,
  //  required this.message
   });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        senderCustom(message: 'how are you babefuweijfiwefiqewifuiwfrhiqefuqerif ?',time: '2.30 pm'),
        receiverCustom(message: 'fine. what about you jkwsiqwuthu3tq349utu9qetuq3etuhqeru9ht',time: '2.31 pm'),
      ],
    );
  }

 Widget senderCustom({String? message, String? time}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message!,
                  style: MyFonts.bodyTextStyle
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      time!,
                      style: TextStyle(
                        color: greycolor,
                        fontSize: 12.0,
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
Widget receiverCustom({String? message, String? time}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: redcolor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message!,
                  style: MyFonts.iconTextStyle,
                ),
                const SizedBox(height: 4.0),
                Text(
                  time!,
                  style: TextStyle(
                    color: greycolor,
                    fontSize: 12.0,
                  ),
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
