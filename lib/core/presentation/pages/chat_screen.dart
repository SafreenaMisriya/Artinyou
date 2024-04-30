import 'package:art_inyou/core/presentation/pages/authentication/login_screen.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/google_auth/cubit/googleauth_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
     double height = Responsive.screenHeight(context);
    return Scaffold(
      body:  Column(
          children: [
            SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('Chat',style: MyFonts.headingTextStyle,),
                    ),
                    IconButton(onPressed: ()async{
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
                    }, icon: const Icon(Icons.more_vert_rounded))
                  ],
                ),
                 SizedBox(
                  height: height * 0.01,
                ),
                const Divider(),
                 Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  focusColor: color,
                  fillColor: color,
                  filled: true,
                  prefixIcon:const Icon(Icons.search,color: Colors.grey,),
                  hintText: 'Search Here..',
                  hintStyle:const TextStyle(color: Colors.grey),
                ),
              ),
              
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return  ListTile(
                   leading: ClipOval(child: CircleAvatar(child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh7ogUYtR66AVscPGclBkMHRagtzJ9D0w04Q&s'),)),
                   title: const Text('George'),
                   subtitle: const Text('How are you ?'),
                   trailing: const Text('2.30 PM'),
                  );
                },),
            )
        
        
          ],
        ),
      
    );
  }
}