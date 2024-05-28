import 'dart:io';
import 'package:art_inyou/models/model/messagemodel.dart';
import 'package:art_inyou/repositories/chat/chat_repository.dart';
import 'package:art_inyou/blocs/bloc/message/message_bloc.dart';
import 'package:art_inyou/blocs/bloc/emoji/emoji_cubit.dart';
import 'package:art_inyou/screens/chat/chat_appbar.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/widgets/chat/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

ChatRepository chat = ChatRepository();

class ChatShowScreen extends StatefulWidget {
  final List<dynamic> items;
  final int selecteditem;
  final String userid;
  final String activetime;
  const ChatShowScreen(
      {super.key,
      required this.items,
      required this.selecteditem,
      required this.activetime,
      required this.userid});

  @override
  State<ChatShowScreen> createState() => _ChatShowScreenState();
}

class _ChatShowScreenState extends State<ChatShowScreen> {
  TextEditingController textcontroller = TextEditingController();
  ChatRepository chat = ChatRepository();
  FocusNode myfocusnode = FocusNode();
  List<String> images = [];

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
    scrollController.dispose();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();
  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    var selecteditem = widget.items[widget.selecteditem];
    final messageBloc = BlocProvider.of<MessageBloc>(context);
    final emojiCubit = context.watch<EmojiCubit>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: customAppbar(height, width, context, selecteditem.imageurl,
              selecteditem.username, widget.activetime),
          body: Column(
            children: [
              Expanded(child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  return StreamBuilder<List<MessageModel>>(
                    stream: chat.getChat(selecteditem.userid, widget.userid),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
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
                                reverse: true,
                                controller: scrollController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: messagesList.length,
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    height: height * 0.5,
                                    messages: messagesList[index],
                                    userid: widget.userid,
                                  );
                                },
                              );
                      } else {
                        return Center(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: redcolor,
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              )),
              chatput(
                selecteditem.userid,
                widget.userid,
                messageBloc,
                selecteditem.username,
                emojiCubit,
              ),
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
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatput(
    String toid,
    String fromid,
    MessageBloc bloc,
    String toIdname,
    EmojiCubit emojiCubit,
  ) {
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
                        emojiCubit.state == EmojiState.show
                            ? FocusScope.of(context).unfocus()
                            : FocusScope.of(context).requestFocus(myfocusnode);
                      },
                      icon: emojiCubit.state == EmojiState.show
                          ? const Icon(Icons.emoji_emotions)
                          : const Icon(Icons.keyboard)),
                  Expanded(
                    child: TextField(
                      onTap: () => emojiCubit.hideEmoji(),
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
                  BlocConsumer<MessageBloc, MessageState>(
                    listener: (context, state) {
                      if (state is MsgImageUploaded) {
                        images = state.imageUrls;
                        String formattedTime =
                            DateFormat.jm().format(DateTime.now());
                        if (images.isNotEmpty) {
                          MessageModel model = MessageModel(
                            toIdname: toIdname,
                            fromId: fromid,
                            message: images.join(),
                            toId: toid,
                            type: Type.image,
                            time: formattedTime,
                            read: '',
                          );
                          scrollDown;
                          bloc.add(MessageAddEvent(
                              messages: model,
                              receiverid: model.toId,
                              userid: model.fromId));
                        }
                      }
                    },
                    builder: (context, state) {
                      return Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                context
                                    .read<MessageBloc>()
                                    .add(SelectprofileImageEvent());
                              },
                              icon: const Icon(Icons.image)),
                          IconButton(
                              onPressed: () {
                                context.read<MessageBloc>().add(
                                    SelectprofileImageEvent(fromCamera: true));
                              },
                              icon: const Icon(Icons.camera_alt)),
                        ],
                      );
                    },
                  ),
                  MaterialButton(
                    onPressed: () async {
                      String formattedTime =
                          DateFormat.jm().format(DateTime.now());
                      if (textcontroller.text.isNotEmpty) {
                        MessageModel model = MessageModel(
                          toIdname: toIdname,
                          fromId: fromid,
                          message: textcontroller.text,
                          toId: toid,
                          type: Type.text,
                          time: formattedTime,
                          read: '',
                        );
                        scrollDown;
                        bloc.add(MessageAddEvent(
                            messages: model,
                            receiverid: model.toId,
                            userid: model.fromId));
                      }
                      textcontroller.text = "";
                      scrollDown;
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
