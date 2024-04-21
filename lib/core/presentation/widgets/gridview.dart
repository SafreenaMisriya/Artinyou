import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GridViewScreen extends StatelessWidget {
  const GridViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = Responsive.screenWidth(context);
    return Scaffold(
      body: MasonryGridView.builder(
        itemCount: 9,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        itemBuilder: (context, index) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset('assets/image/img${index + 1}.jpg'),
                  ),
                  const Positioned(
                    top: 10,
                    left: 40,
                    child: Text(
                      'Image Title',
                      style: MyFonts.iconTextStyle,
                    ),
                  ),
                  Positioned(
                      top: 3,
                      right: 0,
                      child: PopupMenuButton(
                          iconColor: Colors.white,
                          itemBuilder: (context) => [
                                const PopupMenuItem(
                                  child: Text('Save'),
                                ),
                                const PopupMenuItem(
                                  child: Text('Share'),
                                ),
                              ])),
                  const Positioned(
                      bottom: 0,
                      right: 4,
                      child: Text(
                        '₹199',
                        style: MyFonts.iconTextStyle,
                      )),
                  Positioned(
                    bottom: 55,
                    right: 4,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            )),
                        Text(
                          '2k',
                          style: TextStyle(color: color),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    right: 4,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.comment_rounded,
                              color: Colors.white,
                            )),
                        Text(
                          '23',
                          style: TextStyle(color: color),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                    child: CircleAvatar(
                  child: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh7ogUYtR66AVscPGclBkMHRagtzJ9D0w04Q&s'),
                )),
                SizedBox(
                  width: width * 0.02,
                ),
                const Text('Angelina'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
