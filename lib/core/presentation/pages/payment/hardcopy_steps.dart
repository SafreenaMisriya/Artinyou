import 'package:art_inyou/core/data/model/addressmodel.dart';
import 'package:art_inyou/core/domain/address_fetching.dart';
import 'package:art_inyou/core/presentation/bloc/hardcopy/hardcopy_bloc.dart';
import 'package:art_inyou/core/presentation/pages/payment/alert.dart';
import 'package:art_inyou/core/presentation/pages/payment/payment_screen.dart';
import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:art_inyou/core/presentation/utils/font.dart';
import 'package:art_inyou/core/presentation/widgets/address_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<FormState> formKey = GlobalKey<FormState>();
List<Step> getSteps(
        TextEditingController namecontroller,
        TextEditingController phonecontroller,
        TextEditingController housecontroller,
        TextEditingController statecontroller,
        TextEditingController citycontroller,
        TextEditingController pincodecontroller,
        int currentStep,
        double height,
        double width,
        HardcopyState state,
        String price,
        String postid,
        String currentuserId,
        BuildContext context,
        PaymentService pay,
        String name,
        String product) =>
    [
      Step(
          title: const Text('Address'),
          content: Form(
            key: formKey,
            child: Column(
              children: [
                AddressTextform(
                  keyboardType: TextInputType.text,
                  controller: namecontroller,
                  labelText: 'Full Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                AddressTextform(
                  maxLength: 10,
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  controller: phonecontroller,
                  labelText: 'Phone Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Phone Number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                AddressTextform(
                  keyboardType: TextInputType.multiline,
                  controller: housecontroller,
                  labelText: 'House No.,Building Name.,Area',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter House NO';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Row(
                  children: [
                    SizedBox(
                      height: height * 0.1,
                      width: width * 0.3,
                      child: AddressTextform(
                        controller: statecontroller,
                        labelText: 'State',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter State';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: width * 0.1,
                    ),
                    SizedBox(
                        height: height * 0.1,
                        width: width * 0.3,
                        child: AddressTextform(
                          controller: citycontroller,
                          labelText: 'City',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter City';
                            }
                            return null;
                          },
                        )),
                  ],
                ),
                AddressTextform(
                  maxLength: 6,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  controller: pincodecontroller,
                  labelText: 'Pincode',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Pincode';
                    }
                    return null;
                  },
                ),
              ],
            ),
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
                  context, price, postid, name, product, pay, currentuserId),
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
              onTap: () => handlePayment(
                  context, price, postid, name, product, pay, currentuserId),
            ),
          ],
        ),
        isActive: currentStep >= 2,
      ),
    ];
