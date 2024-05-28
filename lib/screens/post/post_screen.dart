import 'package:art_inyou/models/model/postmodel.dart';
import 'package:art_inyou/blocs/post/bloc/post_bloc.dart';
import 'package:art_inyou/screens/bottombar/bottombar.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/widgets/alertdialog/alertdialog.dart';
import 'package:art_inyou/widgets/image_handling/carosel.dart';
import 'package:art_inyou/widgets/dropdown/dropdown.dart';
import 'package:art_inyou/utils/textformfields/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostScreen extends StatefulWidget {
  final PostModel? edit;
 final  String?  userId;
 final String? postid;

  const PostScreen({super.key, this.edit, this.userId,this.postid});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController softpricecontroller = TextEditingController();
  TextEditingController hardpricecontroller = TextEditingController();
  TextEditingController aboutcontroller = TextEditingController();
  String selectedCategory = "Creative";
  List<String> uploadedImageUrls = [];
  bool isdEdit = false;

  @override
  void initState() {
    final edit = widget.edit;

    if (edit != null) {
      isdEdit = true;
      titlecontroller.text = edit.title;
      aboutcontroller.text = edit.about;
      softpricecontroller.text = edit.softprice;
      hardpricecontroller.text = edit.hardprice;
      selectedCategory = edit.category; 
      uploadedImageUrls = edit.imageUrl.split(',');
    }
    super.initState();
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    softpricecontroller.dispose();
    hardpricecontroller.dispose();
    aboutcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    final postBloc = BlocProvider.of<PostBloc>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocConsumer<PostBloc, PostState>(
            listener: (context, state) {},
            builder: (context, state) {
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
                          Text(
                            isdEdit ? "Update Post" : 'New Post',
                            style: MyFonts.headingTextStyle,
                          ),
                          TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  PostModel postModel = PostModel(
                                    userid: widget.userId ?? ' id'  , 
                                    imageUrl: uploadedImageUrls.join(','),
                                    title: titlecontroller.text,
                                    softprice: softpricecontroller.text,
                                    hardprice: hardpricecontroller.text,
                                    category: selectedCategory,
                                    about: aboutcontroller.text,
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ConfirmationDialog(
                                        message: isdEdit
                                            ? 'Are you sure you want to update this ?'
                                            : 'Are you sure you want to post this ?',
                                        onYesPressed: () {
                                          isdEdit
                                              ? postBloc.add(PostEditEvent(
                                                  post: postModel,
                                                  postid: widget.postid!))
                                              : postBloc.add(
                                                  PostAddEvent(post: postModel));
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text(
                                isdEdit ? 'Update' : 'Post',
                                style: MyFonts.headingTextStyle,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                       uploadedImageUrls.isNotEmpty
                       ? Container()
                      : IconButton(
                        onPressed: () {
                          context.read<PostBloc>().add(SelectImageEvent());
                        },
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.red,
                          size: 50,
                        ),
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
                                    child: Placeholder(
                                      child: Image.network(
                                        uploadedImageUrls[0],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                          : const Text(
                              'No image selected',
                              style: MyFonts.boldTextStyle,
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
                          
                          DropDowm(
                            onChanged: (value) {
                              selectedCategory = value;
                            },
                          ),
                          SizedBox(height: height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                                width: width * 0.45,
                                child: CustomTextField(
                                    controller: softpricecontroller,
                                    labelText: '₹ Soft  Copy  Price',
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter  softcopy Price';
                                      }
                                      return null;
                                    }),
                              ),
                               SizedBox(
                                width: width * 0.45,
                                child: CustomTextField(
                                    controller: hardpricecontroller,
                                    labelText: '₹ Hard  Copy  Price',
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter  hard copy Price';
                                      }
                                      return null;
                                    }),
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
      ),
    );
  }
}
