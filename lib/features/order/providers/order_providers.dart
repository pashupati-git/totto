import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/config/api_client.dart';

import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref)
    {
        return OrderRepository(ref.watch(apiClientProvider));
    }
);

final filteredOrdersProvider = FutureProvider.family.autoDispose<List<Order>, String?>((ref, groupId) {
    final repository = ref.watch(orderRepositoryProvider);
    if (groupId != null && groupId.isNotEmpty) {
        return repository.fetchOrdersForGroup(groupId).then((orders) {
            return orders.where((order) => order.groupId == groupId).toList();
        });
    } else {
        return repository.fetchGeneralOrders();
    }
});

final receivedOrdersProvider = FutureProvider.autoDispose<List<Order>>((ref) {
    final repository = ref.watch(orderRepositoryProvider);
    return repository.fetchReceivedOrders();
});
final myCreatedOrdersProvider = FutureProvider.autoDispose<List<Order>>((ref) {
    final repository = ref.watch(orderRepositoryProvider);
    return repository.fetchMyCreatedOrders();
});

enum OrderPlacementStateValue
{
    initial, loading, success, error
}

enum OrderStatusUpdateStateValue { initial, loading, success, error }

class OrderStatusUpdateState {
    final OrderStatusUpdateStateValue value;
    final String? errorMessage;
    const OrderStatusUpdateState._(this.value, {this.errorMessage});
    const OrderStatusUpdateState.initial() : this._(OrderStatusUpdateStateValue.initial);
    const OrderStatusUpdateState.loading() : this._(OrderStatusUpdateStateValue.loading);
    const OrderStatusUpdateState.success() : this._(OrderStatusUpdateStateValue.success);
    const OrderStatusUpdateState.error(String message)
        : this._(OrderStatusUpdateStateValue.error, errorMessage: message);
}

class OrderStatusUpdater extends StateNotifier<OrderStatusUpdateState> {
    final OrderRepository _repository;
    final Ref _ref;

    OrderStatusUpdater(this._repository, this._ref)
        : super(const OrderStatusUpdateState.initial());

    Future<void> updateStatus({
        required int orderId,
        required String newStatus,
        String? groupId,
    }) async {
        state = const OrderStatusUpdateState.loading();
        try {
            await _repository.updateOrderStatus(orderId: orderId, newStatus: newStatus);

            if (groupId != null) {
                _ref.invalidate(filteredOrdersProvider(groupId));
            }
            _ref.invalidate(filteredOrdersProvider);

            state = const OrderStatusUpdateState.success();
        } catch (e) {
            state = OrderStatusUpdateState.error(e.toString());
        }
    }
}

final orderStatusUpdaterProvider =
StateNotifierProvider<OrderStatusUpdater, OrderStatusUpdateState>((ref) {
    final repository = ref.watch(orderRepositoryProvider);
    return OrderStatusUpdater(repository, ref);
});

class OrderPlacementState
{
    final OrderPlacementStateValue value;
    final String? errorMessage;
    final Order? createdOrder;
    const OrderPlacementState._(this.value, {this.errorMessage, this.createdOrder});
    const OrderPlacementState.initial() :
        this._(OrderPlacementStateValue.initial);
    const OrderPlacementState.loading() :
        this._(OrderPlacementStateValue.loading);
    const OrderPlacementState.success({Order? order}) :
        this._(OrderPlacementStateValue.success, createdOrder: order);
    const OrderPlacementState.error(String message) :
        this._(OrderPlacementStateValue.error, errorMessage: message);
}

class OrderPlacementNotifier extends StateNotifier<OrderPlacementState> {
    final OrderRepository _repository;
    final Ref _ref;

    OrderPlacementNotifier(this._repository, this._ref)
        : super(const OrderPlacementState.initial());

    Future<void> createProductRequest({
        required String groupId,
        required String productName,
        required String quantity,
        required bool requestQuotation,
        required bool isNegotiable,
        String? minPrice,
        String? maxPrice,
        String? productUrgency,
        String? remarks,
        List<File>? images,
        List<File>? catalogs,
    }) async {
        state = const OrderPlacementState.loading();
        try {
            final num? parsedQuantity = num.tryParse(quantity);
            if (parsedQuantity == null) {
                state = const OrderPlacementState.error(
                    "Invalid quantity. Please enter a valid number.");
                return;
            }

            num? parsedMinPrice;
            if (minPrice != null && minPrice.isNotEmpty) {
                parsedMinPrice = num.tryParse(minPrice);
                if (parsedMinPrice == null) {
                    state = const OrderPlacementState.error(
                        "Invalid Minimum Price. Please enter a valid number.");
                    return;
                }
            }

            num? parsedMaxPrice;
            if (maxPrice != null && maxPrice.isNotEmpty) {
                parsedMaxPrice = num.tryParse(maxPrice);
                if (parsedMaxPrice == null) {
                    state = const OrderPlacementState.error(
                        "Invalid Maximum Price. Please enter a valid number.");
                    return;
                }
            }

            final orderData = {
                'group': groupId,
                'product_name': productName,
                'quantity': parsedQuantity,
                'order_type': "product_request",
                'request_quotation': requestQuotation,
                'price_range_min': parsedMinPrice,
                'price_range_max': parsedMaxPrice,
                'price_negotiable': isNegotiable,
                'product_urgency': productUrgency,
                'remarks': remarks,
            };

            orderData.removeWhere((key, value) => value == null);

            final newOrder = await _repository.createOrder(
                orderData: orderData,
                images: images,
                catalogs: catalogs,
            );
            _ref.invalidate(filteredOrdersProvider);
            state = OrderPlacementState.success(order: newOrder);
        } catch (e) {
            state = OrderPlacementState.error(e.toString());
        }
    }

