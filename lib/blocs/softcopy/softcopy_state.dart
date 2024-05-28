part of 'softcopy_bloc.dart';


class SoftcopyState extends Equatable {
  final int currentStep;
  final bool completed;
  final int totalSteps;
    final bool paymentCompleted;

  const SoftcopyState({
    required this.currentStep,
    required this.completed,
    required this.totalSteps,
    required this.paymentCompleted,
  });

  factory SoftcopyState.initial() {
    return const SoftcopyState(
      currentStep: 0,
      completed: false,
      totalSteps: 2, 
      paymentCompleted: false,
    );
  }

 SoftcopyState copyWith({
    int? currentStep,
    bool? completed,
    int? totalSteps,
    bool? paymentCompleted,
  }) {
    return SoftcopyState(
      currentStep: currentStep ?? this.currentStep,
      completed: completed ?? this.completed,
      totalSteps: totalSteps ?? this.totalSteps,
      paymentCompleted: paymentCompleted ?? this.paymentCompleted,
    );
  }

  @override
  List<Object> get props => [currentStep, completed, totalSteps];
}
