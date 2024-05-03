import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/dropdown.dart';
import 'package:flutter/material.dart';

class ChatShowScreen extends StatefulWidget {
  final List<dynamic> items;
  final int selecteditem;
  const ChatShowScreen(
      {super.key, required this.items, required this.selecteditem});

  @override
  State<ChatShowScreen> createState() => _ChatShowScreenState();
}

class _ChatShowScreenState extends State<ChatShowScreen> {
  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    var selecteditem = widget.items[widget.selecteditem];
    return  SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            automaticallyImplyLeading: false,
            flexibleSpace: Row(
              children: [
                IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
                SizedBox(
                  height: height * 0.05,
                  width: height * 0.05,
                  child: ClipOval(
                    child: Image.network(
                      selecteditem.imageurl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Column(
                  children: [
                    Text(selecteditem.username,style: MyFonts.boldTextStyle,),
                    const Text('Last seen 2.30 pm',style: TextStyle(color: Colors.black54),),

                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              chatput(),
            ],
          
        ),
      ),
    );
  }
 chatput(){
   Expanded(child:Card(
     child: Row(
      children: [
        IconButton(onPressed: (){}, icon: Icon(Icons.emoji_emotions)),
        Expanded(child: TextField(
          decoration: InputDecoration(
            hintText: 'Type your Message ...',
            hintStyle: TextStyle(color: greycolor),
            border: InputBorder.none,
          ),
        )),
        IconButton(onPressed: (){}, icon: Icon(Icons.image)),
        
     
      ],
     ),
   ) ,);
  }
}