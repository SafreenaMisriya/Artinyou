part of 'softcopy_bloc.dart';

@immutable
sealed class SoftcopyEvent {}
class NextStepEvent extends SoftcopyEvent {}

class PreviousStepEvent extends SoftcopyEvent {}

class GoToStepEvent extends SoftcopyEvent {
  final int step;

   GoToStepEvent(this.step);
}
class PaymentSuccessEvent extends SoftcopyEvent {}

class PaymentFailureEvent extends SoftcopyEvent {}
class DownloadSuccessEvent extends SoftcopyEvent{}