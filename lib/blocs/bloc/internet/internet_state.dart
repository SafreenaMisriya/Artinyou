part of 'internet_bloc.dart';

@immutable
sealed class InternetState {}

final class InternetInitial extends InternetState {}
class InternetConnectedState extends InternetState {}

class InternetDisconnectedState extends InternetState {}