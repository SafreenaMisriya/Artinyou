
// ignore_for_file: use_build_context_synchronously

import 'package:art_inyou/core/data/model/chatlist.dart';
import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/data/repository/chat_repository.dart';
import 'package:art_inyou/core/data/repository/profile_repository.dart';
import 'package:art_inyou/core/presentation/bloc/profile/bloc/profile_bloc.dart';
import 'package:art_inyou/core/presentation/pages/chatshow_screen.dart';
import 'package:art_inyou/core/presentation/pages/showall_profile.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/loadinglistview.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
Profilestorage storge=Profilestorage();
ChatRepository chat =ChatRepository();
class ChatScreen extends StatelessWidget {
  final String userid;
 const ChatScreen({super.key,required this.userid});

  @override
  Widget build(BuildContext context) {
    final profilebloc = BlocProvider.of<ProfileBloc>(context);
    double height = Responsive.screenHeight(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowAllProfile(userid: userid,)));
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
              IconButton(
                  onPressed: () async {
                    //      final googleAuthCubit = context.read<GoogleauthCubit>();
                    //  googleAuthCubit.logout();
                    // SharedPreferences sharedPreferences =
                    //     await SharedPreferences.getInstance();
                    // sharedPreferences.remove('email');
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const LoginScreen(),
                    //   ),
                    // );
                  },
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
                title: Text(chatItem.username ),
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


        ]
      )
      );
  }
  
          // Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: StreamBuilder(
          //       stream: getAllProfile(),
          //       builder: (context, snapshot) {
          //         if (snapshot.hasData) {
          //           List<ProfileModel> chats = snapshot.data!;
          //           return TextField(
          //             onChanged: (value) {
          //               profilebloc.add(ProfileSearchEvent(chats, value));
          //             },
          //             decoration: InputDecoration(
          //               border: OutlineInputBorder(
          //                   borderRadius: BorderRadius.circular(10),
          //                   borderSide: BorderSide.none),
          //               focusColor: color,
                        
          //               fillColor: color,
          //               filled: true,
          //               prefixIcon: const Icon(
          //                 Icons.search,
          //                 color: Colors.grey,
          //               ),
          //               hintText: 'Search Here..',
          //               hintStyle: const TextStyle(color: Colors.grey),
          //             ),
          //           );
          //         } else {
          //           return const Text('No data...');
          //         }
          //       }),
          // ),
          // BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          //   if (state is SearchLoaded) {
          //     List<ProfileModel> profiles = state.filteredProfiles;
          //     return profiles.isNotEmpty
          //         ? Expanded(
          //             child: CustomListView(items: profiles, height: height,userid: userid,))
          //         : Image.asset('assets/image/noresult.gif');
          //   } else if (state is Searchstart) {
          //     return const Text('loading');
          //   } else {
          //     return Expanded(
          //       child: StreamBuilder(
          //           stream: getAllProfile(),
          //           builder: (context, snapshot) {
          //            if (snapshot.hasError) {
          //               return Center(
          //                 child: Text('Error: ${snapshot.error}'),
          //               );
          //             } else if (snapshot.hasData) {
          //               List<ProfileModel>? posts = snapshot.data;
          //               return CustomListView(items: posts!, height: height,userid:userid,);
          //             } else {
          //               return const Text('No data');
          //             }
          //           }),
          //     );
          //   }
          // })
  Future<List<ChatItem>> fetchChatItems(List<String> userIds) async {
  
  List<ChatItem> chatItems = [];

  for (String userId in userIds) {
    ProfileModel? profile = await storge.getProfile(userId);
    if (profile != null) {
      chatItems.add(ChatItem(
        userid: userId,
        imageurl: profile.imageurl ?? '',
        username: profile.username ,
      ));
    }
  }

  return chatItems;
}    
  }

