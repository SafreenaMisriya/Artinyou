// ignore_for_file: must_be_immutable

import 'package:art_inyou/blocs/email/bloc/emailauth_bloc.dart';
import 'package:art_inyou/blocs/google_auth/cubit/googleauth_cubit.dart';
import 'package:art_inyou/screens/authentication/resetpassword_screen.dart';
import 'package:art_inyou/screens/authentication/signup_screen.dart';
import 'package:art_inyou/screens/bottombar/bottombar.dart';
import 'package:art_inyou/screens/account/editprofile_screen.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/widgets/label/label.dart';
import 'package:art_inyou/services/password.dart';
import 'package:art_inyou/utils/textformfields/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    final authBloc = BlocProvider.of<EmailauthBloc>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () =>FocusScope.of(context).unfocus(), 
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/image/welcome.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocConsumer<EmailauthBloc, EmailauthState>(
                  listener: (context, state) {
                    if (state is AuthenticatedState) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    }else if(state is AuthenticatedloginErrorState){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text('Please Provide Valide Email or Password'),backgroundColor: redcolor,),
                        );
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          CustomTextField(
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                          validator: (value) => validateEmail(value),
                            labelText: 'Enter Email',
                          ),
                          SizedBox(height: height * 0.03),
                          CustomTextField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordcontroller,
                            validator: (value) => validatePassword(value),
                            labelText: 'Enter Password',
                            obscureText: true,
                          ),
                          SizedBox(height: height * 0.02),
                          GestureDetector(
                            child: const Padding(
                              padding: EdgeInsets.only(right: 190),
                              child: Text(
                                'forgotten password ?',
                                style: MyFonts.bodyTextStyle,
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetpasswordScreen())),
                          ),
                          SizedBox(height: height * 0.03),
                          labelwidget(
                            labelText: 'LogIn',
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                authBloc.add(LoginEvent(
                                    email: emailcontroller.text.trim(),
                                    password: passwordcontroller.text.trim()));
                              }
                            },
                            child: BlocBuilder<EmailauthBloc, EmailauthState>(
                              builder: (context, state) {
                                if (state is EmailloadingState) {
                                  return SpinKitFadingCircle(color: redcolor,);
                                } else {
                                  return myfonts('LogIn');
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: height * 0.02),
              BlocConsumer<GoogleauthCubit, GoogleauthState>(
                listener: (context, state) {
                  if (state is GoogleauthsuccessState) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>const BottomBar()),
                    );
                  }
                },
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      if ((state is GoogleauthLoadingState)) {
                        null;
                      } else {
                        context.read<GoogleauthCubit>().login();
                      }
                    },
                    child: state is GoogleauthLoadingState
                        ? SpinKitFadingCircle(color: redcolor,)
                        : Container(
                            height: height * 0.07,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/image/google.png',
                                    height: height * 0.04,
                                    width: width * 0.05,
                                  ),
                                  SizedBox(width: width * 0.04),
                                  const Text('Continue with Google',
                                      style: MyFonts.boldTextStyle),
                                ],
                              ),
                            ),
                          ),
                  );
                },
              ),
              SizedBox(height: height * 0.02),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account ?",
                        style: MyFonts.normalTextStyle),
                    SizedBox(width: width * 0.02),
                    const Text(
                      'Sign Up',
                      style: MyFonts.headingTextStyle,
                    ),
                  ],
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignUpAuth())),
              )
            ],
          ),
        ),
      ),
    );
  }
}
