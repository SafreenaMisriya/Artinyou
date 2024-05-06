import 'package:art_inyou/core/domain/profiledata.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
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
  List<String>list=[];
  TextEditingController textcontroller=TextEditingController();
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
                IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
                SizedBox(
                  height: height * 0.05,
                  width: height * 0.05,
                  child: ClipOval(
                    child: Image.network(
                      selecteditem.imageurl?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Column(
                  children: [
                    Text(selecteditem.username ?? "",style: MyFonts.boldTextStyle,),
                    const Text('Last seen 2.30 pm',style: TextStyle(color: Colors.black54),),

                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                      stream: getAllProfile(),
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
                       final list=[];
                
                          return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount:  list.length,
                      itemBuilder: (context, index) {
                        return const Text('vvhh');
                      },
                    );
                        } else {
                          return const Text('No data');
                        }
                      }),
              ),
              chatput(),
            ],
          
        ),
      ),
    );
  }
Widget chatput(){
   return  Padding(
     padding: const EdgeInsets.all(8.0),
     child: Row(
         children: [
               Expanded(
               child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                 child:  Row(
                      children: [
                        IconButton(onPressed: (){}, icon: const Icon(Icons.emoji_emotions)),
                       Expanded(
                         child: TextField(
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
                        IconButton(onPressed: (){}, icon: const Icon(Icons.image)),
                        IconButton(onPressed: (){}, icon: const Icon(Icons.camera_alt)),
                      ],
                     ),
                 ),
               ),
              MaterialButton(
                onPressed: (){
                  if(textcontroller.text.isNotEmpty){
                    
                    textcontroller.text="";
                  }
                },
     child: Icon(Icons.send,color: redcolor,),
             
           ),
         ],
       
     ),
   );
   
  }
}