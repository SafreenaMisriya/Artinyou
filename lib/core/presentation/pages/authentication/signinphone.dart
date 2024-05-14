import 'package:art_inyou/core/presentation/bloc/otpauth_bloc/bloc/otpauth_bloc_bloc.dart';
import 'package:art_inyou/core/presentation/pages/authentication/otp_screen.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/label.dart';
import 'package:art_inyou/core/presentation/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninPhoneScreen extends StatefulWidget {
  const SigninPhoneScreen({super.key});

  @override
  State<SigninPhoneScreen> createState() => _SigninPhoneScreenState();
}

class _SigninPhoneScreenState extends State<SigninPhoneScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  OtpauthBloc authBloc = OtpauthBloc(OtpauthBlocInitial());
  String countryCode = "+91";

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/image/verify.png'),
                SizedBox(width: width * 0.04),
                Container(
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.2,
                        child: TextFormField(
                          initialValue: countryCode,
                          enabled: false,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            fillColor: color,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      Expanded(
                        child: CustomTextField(
                          maxLines: 1,
                          controller: phoneNumberController,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          labelText: 'Enter your Phone',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter PhoneNumber';
                            } else if (value.length < 10) {
                              return 'Phone number must be 10 digits';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.04),
                BlocConsumer<OtpauthBloc, OtpauthBlocState>(
                  bloc: authBloc,
                  listener: (context, state) {
                    if (state is OtpsentsuccessState) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: authBloc,
                            child: const OtpScreen(),
                          ),
                        ),
                      );
                    } else if (state is OtpAuthErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Enter Valid Phone Number'),
                          backgroundColor: redcolor,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return labelwidget(
                      labelText: 'Sign Up',
                      onTap: () {
                        final phoneNumber =
                            "$countryCode${phoneNumberController.text}";
                        if (formKey.currentState!.validate()) {
                          authBloc
                              .add(SendOtpToPhoneEvent(number: phoneNumber));
                        }
                      },
                      child: BlocBuilder<OtpauthBloc, OtpauthBlocState>(
                        builder: (context, state) {
                          if (state is OtpAuthloadingState) {
                            return const CircularProgressIndicator();
                          } else {
                            return myfonts('Sign Up');
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
