// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:art_inyou/core/data/model/addressmodel.dart';
import 'package:art_inyou/core/domain/address_fetching.dart';
import 'package:art_inyou/core/presentation/bloc/bloc/hardcopy_bloc.dart';
import 'package:art_inyou/core/presentation/pages/payment/payment_screen.dart';
import 'package:art_inyou/core/presentation/pages/payment/success_screen.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:art_inyou/core/presentation/widgets/address_textform.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HardcopyPaymentSteps extends StatefulWidget {
  final String price;
  final String postid;
  final String name;
  final String product;
  const HardcopyPaymentSteps({super.key, required this.price, required this.postid,required this.name,required this.product});

  @override
  State<HardcopyPaymentSteps> createState() => _HardcopyPaymentStepsState();
}

class _HardcopyPaymentStepsState extends State<HardcopyPaymentSteps> {
  TextEditingController namecontroller = TextEditingController();

  TextEditingController phonecontroller = TextEditingController();

  TextEditingController housecontroller = TextEditingController();

  TextEditingController statecontroller = TextEditingController();

  TextEditingController citycontroller = TextEditingController();

  TextEditingController pincodecontroller = TextEditingController();

  late HardcopyBloc bloc;

  bool edit = true;
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String currentuserId = currentUser?.uid ?? '';
    final hardcopBloc = BlocProvider.of<HardcopyBloc>(context);
    double height = Responsive.screenHeight(context);
    double width = Responsive.screenWidth(context);
    return BlocProvider<HardcopyBloc>(
        create: (context) => HardcopyBloc(),
        child: SafeArea(
          child: Scaffold(
            body: BlocBuilder<HardcopyBloc, HardcopyState>(
              builder: (context, state) {
                if (state.completed) {
                  return const SuccessScreen();
                } else {
                  return SingleChildScrollView(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme:
                              const ColorScheme.light(primary: Colors.green)),
                      child: Stepper(
                        type: StepperType.vertical,
                        steps: getSteps(state.currentStep, height, width, state,
                            widget.price, widget.postid, currentuserId,PaymentService(context),widget.name,widget.product),
                        currentStep: state.currentStep,
                        onStepContinue: () async {
                          if (state.currentStep == 0) {
                            AddressModel data = AddressModel(
                                name: namecontroller.text,
                                phone: phonecontroller.text,
                                price: widget.price,
                                house: housecontroller.text,
                                state: statecontroller.text,
                                city: citycontroller.text,
                                pincode: pincodecontroller.text,
                                postid: widget.postid);
                            AddressModel? addressData =
                                await getAddress(currentuserId);
                            if (edit) {
                              hardcopBloc.add(AddressEvent(
                                  addressModel: data, userid: currentuserId));
                            } else {
                              if (addressData != null) {
                                hardcopBloc.add(UpdateaddressEvent(
                                  addressModel: data,
                                  userid: currentuserId,
                                  id: addressData.id,
                                ));
                              }
                            }
                          }
                          context
                              .read<HardcopyBloc>()
                              .add(NextStephardcopyEvent());
                        },
                        onStepCancel: () async {
                          if (state.currentStep == 1) {
                            AddressModel? addressData =
                                await getAddress(currentuserId);
                            if (addressData != null) {
                              edit = true;
                              namecontroller.text = addressData.name;
                              phonecontroller.text = addressData.phone;
                              housecontroller.text = addressData.house;
                              statecontroller.text = addressData.state;
                              citycontroller.text = addressData.city;
                              pincodecontroller.text = addressData.pincode;
                              hardcopBloc.add(UpdateaddressEvent(
                                  addressModel: addressData,
                                  userid: currentuserId,
                                  id: addressData.id));
                            }
                          }
                          context
                              .read<HardcopyBloc>()
                              .add(PreviousStephardcopyEvent());
                        },
                        onStepTapped: (value) => context
                            .read<HardcopyBloc>()
                            .add(GoToStephardcopyEvent(value)),
                        controlsBuilder: (context, details) {
                          final lastStep = state.currentStep ==
                              getSteps(state.currentStep, height, width, state,
                                          widget.price, widget.postid, currentuserId,PaymentService(context),widget.name,widget.product)
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
                    ),
                  );
                }
              },
            ),
          ),
        ));
  }

  List<Step> getSteps(
          int currentStep,
          double height,
          double width,
          HardcopyState state,
          String price,
          String postid,
          String currentuserId,
          PaymentService pay,
          String name,
          String product) =>
      [
        Step(
            title: const Text('Address'),
            content: Column(
              children: [
                AddressTextform(
                    keyboardType: TextInputType.text,
                    controller: namecontroller,
                    labelText: 'Full Name'),
                SizedBox(
                  height: height * 0.03,
                ),
                AddressTextform(
                    keyboardType: TextInputType.phone,
                    controller: phonecontroller,
                    labelText: 'Phone Number'),
                SizedBox(
                  height: height * 0.03,
                ),
                AddressTextform(
                    keyboardType: TextInputType.multiline,
                    controller: housecontroller,
                    labelText: 'House No.,Building Name.,Area'),
                SizedBox(
                  height: height * 0.03,
                ),
                Row(
                  children: [
                    SizedBox(
                        height: height * 0.1,
                        width: width * 0.3,
                        child: AddressTextform(
                            controller: statecontroller, labelText: 'State')),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    SizedBox(
                        height: height * 0.1,
                        width: width * 0.3,
                        child: AddressTextform(
                            controller: citycontroller, labelText: 'City')),
                  ],
                ),
                AddressTextform(
                    keyboardType: TextInputType.number,
                    controller: pincodecontroller,
                    labelText: 'Pincode'),
              ],
            ),
            isActive: currentStep >= 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed),
        Step(
            title: const Text('Order Summary'),
            content: BlocBuilder<HardcopyBloc, HardcopyState>(
              builder: (context, state) {
                return FutureBuilder(
                    future: getAddress(currentuserId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text('No address found'));
                      } else {
                        AddressModel addressData = snapshot.data!;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deliver to :',
                              style: MyFonts.headingTextStyle,
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Text(
                              addressData.name,
                              style: MyFonts.bodyTextStyle,
                            ),
                            Text(
                              addressData.phone,
                              style: MyFonts.bodyTextStyle,
                            ),
                            Text(
                              addressData.house,
                              style: MyFonts.bodyTextStyle,
                            ),
                            Text(
                              addressData.state,
                              style: MyFonts.bodyTextStyle,
                            ),
                            Text(
                              addressData.city,
                              style: MyFonts.bodyTextStyle,
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            Text(
                              addressData.pincode,
                              style: MyFonts.bodyTextStyle,
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            const Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                'Price Details :',
                                style: MyFonts.headingTextStyle,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Price',
                                  style: MyFonts.bodyTextStyle,
                                ),
                                Text(
                                  '₹${addressData.price}',
                                  style: MyFonts.bodyTextStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Charge',
                                  style: MyFonts.bodyTextStyle,
                                ),
                                Text(
                                  'FREE Delivery',
                                  style: MyFonts.bodyTextStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Divider(
                              color: greycolor,
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: MyFonts.boldTextStyle,
                                ),
                                Text(
                                  '₹${addressData.price}',
                                  style: MyFonts.boldTextStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Divider(
                              color: greycolor,
                            ),
                          ],
                        );
                      }
                    });
              },
            ),
            isActive: currentStep >= 1,
            state: currentStep > 0 ? StepState.complete : StepState.indexed),
        Step(
            title: const Text('Payment'),
            content: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount',style: MyFonts.boldTextStyle,),
                    Text('₹$price',style: MyFonts.boldTextStyle,),
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
                    decoration: BoxDecoration(border: Border.all(color: Colors.green),borderRadius: BorderRadius.circular(10)),
                    height: height*0.07,
                    width: width *0.8,
                    child:  Row(
                      children: [
                        const Icon(Icons.wallet),
                         SizedBox(
                            width: width * 0.03,
                            ),
                        const Text('Wallets',style: MyFonts.bodyTextStyle,),
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
                    decoration: BoxDecoration(border: Border.all(color: Colors.green,),borderRadius: BorderRadius.circular(10)),
                    height: height*0.07,
                    width: width *0.8,
                    child:  Row(
                      children: [
                        const Icon(Icons.currency_rupee_rounded),
                         SizedBox(
                            width: width * 0.03,
                            ),
                        const Text('Net Banking',style: MyFonts.bodyTextStyle,),
                      ],
                    ),
                  ),
                  onTap: (){
                 int    amount = int.parse(price);
                    pay.openCheckout(amount,name,product);
                  }
                ),
 
              ],
            ),
            isActive: currentStep >= 2 ),
      ];
}
