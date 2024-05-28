// ignore_for_file: must_be_immutable
import 'package:art_inyou/screens/account/editprofile_screen.dart';
import 'package:art_inyou/utils/color/colour.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/widgets/label/label.dart';
import 'package:art_inyou/utils/textformfields/pintheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../blocs/otpauth_bloc/bloc/otpauth_bloc_bloc.dart';

class OtpScreen extends StatefulWidget {
 const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
    late OtpauthBloc authBloc;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
@override
  void initState() {
    authBloc = BlocProvider.of<OtpauthBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Image.asset('assets/image/otp.gif'),
              const Text(
                'OTP VERIFICATION',
                style: MyFonts.boldTextStyle,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              const Text('Enter the 6 digit verification code received'),
              SizedBox(
                height: height * 0.04,
              ),
              BlocConsumer<OtpauthBloc, OtpauthBlocState>(
                bloc: authBloc,
                listener: (context, state) {
                  if (state is OtpAuthloadedState) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  } else if (state is OtpAuthErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<OtpauthBloc, OtpauthBlocState>(
                    builder: (context, state) {
                      if (state is OtpsentsuccessState) {
                        return Column(
                          children: [
                            Pinput(
                              length: 6,
                              controller: otpController,
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: defaultPinTheme.copyWith(
                                decoration: defaultPinTheme.decoration?.copyWith(
                                  border: Border.all(color: color),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            labelwidget(labelText: 'Verify', onTap:  () {
                                authBloc.add(VerifySendOtp(verificationId: state.verificationId, otpcode:otpController.text ));
                              }, )
                           
                          ],
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
