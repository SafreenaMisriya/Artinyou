import 'package:art_inyou/core/presentation/bloc/softcopy/softcopy_bloc.dart';
import 'package:art_inyou/core/presentation/pages/payment/payment_screen.dart';
import 'package:art_inyou/core/presentation/pages/payment/success_screen.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/utils/snakbar.dart';
import 'package:art_inyou/core/presentation/widgets/label.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

class SoftCopyPayment extends StatelessWidget {
  final String price;
  final String postid;
  final String username;
  final String product;
  final String imageurl;
  const SoftCopyPayment(
      {super.key,
      required this.price,
      required this.postid,
      required this.username,
      required this.product,
      required this.imageurl});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return BlocProvider(
      create: (context) => SoftcopyBloc(),
      child: Builder(
        builder: (context) {
          final PaymentService paymentService = PaymentService(context);
          return SafeArea(
            child: Scaffold(
              body: BlocBuilder<SoftcopyBloc, SoftcopyState>(
                builder: (context, state) {
                  if (state.completed) {
                    return const SuccessScreen();
                  } else {
                    return Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme:
                              const ColorScheme.light(primary: Colors.green)),
                      child: Stepper(
                        type: StepperType.vertical,
                        steps: getSteps(
                            state.currentStep,
                            height,
                            width,
                            price,
                            paymentService,
                            state,
                            username,
                            product,
                            imageurl,
                            context),
                        currentStep: state.currentStep,
                        onStepContinue: () {
                          context.read<SoftcopyBloc>().add(NextStepEvent());
                        },
                        onStepCancel: () {
                          context.read<SoftcopyBloc>().add(PreviousStepEvent());
                        },
                        onStepTapped: (value) => context
                            .read<SoftcopyBloc>()
                            .add(GoToStepEvent(value)),
                        controlsBuilder: (context, details) {
                          final lastStep = state.currentStep ==
                              getSteps(
                                          state.currentStep,
                                          height,
                                          width,
                                          price,
                                          paymentService,
                                          state,
                                          username,
                                          product,
                                          imageurl,
                                          context)
                                      .length -
                                  1;
                          return Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Row(
                              children: [
                                if (state.currentStep != 0)
                                  Expanded(
                                      child: ElevatedButton(
                                          onPressed: details.onStepCancel,
                                          child: const Text('Cancel'))),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                    child: ElevatedButton(
                                        onPressed: details.onStepContinue,
                                        child: Text(
                                            lastStep ? 'Confirm' : 'Next'))),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  List<Step> getSteps(
          int currentStep,
          double height,
          double width,
          String price,
          PaymentService pay,
          SoftcopyState state,
          String name,
          String product,
          String imageurl,
          BuildContext context) =>
      [
        Step(
            title: const Text('Payment'),
            content: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: MyFonts.boldTextStyle,
                    ),
                    Text(
                      '₹$price',
                      style: MyFonts.boldTextStyle,
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                const Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    'Payments',
                    style: MyFonts.headingTextStyle,
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(10)),
                    height: height * 0.07,
                    width: width * 0.8,
                    child: Row(
                      children: [
                        const Icon(Icons.wallet),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        const Text(
                          'Wallets',
                          style: MyFonts.bodyTextStyle,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {},
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      height: height * 0.07,
                      width: width * 0.8,
                      child: Row(
                        children: [
                          const Icon(Icons.currency_rupee_rounded),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          const Text(
                            'Net Banking',
                            style: MyFonts.bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      int amount = int.parse(price);
                      pay.openCheckout(amount, name, product);
                      context.read<SoftcopyBloc>().add(PaymentSuccessEvent());
                    }),
              ],
            ),
            isActive: currentStep >= 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed),
        Step(
          title: const Text('Download'),
          content: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: height * 0.4,
                  width: width * 0.8,
                  child: CachedNetworkImage(
                    imageUrl: imageurl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              labelwidget(
                  labelText: 'Dowload Now',
                  onTap: () async {
                    final dowload = MediaDownload();
                    state.paymentCompleted
                        ? dowload.downloadMedia(context, imageurl)
                        : snakbarDeleteMessage(
                            context, 'Please Pay the amount and Download Now');
                  })
            ],
          ),
          isActive: currentStep >= 1 && state.paymentCompleted,
        ),
      ];
}
