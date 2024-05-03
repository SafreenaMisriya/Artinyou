import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/presentation/pages/chatshow_screen.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  final List<ProfileModel> items;
  final double height;

  const CustomListView({super.key, 
    required this.items,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount:  items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: CustomListTile(
            imageUrl: items[index].imageurl ,
            username:  items[index].username,
            height: height,
          ),
          onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatShowScreen(items: items,selecteditem: index,))); 
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

  const CustomListTile({super.key, 
    required this.imageUrl,
    required this.username,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
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
      subtitle: const Text('How are you ?'),
      trailing: const Text('2.30 PM'),
    );
  }
}
