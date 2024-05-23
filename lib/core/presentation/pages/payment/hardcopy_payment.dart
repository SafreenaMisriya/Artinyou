// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:art_inyou/core/data/model/addressmodel.dart';
import 'package:art_inyou/core/data/repository/payment_repository.dart';
import 'package:art_inyou/core/domain/address_fetching.dart';
import 'package:art_inyou/core/presentation/bloc/hardcopy/hardcopy_bloc.dart';
import 'package:art_inyou/core/presentation/pages/payment/hardcopy_steps.dart';
import 'package:art_inyou/core/presentation/pages/payment/payment_screen.dart';
import 'package:art_inyou/core/presentation/pages/payment/success_screen.dart';
import 'package:art_inyou/core/presentation/utils/sizeof_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

PaymentRepo repo = PaymentRepo();

class HardcopyPaymentSteps extends StatefulWidget {
  final String price;
  final String postid;
  final String name;
  final String product;
  final String userid;
  const HardcopyPaymentSteps(
      {super.key,
      required this.price,
      required this.postid,
      required this.name,
      required this.product,
      required this.userid});

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
                  return const SuccessScreen(
                      text: 'Order Confirmed Successfully');
                } else {
                  return SingleChildScrollView(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme:
                              const ColorScheme.light(primary: Colors.green)),
                      child: Stepper(
                        type: StepperType.vertical,
                        steps: getSteps(
                            namecontroller,
                            phonecontroller,
                            housecontroller,
                            statecontroller,
                            citycontroller,
                            pincodecontroller,
                            state.currentStep,
                            height,
                            width,
                            state,
                            widget.price,
                            widget.postid,
                            currentuserId,
                            context,
                            PaymentService(context,
                                price: widget.price,
                                postid: widget.postid,
                                userid: widget.userid,
                                hardcopy: 'hardcopy'),
                            widget.name,
                            widget.product),
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
                              getSteps(
                                          namecontroller,
                                          phonecontroller,
                                          housecontroller,
                                          statecontroller,
                                          citycontroller,
                                          pincodecontroller,
                                          state.currentStep,
                                          height,
                                          width,
                                          state,
                                          widget.price,
                                          widget.postid,
                                          currentuserId,
                                          context,
                                          PaymentService(context,
                                              price: widget.price,
                                              postid: widget.postid,
                                              userid: widget.userid,
                                              hardcopy: "hardcopy"),
                                          widget.name,
                                          widget.product)
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
}
