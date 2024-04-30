import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/presentation/bloc/profile/bloc/profile_bloc.dart';
import 'package:art_inyou/core/presentation/pages/account_screen.dart';
import 'package:art_inyou/core/presentation/pages/bottombar.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileModel? edit;
  const ProfileScreen({super.key, this.edit, });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController biocontroller = TextEditingController();
  
  List<String> images = [];
  bool isdEdit = false;

  @override
  void initState() {
      final edit = widget.edit;
    if (edit != null) {
       isdEdit = true;
      usernamecontroller.text= edit.username;
      biocontroller.text=edit.bio;
      images=edit.imageurl.split(',');
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    final profilebloc = BlocProvider.of<ProfileBloc>(context);
     User? currentUser = FirebaseAuth.instance.currentUser;
  String userId = currentUser?.uid ?? '';
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                    children: [
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const AccountScreen()));
                    }, icon: const Icon(Icons.arrow_back_ios)),
                 Text(
                isdEdit?  'Edit Profile':'Add Profile',
                  style: MyFonts.headingTextStyle,
                ),
                TextButton(
                    onPressed: () {
                      ProfileModel model = ProfileModel(
                        userid: userId,
                          username: usernamecontroller.text,
                          bio: biocontroller.text,
                          imageurl: images.join());
                    isdEdit?  profilebloc.add(ProfileEditEvent(model: model, id: userId))
                           : profilebloc.add(ProfileAddEvent(model: model));
                    isdEdit ? Navigator.pop(context)     
                     : Navigator.push(context, MaterialPageRoute(builder: (context)=> const BottomBar()));
                    },
                    child: const Text(
                      'Save',
                      style: MyFonts.bodyTextStyle,
                    )),
              ],
            ),
            SizedBox(
              height: height * 0.06,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ImageUploaded) {
                    images = state.imageUrls;
                  } 
                },
                
                builder: (context, state) {
                  if(state is Profileloading){
                  return const  Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                              width: height *
                              0.2, 
                          height: height * 0.2,
                            child: ClipOval(
                                child: Image.network(
                                   images.isEmpty
                                   ? 'https://cdn.vectorstock.com/i/500p/15/40/blank-profile-picture-image-holder-with-a-crown-vector-42411540.jpg'
                                   : images[0],
                                   fit: BoxFit.cover,
                                  )),
                          ),
                          Positioned(
                              top: height * 0.15,
                              left: height * 0.07,
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: const Text(
                                            'Profile',
                                            style: MyFonts.headingTextStyle,
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    context.read<ProfileBloc>().add(
                                                        SelectprofileImageEvent(
                                                            fromCamera: true));
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: const Icon(
                                                    Icons.camera_alt_rounded,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    context.read<ProfileBloc>().add(
                                                        SelectprofileImageEvent());
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: const Icon(
                                                    Icons.image,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: redcolor,
                                    size: height * 0.04,
                                  )))
                        ],
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      CustomTextField(
                          controller: usernamecontroller, labelText: 'Username'),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      CustomTextField(controller: biocontroller, labelText: 'Bio')
                    ],
                  );
                },
              ),
            )
                    ],
                  ),
          )),
    );
  }
}
