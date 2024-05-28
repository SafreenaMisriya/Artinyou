import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:art_inyou/blocs/bloc/toggle/toggle_cubit.dart';
import 'package:art_inyou/screens/payment/hardcopy_payment.dart';
import 'package:art_inyou/screens/payment/steps_payemt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void showCustomDialog(
    BuildContext context,
    String softprice,
    String postid,
    String username,
    String product,
    String imageurl,
    String hardprice,
    String userid,
    double height) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        content: SizedBox(
          height: height * 0.3,
          child: BlocBuilder<ToggleCubit, bool>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("""
      Do you  want Soft Copy or  
             Hard  Copy?

      Please Select your Preference !""",
                      style: GoogleFonts.adamina(
                          fontSize: 14, color: Colors.black)),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: AnimatedToggleSwitch<bool>.size(
                      current: state,
                      values: const [false, true],
                      iconOpacity: 0.2,
                      indicatorSize: const Size.fromWidth(100),
                      customIconBuilder: (context, local, global) => Text(
                        local.value ? 'Soft Copy' : 'Hard Copy',
                        style: TextStyle(
                            color: Color.lerp(Colors.black, Colors.white,
                                local.animationValue)),
                      ),
                      borderWidth: 4.0,
                      iconAnimationType: AnimationType.onHover,
                      style: ToggleStyle(
                          indicatorColor: Colors.teal,
                          borderColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            const BoxShadow(
                              blurRadius: 1,
                            ),
                          ]),
                      selectedIconScale: 1.0,
                      onChanged: (value) {
                        context.read<ToggleCubit>().toggle(value);
                      },
                    ),
                  ),
                  SizedBox(height: height *0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'CANCEL',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          bool selection = context.read<ToggleCubit>().state;
                          selection
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SoftCopyPayment(
                                            price: softprice,
                                            postid: postid,
                                            username: username,
                                            product: product,
                                            imageurl: imageurl,
                                            userid: userid,
                                          )))
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HardcopyPaymentSteps(
                                            price: hardprice,
                                            postid: postid,
                                            name: username,
                                            product: product,
                                            userid: userid,
                                          )));
                        },
                        child: const Text(
                          'CONFIRM',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
