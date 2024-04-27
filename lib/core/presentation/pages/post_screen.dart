import 'package:art_inyou/core/data/model/postmodel.dart';
import 'package:art_inyou/core/presentation/bloc/post/bloc/post_bloc.dart';
import 'package:art_inyou/core/presentation/pages/bottombar.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/alertdialog.dart';
import 'package:art_inyou/core/presentation/widgets/carosel.dart';
import 'package:art_inyou/core/presentation/widgets/dropdown.dart';
import 'package:art_inyou/core/presentation/widgets/imageupload.dart';
import 'package:art_inyou/core/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    super.key,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController aboutcontroller = TextEditingController();
  String selectedCategory = "Creative";
  final ImageuploadScreen imageUploadScreen = const ImageuploadScreen();
  @override
  void dispose() {
    titlecontroller.dispose();
    pricecontroller.dispose();
    aboutcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    final postBloc = BlocProvider.of<PostBloc>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {},
          builder: (context, state) {
            List<String> uploadedImageUrls = [];
            if (state is ImageUploaded) {
              uploadedImageUrls = state.imageUrls;
            } else if (state is ImageUploading) {
              return Center(
                  child: CircularProgressIndicator(
                color: redcolor,
              ));
            }
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const BottomBar()));
                            },
                            icon: Icon(
                              Icons.close,
                              size: width * 0.07,
                            )),
                        const Text(
                          'New Post',
                          style: MyFonts.headingTextStyle,
                        ),
                        TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                PostModel postModel = PostModel(
                                  imageUrl: uploadedImageUrls.join(','),
                                  title: titlecontroller.text,
                                  price: pricecontroller.text,
                                  category: selectedCategory,
                                  about: aboutcontroller.text,
                                );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmationDialog(
                                      message:
                                          'Are you sure you want to post this ?',
                                      onYesPressed: () {
                                        postBloc
                                            .add(PostAddEvent(post: postModel));
                                      },
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text(
                              'Post',
                              style: MyFonts.headingTextStyle,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    uploadedImageUrls.isNotEmpty
                        ? uploadedImageUrls.length > 1
                            ? CaroselScreen(
                                itemCount: uploadedImageUrls.length,
                                imageUrlList: uploadedImageUrls)
                            : SizedBox(
                                height: height * 0.3,
                                width: width * 0.5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    uploadedImageUrls.first,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                        : const Text(
                            'No image selected',
                            style: MyFonts.boldTextStyle,
                          ),
                    IconButton(
                      onPressed: () {
                        context.read<PostBloc>().add(SelectImageEvent());
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                        controller: titlecontroller,
                        labelText: 'Title',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter  title';
                          }
                          return null;
                        }),
                    SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width * 0.5,
                          child: CustomTextField(
                              controller: pricecontroller,
                              labelText: '₹ Price',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter  Price';
                                }
                                return null;
                              }),
                        ),
                        DropDowm(
                          onChanged: (value) {
                            selectedCategory = value;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                        maxLines: 3,
                        controller: aboutcontroller,
                        labelText: 'About',
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter about';
                          }
                          return null;
                        }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
