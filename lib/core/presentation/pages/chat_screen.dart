// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/domain/profiledata.dart';
import 'package:art_inyou/core/presentation/bloc/profile/bloc/profile_bloc.dart';
import 'package:art_inyou/core/presentation/pages/authentication/login_screen.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatelessWidget {
  final String userid;
 const ChatScreen({super.key,required this.userid});


  @override
  Widget build(BuildContext context) {
    final profilebloc = BlocProvider.of<ProfileBloc>(context);
    double height = Responsive.screenHeight(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.remove('email');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert_rounded))
            ],
          ),
          SizedBox(
            height: height * 0.01,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: StreamBuilder(
                stream: getAllProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ProfileModel> posts = snapshot.data!;
                    return TextField(
                      onChanged: (value) {
                        profilebloc.add(ProfileSearchEvent(posts, value));
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        focusColor: color,
                        
                        fillColor: color,
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        hintText: 'Search Here..',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                    );
                  } else {
                    return const Text('No data...');
                  }
                }),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
            if (state is SearchLoaded) {
              List<ProfileModel> profiles = state.filteredProfiles;
              return profiles.isNotEmpty
                  ? Expanded(
                      child: CustomListView(items: profiles, height: height,userid: userid,))
                  : Image.asset('assets/image/noresult.gif');
            } else if (state is Searchstart) {
              return const Text('loading');
            } else {
              return Expanded(
                child: StreamBuilder(
                    stream: getAllProfile(),
                    builder: (context, snapshot) {
                     if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        List<ProfileModel>? posts = snapshot.data;
                        return CustomListView(items: posts!, height: height,userid:userid,);
                      } else {
                        return const Text('No data');
                      }
                    }),
              );
            }
          })
        ],
      ),
    );
  }
}
