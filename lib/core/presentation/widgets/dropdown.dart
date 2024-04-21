import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:flutter/material.dart';

class DropDowm extends StatefulWidget {
  const DropDowm({super.key});

  @override
  State<DropDowm> createState() => _DropDowmState();
}
String choosevalue = "Creative";
  final List<String> items = ['Creative', 'Fantasy', 'Craft', '3D Image', 'Wallpapers', 'Photography'];
class _DropDowmState extends State<DropDowm> {
  @override
  Widget build(BuildContext context) {
      double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return  Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: color,
            ),
            height: height * 0.08,
            width: width * 0.9,
            child: Center(
              child: DropdownButton<String>(
                onChanged: (String? selectvalue) {
                  setState(() {
                    choosevalue = selectvalue!;
                  });
                },
                value: choosevalue,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down_sharp, size: 30),
                style: MyFonts.bodyTextStyle,
                underline: Container(),
                
              ),
            ),
          );
  }
}