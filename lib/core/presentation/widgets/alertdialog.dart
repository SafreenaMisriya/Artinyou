import 'package:art_inyou/core/presentation/pages/bottombar/bottombar.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:flutter/material.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final Function onYesPressed;

  const ConfirmationDialog({
    super.key,
    required this.message,
    required this.onYesPressed,
    
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color,
      content: Text(
        message,
        style: MyFonts.boldTextStyle,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'NO',
                style:   TextStyle(color: Color.fromARGB(255, 52, 14, 140)),
              ),
            ),
            Text('|',style: TextStyle(color: redcolor),),
            TextButton(
              onPressed: () {
                onYesPressed();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const BottomBar()));
              },
              child: const Text('YES', style: TextStyle(color: Color.fromARGB(255, 14, 140, 19))),
            ),
          ],
        )
      ],
    );
  }
}
