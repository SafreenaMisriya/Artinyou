part of 'hardcopy_bloc.dart';

class HardcopyState extends Equatable {
  final int currentStep;
  final bool completed;
  final int totalSteps;
  final String name;
  final String phone;
  final String house;
  final String state;
  final String city;
  final String pincode;

  const HardcopyState({
    required this.currentStep,
    required this.completed,
    required this.totalSteps,
    required this.name,
    required this.phone,
    required this.house,
    required this.state,
    required this.city,
    required this.pincode,
  });

  factory HardcopyState.initial() {
    return const HardcopyState(
      currentStep: 0,
      completed: false,
      totalSteps: 3, 
      name: '',
      phone: '',
      house: '',
      state: '',
      city: '',
      pincode: '',
    );
  }

HardcopyState copyWith({
    int? currentStep,
    bool? completed,
    int? totalSteps,
    String? name,
    String? phone,
    String? house,
    String? state,
    String? city,
    String? pincode,
  }) {
    return HardcopyState(
      currentStep: currentStep ?? this.currentStep,
      completed: completed ?? this.completed,
      totalSteps: totalSteps ?? this.totalSteps,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      house: house?? this.house,
      state: state ?? this.state,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
    );
  }

  @override
  List<Object> get props => [currentStep, completed, totalSteps];
}
