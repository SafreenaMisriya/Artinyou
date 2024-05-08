import 'dart:io';
import 'package:art_inyou/core/data/model/messagemodel.dart';
import 'package:art_inyou/core/data/repository/chat_repository.dart';
import 'package:art_inyou/core/presentation/bloc/bloc/message_bloc.dart';
import 'package:art_inyou/core/presentation/bloc/emoji/emoji_cubit.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

ChatRepository chat = ChatRepository();

class ChatShowScreen extends StatefulWidget {
  final List<dynamic> items;
  final int selecteditem;
  final String userid;
  const ChatShowScreen(
      {super.key,
      required this.items,
      required this.selecteditem,
      required this.userid});

  @override
  State<ChatShowScreen> createState() => _ChatShowScreenState();
}

class _ChatShowScreenState extends State<ChatShowScreen> {
  TextEditingController textcontroller = TextEditingController();
  ChatRepository chat = ChatRepository();
  FocusNode myfocusnode = FocusNode();
  bool showemoji = false;

  @override
  void initState() {
    super.initState();
    myfocusnode.addListener(() {
      if (myfocusnode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myfocusnode.dispose();
    textcontroller.dispose();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();
  void scrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    var selecteditem = widget.items[widget.selecteditem];
    final messageBloc = BlocProvider.of<MessageBloc>(context);
      final emojiCubit = context.watch<EmojiCubit>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: false,
          flexibleSpace: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              SizedBox(
                height: height * 0.05,
                width: height * 0.05,
                child: ClipOval(
                  child: Image.network(
                    selecteditem.imageurl ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.05,
              ),
              Column(
                children: [
                  Text(
                    selecteditem.username ?? "",
                    style: MyFonts.boldTextStyle,
                  ),
                  const Text(
                    'Last seen 2.30 pm',
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<MessageModel>>(
              stream: chat.getMessages(selecteditem.userid, widget.userid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  List<MessageModel> messagesList = snapshot.data!;
                  return messagesList.isEmpty
                      ? Center(
                          child: Image.network(
                            'https://i.pinimg.com/originals/8a/a4/59/8aa4595fb24b6ed585dddac4622b2445.gif',
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) {
                            return MessageCard(
                              messages: messagesList[index],
                              userid: widget.userid,
                            );
                          },
                        );
                } else {
                  return const Center(
                    child: Text('No data'),
                  );
                }
              },
            )),
            chatput(selecteditem.userid, widget.userid, messageBloc,
                selecteditem.username,emojiCubit),
            BlocBuilder<EmojiCubit, EmojiState>(
          builder: (context, state) {
            if (state == EmojiState.show) {
              return SizedBox(
                height: height * .35,
                child: EmojiPicker(
                  textEditingController: textcontroller,
                  config: Config(
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                    ),
                  ),
                ),
              );
            } else {
              return SizedBox.shrink(); // Return an empty SizedBox if emoji picker should not be shown
            }
          },
        ),
          ],
        ),
      ),
    );
  }

  Widget chatput(
      String toid, String fromid, MessageBloc bloc, String toIdname,EmojiCubit emojiCubit) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                       emojiCubit.toggleEmoji(); 
                      },
                      icon: const Icon(Icons.emoji_emotions)),
                  Expanded(
                    child: TextField(
                      focusNode: myfocusnode,
                      controller: textcontroller,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type your Message ...',
                        hintStyle: TextStyle(color: greycolor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.image)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.camera_alt)),
                  MaterialButton(
                    onPressed: () async {
                      String formattedTime =
                          DateFormat.jm().format(DateTime.now());
                      MessageModel model = MessageModel(
                        toIdname: toIdname,
                        fromId: fromid,
                        message: textcontroller.text,
                        toId: toid,
                        time: formattedTime,
                        read: '',
                      );
                      if (textcontroller.text.isNotEmpty) {
                        bloc.add(MessageAddEvent(messages: model));
                        textcontroller.text = "";
                        scrollDown();
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: redcolor,
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
