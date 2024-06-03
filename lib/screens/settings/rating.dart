import 'package:art_inyou/utils/fonts/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showRating(
    BuildContext context, double height, double width) async {
  double stars = 4;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/image/logo7.png'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    stars = rating;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      side: BorderSide(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                    child: const Text(
                      'Close',
                      style: MyFonts.bodyTextStyle,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (stars > 3) {
                        final Uri url = Uri.parse('https://www.amazon.com/dp/B0D5LV6D99/ref=apps_sf_sta');
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Center(
                                    child: Text(
                                  '🥺',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'We are sorry to hear that!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Would you like to give us feedback ?',
                                    style: MyFonts.bodyTextStyle,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor),
                                        ),
                                        child: const Text(
                                          'No',
                                          style: MyFonts.bodyTextStyle,
                                        )),
                                    OutlinedButton(
                                        onPressed: () async {
                                          final Uri uri = Uri(
                                              scheme: 'mailto',
                                              path:
                                                  'safreenamisriya02@gmail.com');
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(uri);
                                          }
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          side: const BorderSide(
                                              color: Colors.green),
                                        ),
                                        child: const Text(
                                          'Yes',
                                          style: MyFonts.iconTextStyle,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Continue',
                      style: MyFonts.iconTextStyle,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      });
}
