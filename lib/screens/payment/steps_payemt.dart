import 'package:art_inyou/blocs/softcopy/softcopy_bloc.dart';
import 'package:art_inyou/screens/payment/alert.dart';
import 'package:art_inyou/screens/payment/payment_screen.dart';
import 'package:art_inyou/screens/payment/success_screen.dart';
import 'package:art_inyou/utils/fonts/font.dart';
import 'package:art_inyou/utils/mediaquery/sizeof_screen.dart';
import 'package:art_inyou/utils/snakbar/snakbar.dart';
import 'package:art_inyou/widgets/appbar/customappbar.dart';
import 'package:art_inyou/widgets/image_handling/carosel.dart';
import 'package:art_inyou/widgets/label/label.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

class SoftCopyPayment extends StatelessWidget {
  final String price;
  final String postid;
  final String username;
  final String product;
  final String userid;
  final List<String>? imagePathList;
  final String? imageurl;
  const SoftCopyPayment(
      {super.key,
      required this.price,
      required this.postid,
      required this.username,
      required this.userid,
      required this.product,
      this.imageurl,
      this.imagePathList});

  @override
  Widget build(BuildContext context) {
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return BlocProvider(
      create: (context) => SoftcopyBloc(),
      child: Builder(
        builder: (context) {
          final PaymentService paymentService = PaymentService(context,
              price: price, postid: postid, userid: userid, hardcopy: '');
          return SafeArea(
            child: Scaffold(
              appBar: customAppbartop(context, 'Order'),
              body: BlocBuilder<SoftcopyBloc, SoftcopyState>(
                builder: (context, state) {
                  if (state.completed) {
                    return const SuccessScreen(
                        text: 'ThankYou For Downloading !');
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
                            imagePathList,
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
                                          imagePathList,
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
                                          child: const Text('Previous'))),
                                if (!lastStep) ...[
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                      child: ElevatedButton(
                                          onPressed: details.onStepContinue,
                                          child: const Text('Next'))),
                                ]
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
          final List<String>? imagePathList,
          PaymentService pay,
          SoftcopyState state,
          String name,
          String product,
          String? imageurl,
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
                          border: Border.all(
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      height: height * 0.07,
                      width: width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                    ),
                    onTap: () {
                      int amount = int.parse(price);
                      pay.openCheckout(amount, name, product);
                    }),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.account_balance_wallet),
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
                  ),
                  onTap: () => handlePayment(
                      context, price, postid, name, product, pay, userid),
                ),
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
                  child: imagePathList != null
                      ? CaroselScreen(
                          screenHeight: height * 0.3,
                          itemCount: imagePathList.length,
                          imageUrlList: imagePathList,
                        )
                      : CachedNetworkImage(
                          imageUrl: imageurl!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              BlocBuilder<SoftcopyBloc, SoftcopyState>(
                builder: (context, state) {
                  return labelwidget(
                      labelText: 'Dowload Now',
                      onTap: () {
                        final dowload = MediaDownload();
                        if (state.paymentCompleted) {
                          imagePathList != null
                              ? dowload.downloadMedia(
                                  context, imagePathList.toString())
                              : dowload.downloadMedia(context, imageurl!);
                          context
                              .read<SoftcopyBloc>()
                              .add(DownloadSuccessEvent());
                        } else {
                          snakbarDeleteMessage(context,
                              'Please Pay the amount and Download Now');
                        }
                      });
                },
              )
            ],
          ),
          isActive: currentStep >= 1,
        ),
      ];
}
