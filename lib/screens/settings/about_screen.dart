import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: color,
            body: SingleChildScrollView(
              child: Column(children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back)),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    const Text(
                      'About Our App',
                      style: MyFonts.headingTextStyle,
                    ),
                    SizedBox(
                      height: height * 0.08,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Welcome to ArtinYou !',
                      style: MyFonts.boldTextStyle,
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        """       ArtinYou is a vibrant social media platform dedicated to artists and art enthusiasts. Whether you're a professional artist, an emerging talent, or someone who simply loves art, ArtinYou is the perfect place for you.
              
              """,
                        style: MyFonts.bodyTextStyle,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'What You Can Do on ArtinYou :',
                          style: MyFonts.boldTextStyle,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          """ 
      *   Showcase Your Art: Post your masterpieces for
          the world tosee. Share your creativity and get
          feedback from a community that appreciates art.


      *   Set Your Price and Sell: As an artist, you can
          set a price foryour artwork and sell it directly 
          through the app. Whether it's a digitalcopy or 
          a physical piece, ArtHub makes it easy to 
          reach buyers.


      *   Buy Art: Discover unique art pieces from 
          talented artists. Purchase soft copies or order 
          hard copies to be delivered to yourdoorstep.


      *   Connect and Chat: Interact with other artists 
          and art lovers.Share your thoughts, ask for advice,
          or just chat about yourfavorite pieces.""",style: MyFonts.bodyTextStyle),
                    )
                  ],
                ),
                      const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Why ArtinYou?',
                          style: MyFonts.boldTextStyle,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("""
        *   Support Artists: By buying art through ArtinYou,
            you directly support artists and their creative
            endeavors.

        *   Community of Art Lovers: Join a passionate
            community where everyone values and
            celebrates art.

        *   Simple and Secure Transactions: Our platform
            ensures that buying and selling art is safe,
            secure, and straightforward.


        Join ArtinYou today and be a part of a thriving art community!""",style: MyFonts.bodyTextStyle,),
                    )
              ]),
            )));
  }
}
