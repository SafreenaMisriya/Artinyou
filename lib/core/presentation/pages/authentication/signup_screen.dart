import 'package:art_inyou/core/data/model/emailmodel.dart';
import 'package:art_inyou/core/presentation/bloc/email/bloc/emailauth_bloc.dart';
import 'package:art_inyou/core/presentation/bloc/google_auth/cubit/googleauth_cubit.dart';
import 'package:art_inyou/core/presentation/pages/bottombar.dart';
import 'package:art_inyou/core/presentation/pages/authentication/login_screen.dart';
import 'package:art_inyou/core/presentation/pages/authentication/signinphone.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/label.dart';
import 'package:art_inyou/core/presentation/widgets/password.dart';
import 'package:art_inyou/core/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpAuth extends StatefulWidget {
  const SignUpAuth({super.key});

  @override
  State<SignUpAuth> createState() => _SignUpAuthState();
}

class _SignUpAuthState extends State<SignUpAuth> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usenamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  @override
  void dispose() {
    usenamecontroller.dispose();
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
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Create your Account',
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 24, 74, 100)),
                  ),
                  Image.asset('assets/image/pot.png', height: height * 0.2),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: BlocConsumer<EmailauthBloc, EmailauthState>(
                  listener: (context, state) {
                    if (state is AuthenticatedState) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomBar(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: usenamecontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              } else if (value.trim().isEmpty) {
                                return 'Username cannot be empty';
                              } else if (!value.contains(RegExp(r'[a-zA-Z]'))) {
                                return 'Username must contain at least one non-numeric character';
                              } else {
                                return null;
                              }
                            },
                            labelText: 'Enter Username',
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: height * 0.03),
                          CustomTextField(
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              } else if (!value.contains('@') ||
                                  !value.contains('.')) {
                                return 'Please enter a valid email';
                              } else {
                                return null;
                              }
                            },
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
                          SizedBox(height: height * 0.03),
                          labelwidget(
                            labelText: 'Sign Up',
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                UserModel user = UserModel(
                                  email: emailcontroller.text,
                                  password: passwordcontroller.text,
                                  username: usenamecontroller.text,
                                );
                                authBloc.add(SignInEvent(user: user));
                              }
                            },
                            child: BlocBuilder<EmailauthBloc, EmailauthState>(
                            builder: (context, state) {
                              if (state is EmailloadingState) {
                                return const CircularProgressIndicator(); 
                              } else {
                                return myfonts('Sign Up');
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
              Column(
                children: [
                  SizedBox(height: height * 0.03),
                  GestureDetector(
                    child: Container(
                      height: height * 0.07,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.phone,
                              size:25,
                              color: Colors.grey,
                            ),
                            SizedBox(width: width * 0.04),
                            const Text(
                              'SignIn using PhoneNumber',
                              style: MyFonts.boldTextStyle
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SigninPhoneScreen()));
                    },
                  ),
                  SizedBox(height: height * 0.03),
                  BlocConsumer<GoogleauthCubit, GoogleauthState>(
                    listener: (context, state) {
                      if (state is GoogleauthsuccessState) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BottomBar()),
                        );
                      }
                    },
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          if ((state is GoogleauthLoadingState)) {
                            null;
                          } else {
                            context.read<GoogleauthCubit>().signin();
                          }
                        },
                        child: state is GoogleauthLoadingState
                            ? const CircularProgressIndicator()
                            : Container(
                                height: height * 0.07,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/image/google.png',
                                         height: height*0.04,
                                  width: width *0.05,
                                      ),
                                      SizedBox(width: width * 0.04),
                                      const Text(
                                        'Continue with Google',
                                        style: MyFonts.boldTextStyle
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                  SizedBox(height: height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account ?',
                          style: MyFonts.normalTextStyle),
                      SizedBox(width: width * 0.02),
                      GestureDetector(
                        child: const Text('Login',
                            style: MyFonts.headingTextStyle),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen())),
                      )
                    ],
                  ),
                   SizedBox(height: height * 0.03),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
