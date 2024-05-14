import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/domain/profiledata.dart';
import 'package:art_inyou/core/presentation/bloc/profile/bloc/profile_bloc.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/loadinglistview.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/pages/chat/allprofilelistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowAllProfile extends StatelessWidget {
  final String userid;
  const ShowAllProfile({super.key,required this.userid});
  @override
  Widget build(BuildContext context) {
     final profilebloc = BlocProvider.of<ProfileBloc>(context);
        double height = Responsive.screenHeight(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.01,
              ),
               Row(
                children: [
                     IconButton(onPressed: (){
                      Navigator.pop(context);
                     }, icon: const Icon(Icons.arrow_back)),
                 const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      'All Connections',
                      style: MyFonts.headingTextStyle,
                    ),
                  ),
            
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
                          child: CustomProfilesListView(items: profiles, height: height,userid: userid,))
                      : Image.asset('assets/image/noresult.gif');
                } else if (state is Searchstart) {
                  return shimmerChatListView();
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
                            return CustomProfilesListView(items: posts!, height: height,userid:userid,);
                          } else {
                            return const Text('No data');
                          }
                        }),
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}