import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/gridview.dart';
import 'package:art_inyou/core/presentation/widgets/label.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.only(left: 45),
                  child: Text(
                    'Angelina George',
                    style: MyFonts.headingTextStyle,
                  ),
                )),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.menu_rounded, size: height * 0.04),
              ),
            ],
          ),
          Center(
            child: ClipOval(
              child: Image.network(
                'https://newprofilepic.photo-cdn.net//assets/images/article/profile.jpg?90af0c8',
                height: height * 0.09,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ), 
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('10',style: MyFonts.normalTextStyle,),
                  Text('Post',style: MyFonts.boldTextStyle,),
                ],
              ),
               Column(
                children: [
                  Text('1000',style: MyFonts.normalTextStyle,),
                  Text('Followers',style: MyFonts.boldTextStyle,),
                ],
              ),
               Column(
                children: [
                  Text('200',style: MyFonts.normalTextStyle,),
                  Text('Following',style: MyFonts.boldTextStyle,),
                ],
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ), 
          labelwidget(labelText: 'Edit Profile', onTap: (){}),
           SizedBox(
            height: height * 0.02,
          ),
          const Expanded(child: GridViewScreen()),
        ],
      ),
    );
  }
}
// Center(
//             child: labelwidget(labelText: 'logout', onTap: ()async{
//               SharedPreferences sharedPreferences=await SharedPreferences.getInstance(); 
//               sharedPreferences.remove('email');
//                Navigator.push(context, MaterialPageRoute(builder: (context)=>const OnboardingScreen()));
//             }),
//           )