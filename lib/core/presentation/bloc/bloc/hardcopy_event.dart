part of 'hardcopy_bloc.dart';
@immutable
sealed class HardcopyEvent {}

class NextStephardcopyEvent extends HardcopyEvent{}

class PreviousStephardcopyEvent extends HardcopyEvent {}

class GoToStephardcopyEvent extends HardcopyEvent {
  final int step;

  GoToStephardcopyEvent(this.step);
}
class AddressEvent extends HardcopyEvent{
final AddressModel addressModel;
final String userid;
  AddressEvent({
 required this.addressModel,
 required this.userid,
  });
}
class UpdateaddressEvent extends HardcopyEvent{
final AddressModel addressModel;
final String userid;
final String id;

 UpdateaddressEvent({
 required this.addressModel,
 required this.userid,
 required this.id,
  });
}