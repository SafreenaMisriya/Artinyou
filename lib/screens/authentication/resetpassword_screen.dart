// ignore_for_file: must_be_immutable

import 'package:art_inyou/blocs/email/bloc/emailauth_bloc.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/widgets/label/label.dart';
import 'package:art_inyou/services/password.dart';
import 'package:art_inyou/utils/textformfields/textfield.dart';
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
                          validator: (value) => validateEmail(value),
                          labelText: 'Enter Email',
                        ),
                        SizedBox(height: height * 0.06),
                        labelwidget(
                          labelText: 'Reset PassWord',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              authBloc.add(ForgotpasswordEvent(email: emailcontroller.text));
                              Navigator.pop(context);
                            }
                          },
                        
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
