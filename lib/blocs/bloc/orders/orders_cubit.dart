import 'package:art_inyou/models/model/paymentmodel.dart';
import 'package:art_inyou/repositories/payment/payment_repository.dart';
import 'package:art_inyou/repositories/buyandsell/buy_product_fetching.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'orders_state.dart';
PaymentRepo paymentRepo=PaymentRepo();
class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());
   Future<void> loadOrders(String userId) async {
    emit(OrderLoading());
    try {
      final orders = await getbuyproducts(userId);
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(const OrderError('Failed to load orders'));
    }
  }

  Future<void> cancelOrder(String userId, String paymentId) async {
    try {
      await paymentRepo.cancelOrder(userId, paymentId);
      final orders = await getbuyproducts(userId);
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(const OrderError('Failed to cancel order'));
    }
  }
}
