import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
          )
        ],
      ),
    );
  }
}