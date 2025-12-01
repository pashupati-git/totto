
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:totto/features/order/providers/order_providers.dart';

import '../models/order_model.dart';

class OrderRepository
{
    final Dio _apiClient;

    OrderRepository(this._apiClient);

    Future<List<Order>> fetchGeneralOrders() async
    {
        try
        {
            final response = await _apiClient.get('/api/v1/order/');
            final dynamic data = response.data['data'];
            if (data is List)
            {
                return data.map((item) => Order.fromJson(item)).toList();
            }
            return [];
        }
        on DioException catch (e)
        {
            print("Error fetching general orders: ${e.response?.data ?? e.message}");
            throw Exception('Failed to load orders.');
        }
    }

    Future<List<Order>> fetchReceivedOrders() async
    {
        try
        {
            final response = await _apiClient.get('/api/v1/received-orders/');
            final dynamic data = response.data['data'];
            if (data is List)
            {
                return data.map((item) => Order.fromJson(item)).toList();
            }
            return [];
        }
        on DioException catch (e)
        {
            print("Error fetching received orders: ${e.response?.data ?? e.message}");
            throw Exception('Failed to load received orders.');
        }
    }

    Future<List<Order>> fetchMyCreatedOrders() async
    {
        try
        {
            final response = await _apiClient.get('/api/v1/order/my-orders/');
            final dynamic data = response.data['data'];
            if (data is List)
            {
                return data.map((item) => Order.fromJson(item)).toList();
            }
            return [];
        }
        on DioException catch (e)
        {
            print("Error fetching my-orders: ${e.response?.data ?? e.message}");
            throw Exception('Failed to load your created orders.');
        }
    }

    Future<Order> createOrder({
        required Map<String, dynamic> orderData,
        List<File>? images,
        List<File>? catalogs,
    }) async {
        try {
            Response response;

            if ((images != null && images.isNotEmpty) || (catalogs != null && catalogs.isNotEmpty)) {

                final formDataMap = Map<String, dynamic>.from(orderData);

                if (images != null) {
                    formDataMap['images'] = [
                        for (var imageFile in images)
                            await MultipartFile.fromFile(imageFile.path),
                    ];
                }

                if (catalogs != null) {
                    formDataMap['catalogs'] = [
                        for (var catalogFile in catalogs)
                            await MultipartFile.fromFile(catalogFile.path),
                    ];
                }

                final formData = FormData.fromMap(formDataMap);

                response = await _apiClient.post(
                    '/api/v1/order/',
                    data: formData,
                    options: Options(
                        headers: {'Content-Type': 'multipart/form-data'},
                    ),
                );

            } else {
                response = await _apiClient.post(
                    '/api/v1/order/',
                    data: orderData,
                );
            }

            if (response.statusCode == 201) {
                return Order.fromJson(response.data);
            } else {
                throw Exception('Failed to place order: Server returned status ${response.statusCode}');
            }
        } on DioException catch (e) {
            final errorMessage = e.response?.data.toString() ?? 'An unknown error occurred.';
            print("Error creating order: ${e.response?.data}");
            throw Exception('Failed to place order: $errorMessage');
        }
    }

    Future<void> updateOrder({
        required int orderId,
        required Map<String, dynamic> orderData,
        List<File>? images,
        List<File>? catalogs,
    }) async {
        try {
            if ((images != null && images.isNotEmpty) || (catalogs != null && catalogs.isNotEmpty)) {

                final formDataMap = Map<String, dynamic>.from(orderData);

                if (images != null) {
                    formDataMap['images'] = [
                        for (var imageFile in images)
                            await MultipartFile.fromFile(imageFile.path),
                    ];
                }

                if (catalogs != null) {
                    formDataMap['catalogs'] = [
                        for (var catalogFile in catalogs)
                            await MultipartFile.fromFile(catalogFile.path),
                    ];
                }

                final formData = FormData.fromMap(formDataMap);

                await _apiClient.patch(
                    '/api/v1/order/$orderId/',
                    data: formData,
                    options: Options(
                        headers: {'Content-Type': 'multipart/form-data'},
                    ),
                );

            } else {
                await _apiClient.patch(
                    '/api/v1/order/$orderId/',
                    data: orderData,
                );
            }
        } on DioException catch (e) {
            final errorMessage = e.response?.data.toString() ?? 'An unknown error occurred.';
            print("Error updating order: ${e.response?.data}");
            throw Exception('Failed to update order: $errorMessage');
        }
    }

    Future<void> deleteOrder({required int orderId}) async
    {
        try
        {
            await _apiClient.delete('/api/v1/order/$orderId/');
        }
        on DioException catch (e)
        {
            final errorMessage = e.response?.data.toString() ??
                'An unknown error occurred.';
            print("Error deleting order: ${e.response?.data}");
            throw Exception('Failed to delete order: $errorMessage');
        }
    }

    Future<void> updateReceivedOrderStatus({
        required int orderId,
        required String newStatus,
    }) async
    {
        try
        {
            await _apiClient.patch(
                '/api/v1/received-orders/$orderId/',
                data: {'status': newStatus},
            );
        }
        on DioException catch (e)
        {
            final errorMessage = e.response?.data.toString() ?? 'An unknown error occurred.';
            print("Error updating received order status: ${e.response?.data}");
            throw Exception('Failed to update status: $errorMessage');
        }
    }

    Future<Order> getOrderDetails(int orderId) async
    {
        try
        {
            final response = await _apiClient.get('/api/v1/order/$orderId/');
            return Order.fromJson(response.data);
        }
        on DioException catch (e)
        {
            print("Error fetching order details for ID $orderId: ${e.response?.data ?? e.message}");
            throw Exception('Failed to load order details.');
        }
    }
    Future<Order> getReceivedOrderDetails(int orderId) async
    {
        try
        {
            final response = await _apiClient.get('/api/v1/received-orders/$orderId/');

            return Order.fromJson(response.data);
        }
        on DioException catch (e)
        {
            print("Error fetching RECEIVED order details for ID $orderId: ${e.response?.data ?? e.message}");
            throw Exception('Failed to load received order details.');
        }
    }

    Future<List<Order>> fetchOrdersForGroup(String groupId) async {
        try {
            final response = await _apiClient.get(
                '/api/v1/order/',
                queryParameters: {'group': groupId},
            );
            final dynamic data = response.data['data'];
            if (data is List) {
                return data.map((item) => Order.fromJson(item)).toList();
            }
            return [];
        } on DioException catch (e) {
            print("Error fetching orders for group $groupId: ${e.response?.data ?? e.message}");
            throw Exception('Failed to load orders for the group.');
        }
    }

    Future<void> updateOrderStatus({
        required int orderId,
        required String newStatus,
    }) async {
        try {
            await _apiClient.patch(
                '/api/v1/order/$orderId/',
                data: {'status': newStatus},
            );
        } on DioException catch (e) {
            final errorMessage = e.response?.data.toString() ?? 'An unknown error occurred.';
            print("Error updating order status: ${e.response?.data}");
            throw Exception('Failed to update order status: $errorMessage');
        }
    }
}