    Future<void> updateOrder({
        required int orderId,
        required String groupId,
        required String productName,
        required String quantity,
        String? minPrice,
        String? maxPrice,
        String? remarks,
        List<File>? images,
        List<File>? catalogs,
    }) async {
        state = const OrderPlacementState.loading();
        try {
            final num? parsedQuantity = num.tryParse(quantity);
            if (parsedQuantity == null) {
                state = const OrderPlacementState.error(
                    "Invalid quantity. Please enter a valid number.");
                return;
            }

            num? parsedMinPrice;
            if (minPrice != null && minPrice.isNotEmpty) {
                parsedMinPrice = num.tryParse(minPrice);
                if (parsedMinPrice == null) {
                    state = const OrderPlacementState.error(
                        "Invalid Minimum Price. Please enter a valid number.");
                    return;
                }
            }

            num? parsedMaxPrice;
            if (maxPrice != null && maxPrice.isNotEmpty) {
                parsedMaxPrice = num.tryParse(maxPrice);
                if (parsedMaxPrice == null) {
                    state = const OrderPlacementState.error(
                        "Invalid Maximum Price. Please enter a valid number.");
                    return;
                }
            }

            final orderData = {
                'group': groupId,
                'product_name': productName,
                'quantity': parsedQuantity,
                'price_range_min': parsedMinPrice,
                'price_range_max': parsedMaxPrice,
                'remarks': remarks,
                'order_type': 'product_request',
            };

            orderData.removeWhere((key, value) => value == null);

            await _repository.updateOrder(
                orderId: orderId,
                orderData: orderData,
                images: images,
                catalogs: catalogs,
            );

            _ref.invalidate(filteredOrdersProvider);
            _ref.invalidate(myCreatedOrdersProvider);
            _ref.invalidate(receivedOrdersProvider);
            _ref.invalidate(orderDetailProvider);

            state = const OrderPlacementState.success();
        } catch (e) {
            state = OrderPlacementState.error(e.toString());
        }
    }
}

final orderPlacementProvider = StateNotifierProvider<OrderPlacementNotifier, OrderPlacementState>((ref)
    {
        final repository = ref.watch(orderRepositoryProvider);
        return OrderPlacementNotifier(repository, ref);
    }
);

enum OrderActionStateValue
{
    initial, loading, success, error
}

class OrderActionState
{
    final OrderActionStateValue value;
    final String? errorMessage;
    const OrderActionState._(this.value, {this.errorMessage});
    const OrderActionState.initial() : this._(OrderActionStateValue.initial);
    const OrderActionState.loading() : this._(OrderActionStateValue.loading);
    const OrderActionState.success() : this._(OrderActionStateValue.success);
    const OrderActionState.error(String message) : this._(OrderActionStateValue.error, errorMessage: message);
}

class OrderActionNotifier extends StateNotifier<OrderActionState>
{
    final OrderRepository _repository;
    final Ref _ref;

    OrderActionNotifier(this._repository, this._ref) : super(const OrderActionState.initial());

    Future<void> deleteOrder({required int orderId}) async
    {
        state = const OrderActionState.loading();
        try
        {
            await _repository.deleteOrder(orderId: orderId);
            _ref.invalidate(filteredOrdersProvider);
            state = const OrderActionState.success();
        }
        catch (e)
        {
            state = OrderActionState.error(e.toString());
        }
    }
}

final orderActionProvider = StateNotifierProvider<OrderActionNotifier, OrderActionState>((ref)
    {
        final repository = ref.watch(orderRepositoryProvider);
        return OrderActionNotifier(repository, ref);
    }
);

enum ReceivedOrderStatusValue
{
    initial, loading, success, error
}

class ReceivedOrderActionState
{
    final ReceivedOrderStatusValue value;
    final String? errorMessage;
    const ReceivedOrderActionState._(this.value, {this.errorMessage});
    const ReceivedOrderActionState.initial() : this._(ReceivedOrderStatusValue.initial);
    const ReceivedOrderActionState.loading() : this._(ReceivedOrderStatusValue.loading);
    const ReceivedOrderActionState.success() : this._(ReceivedOrderStatusValue.success);
    const ReceivedOrderActionState.error(String message) : this._(ReceivedOrderStatusValue.error, errorMessage: message);
}

class ReceivedOrderActionNotifier extends StateNotifier<ReceivedOrderActionState>
{
    final OrderRepository _repository;
    final Ref _ref;

    ReceivedOrderActionNotifier(this._repository, this._ref) : super(const ReceivedOrderActionState.initial());

    Future<void> updateStatus({
        required int orderId,
        required String newStatus,
    }) async
    {
        state = const ReceivedOrderActionState.loading();
        try
        {
            await _repository.updateReceivedOrderStatus(orderId: orderId, newStatus: newStatus);
            _ref.invalidate(filteredOrdersProvider);
            state = const ReceivedOrderActionState.success();
        }
        catch (e)
        {
            state = ReceivedOrderActionState.error(e.toString());
        }
    }
}

final receivedOrderActionProvider = StateNotifierProvider.autoDispose<ReceivedOrderActionNotifier, ReceivedOrderActionState>((ref)
    {
        final repository = ref.watch(orderRepositoryProvider);
        return ReceivedOrderActionNotifier(repository, ref);
    }
);

typedef OrderDetailParameter =  ({int orderId, bool isReceived});

final orderDetailProvider = FutureProvider.family.autoDispose<Order, OrderDetailParameter>((ref, param)
    {
        final repository = ref.watch(orderRepositoryProvider);

        if (param.isReceived)
        {
            return repository.getReceivedOrderDetails(param.orderId);
        }
        else
        {
            return repository.getOrderDetails(param.orderId);
        }
    }
);
