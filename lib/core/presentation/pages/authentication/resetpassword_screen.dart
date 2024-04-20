// ignore_for_file: must_be_immutable

import 'package:art_inyou/core/presentation/bloc/email/bloc/emailauth_bloc.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/label.dart';
import 'package:art_inyou/core/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetpasswordScreen extends StatefulWidget {
  const ResetpasswordScreen({super.key});

  @override
  State<ResetpasswordScreen> createState() => _ResetpasswordScreenState();
}

class _ResetpasswordScreenState extends State<ResetpasswordScreen> {
  TextEditingController emailcontroller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    final authBloc = BlocProvider.of<EmailauthBloc>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/image/reset.png',
              height: height * 0.4,
            ),
            const Text(
              'Reset Password',
              style: MyFonts.headingTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocConsumer<EmailauthBloc, EmailauthState>(
                listener: (context, state) {},
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
                        SizedBox(height: height * 0.02),
                        SizedBox(height: height * 0.04),
                        labelwidget(
                          labelText: 'LogIn',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              authBloc.add(ForgotpasswordEvent(email: emailcontroller.text));
                              Navigator.pop(context);
                            }
                          },
                          child: BlocBuilder<EmailauthBloc, EmailauthState>(
                            builder: (context, state) {
                              if (state is EmailloadingState) {
                                return const CircularProgressIndicator();
                              } else {
                                return myfonts('Reset PassWord');
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
          ],
        ),
      ),
    );
  }
}
