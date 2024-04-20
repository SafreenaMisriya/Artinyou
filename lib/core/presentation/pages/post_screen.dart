
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/dropdown.dart';
import 'package:art_inyou/core/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
 TextEditingController titlecontroller=TextEditingController() ;
 TextEditingController pricecontroller=TextEditingController() ;
 TextEditingController aboutcontroller=TextEditingController() ;


  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.06,
              ),
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/image/img1.jpg',
                        height: height * 0.3,
                        width: width * 0.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: width * 0.03,
                      left: width * 0.3,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.camera_enhance_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
              CustomTextField(controller: titlecontroller,  labelText: 'Title',),
              SizedBox(height: height * 0.03),
              CustomTextField(controller: pricecontroller, labelText: 'Price',keyboardType: TextInputType.number,),
              SizedBox(height: height * 0.03),
               const DropDowm(),
              SizedBox(height: height * 0.03),
             CustomTextField(controller: aboutcontroller, labelText: 'About',maxLines: 3,keyboardType: TextInputType.multiline,),
              
            ],
          ),
        ),
      ),
    );
  }
}

