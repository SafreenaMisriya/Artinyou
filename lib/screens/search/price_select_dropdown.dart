// ignore_for_file: library_private_types_in_public_api

import 'package:art_inyou/repositories/price/pricefetching.dart';
import 'package:art_inyou/screens/search/price_rangedisply.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:flutter/material.dart';

class PriceRangeDropdown extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const PriceRangeDropdown({super.key, this.onChanged});

  @override
  _PriceRangeDropdownState createState() => _PriceRangeDropdownState();
}

class _PriceRangeDropdownState extends State<PriceRangeDropdown> {
  String selectedRange = 'All';

  final List<String> priceRanges = [
    'All',
    'Less than 100',
    '200 - 400',
    '500 - 800',
    'More than 800',
    'Free'
  ];

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
            value: selectedRange,
            onChanged: (String? newValue) {
              setState(() {
                selectedRange = newValue!;
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue);
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DropdownPrice(
                              postsFuture: fetchPosts(newValue),
                              title: newValue,
                              visible: true,
                            )));
              });
            },
            items: priceRanges.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            icon: const Icon(Icons.arrow_drop_down_sharp, size: 30),
            style: MyFonts.bodyTextStyle,
            underline: Container(),
          ),
        ));
  }
}
