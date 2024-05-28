part of 'orders_cubit.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

final class OrdersInitial extends OrdersState {}

class OrderLoading extends OrdersState {}

class OrderLoaded extends OrdersState {
  final List<PaymentModel> orders;

  const OrderLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderError extends OrdersState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}
