import 'package:art_inyou/repositories/post/fetching.dart';
import 'package:art_inyou/screens/search/price_rangedisply.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:flutter/material.dart';

class DropDownSelect extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  const DropDownSelect({super.key, this.onChanged});

  @override
  State<DropDownSelect> createState() => _DropDownSelectState();
}

String choosevalue = "Creative";
final List<String> items = [
  'Creative',
  'Fantasy',
  'Craft',
  'Drawings',
  'Wallpapers',
  'Photography',
  "Horror",
  "TraditionalArt",
  'GameArt',
  'DigitalArt'
];

class _DropDownSelectState extends State<DropDownSelect> {
  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: color,
      ),
      height: height * 0.07,
      width: width * 0.4,
      child: Center(
        child: DropdownButton<String>(
          onChanged: (String? selectvalue) {
            setState(() {
              choosevalue = selectvalue!;
              if (widget.onChanged != null) {
                widget.onChanged!(selectvalue);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DropdownPrice(
                            postsFuture: getPostsByCategory(selectvalue),
                            title: selectvalue,
                            visible: true,
                          )));
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
