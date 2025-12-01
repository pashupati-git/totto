import 'dart:io';

import 'package:dio/dio.dart';
import 'package:totto/config/api_client.dart';
import 'package:totto/data/models/business_category_model.dart';
import 'package:totto/data/models/product_model.dart';
import 'package:totto/features/search/providers/search_filter_state.dart';

class ProductRepository
{
    final Dio _dio = ApiClient().dio;

    Future<Product> createProduct({
        required String name,
        required String description,
        required String price,
        required int unitId,
        required int categoryId,
        File? image,
    }) async
    {
        const String endpointPath = '/api/v1/product/';
        print('--- REPOSITORY: Creating new product ---');

        final formData = FormData.fromMap(
        {
            'name': name,
            'description': description,
            'price': price,
            'unit': unitId,
            'category': categoryId,
            'stock': 1,
            'available': true,
        }
        );

        if (image != null)
        {
            formData.files.add(MapEntry(
                    'image',
                    await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
                ));
        }

        try
        {
            final response = await _dio.post(endpointPath, data: formData);
            return Product.fromJson(response.data);
        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to create product ---');
            print('Status Code: ${e.response?.statusCode}');
            print('Response Data: ${e.response?.data}');

            if (e.response?.data is Map<String, dynamic>)
            {
                final errorData = e.response!.data as Map<String, dynamic>;
                final errorMessage = errorData.entries.map((entry)
                    {
                        final key = entry.key;
                        final value = entry.value;
                        if (value is List)
                        {
                            return '$key: ${value.join(', ')}';
                        }
                        return '$key: $value';
                    }
                ).join(' | ');
                throw Exception(errorMessage);
            }

            throw Exception('An unknown error occurred while creating the product.');
        }
    }

    Future<Product> updateMyProduct({
        required String productId,
        required String name,
        required String description,
        required String price,
        required int unitId,
        required int categoryId,
        File? image,
    }) async
    {
        final String endpointPath = '/api/v1/my-product/$productId/';
        print('--- REPOSITORY: Updating product with ID $productId ---');

        final formData = FormData.fromMap(
        {
            'name': name,
            'description': description,
            'price': price,
            'unit': unitId,
            'category': categoryId,
        }
        );

        if (image != null)
        {
            formData.files.add(MapEntry(
                    'image',
                    await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
                ));
        }

        try
        {
            final response = await _dio.patch(endpointPath, data: formData);
            return Product.fromJson(response.data);
        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to update product ---');
            print('Status Code: ${e.response?.statusCode}');
            print('Response Data: ${e.response?.data}');

            if (e.response?.data is Map<String, dynamic>)
            {
                final errorData = e.response!.data as Map<String, dynamic>;
                final errorMessage = errorData.entries.map((entry)
                    {
                        final key = entry.key;
                        final value = entry.value;
                        if (value is List)
                        {
                            return '$key: ${value.join(', ')}';
                        }
                        return '$key: $value';
                    }
                ).join(' | ');
                throw Exception(errorMessage);
            }
            throw Exception('An unknown error occurred while updating the product.');
        }
    }

    Future<List<Product>> fetchProducts() async
    {
        const String endpointPath = '/api/v1/product/';
        print('--- REPOSITORY: Fetching ALL products from: $endpointPath ---');
        try
        {
            final response = await _dio.get(endpointPath);
            final responseData = response.data as Map<String, dynamic>;
            final List<dynamic>? productListJson = responseData['data'] as List<dynamic>? ?? responseData['results'] as List<dynamic>?;

            if (productListJson != null)
            {
                return productListJson.map((json) => Product.fromJson(json)).toList();
            }
            else
            {
                throw Exception('API response is missing the "data" or "results" list.');
            }
        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to fetch all products ---');
            print('Status Code: ${e.response?.statusCode}');
            print('Response Data: ${e.response?.data}');
            throw Exception('An error occurred while fetching products.');
        }
    }

    Future<List<Product>> searchProducts(SearchFilterState filters) async
    {
        const String endpointPath = '/api/v1/product/';
        print('--- REPOSITORY: Searching products with filters ---');

        final queryParameters = <String, dynamic>{};

        if (filters.searchTerm.isNotEmpty)
        {
            queryParameters['q'] = filters.searchTerm;
        }
        if (filters.minPrice != null && filters.minPrice!.isNotEmpty)
        {
            queryParameters['min_price'] = filters.minPrice;
        }
        if (filters.maxPrice != null && filters.maxPrice!.isNotEmpty)
        {
            queryParameters['max_price'] = filters.maxPrice;
        }
        if (filters.selectedCategories.isNotEmpty)
        {
            queryParameters['category'] = filters.selectedCategories.join(',');
        }

        print('Querying $endpointPath with params: $queryParameters');

        try
        {
            final response = await _dio.get(
                endpointPath,
                queryParameters: queryParameters,
            );
            final responseData = response.data as Map<String, dynamic>;
            final List<dynamic>? productListJson = responseData['data'] as List<dynamic>? ?? responseData['results'] as List<dynamic>?;

            if (productListJson != null)
            {
                return productListJson.map((json) => Product.fromJson(json)).toList();
            }
            else
            {
                throw Exception('API response is missing the "data" or "results" list.');
            }
        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to search products ---');
            print('Status Code: ${e.response?.statusCode}');
            print('Response Data: ${e.response?.data}');
            throw Exception('An error occurred while searching for products.');
        }
    }

    Future<Product> fetchProductById(String id) async
    {
        final String endpointPath = '/api/v1/product/$id/';
        print('--- REPOSITORY: Fetching single product from: $endpointPath ---');
        try
        {
            final response = await _dio.get(endpointPath);
            return Product.fromJson(response.data);
        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to fetch product with ID $id ---');
            print('Status Code: ${e.response?.statusCode}');
            print('Response Data: ${e.response?.data}');
            throw Exception('An error occurred while fetching the product.');
        }
    }

    Future<List<BusinessCategory>> fetchProductCategories() async
    {
        const String endpointPath = '/api/v1/categories/';
        print('--- REPOSITORY: Fetching ALL business categories from: $endpointPath ---');
        try
        {
            final response = await _dio.get(endpointPath);
            if (response.statusCode == 200)
            {
                final responseData = response.data as Map<String, dynamic>;

                final List<dynamic>? categoryListJson = responseData['results'] as List<dynamic>? ?? responseData['data'] as List<dynamic>?;

                if (categoryListJson != null)
                {
                    return categoryListJson.map((json) => BusinessCategory.fromJson(json)).toList();
                }
                else
                {
                    throw Exception('API response for categories is missing the "data" or "results" list.');
                }
            }
            else
            {
                throw Exception('Failed to load product categories. Status code: ${response.statusCode}');
            }
        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to fetch product categories ---');
            print('Status Code: ${e.response?.statusCode}');
            print('Response Data: ${e.response?.data}');
            throw Exception('An error occurred while fetching product categories.');
        }
    }

    // Future<List<Product>> fetchMyProducts() async
    // {
    //     const String endpointPath = '/api/v1/my-product/';
    //     print('--- REPOSITORY: Fetching MY products from: $endpointPath ---');
    //     try
    //     {
    //         final response = await _dio.get(endpointPath);
    //         if (response.data is Map<String, dynamic>)
    //         {
    //             final responseData = response.data as Map<String, dynamic>;
    //             final List<dynamic>? productListJson = responseData['data'] as List<dynamic>? ?? responseData['results'] as List<dynamic>?;
    //
    //             if (productListJson != null)
    //             {
    //                 return productListJson.map((json) => Product.fromJson(json)).toList();
    //             }
    //             else
    //             {
    //                 throw Exception('API response for my-products is missing the "data" or "results" list.');
    //             }
    //         }
    //         else if (response.data is List)
    //         {
    //             final productListJson = response.data as List;
    //             return productListJson.map((json) => Product.fromJson(json)).toList();
    //         }
    //         else
    //         {
    //             throw Exception('Unexpected API response format for my-products.');
    //         }
    //     }
    //     on DioException catch (e)
    //     {
    //         print('--- REPOSITORY ERROR: Failed to fetch my products ---');
    //         print('Status Code: ${e.response?.statusCode}');
    //         print('Response Data: ${e.response?.data}');
    //         throw Exception('An error occurred while fetching your products.');
    //     }
    // }



    // Latest fetchMyProducts

    Future<List<Product>> fetchMyProducts({String? status}) async
    {
      const String endpointPath = '/api/v1/my-product/';
      print('--- REPOSITORY: Fetching MY products from: $endpointPath ---');

      try
      {
        // Add query parameters if status is provided
        final queryParameters = <String, dynamic>{};
        if (status != null) {
          queryParameters['status'] = status;
        }

        final response = await _dio.get(
          endpointPath,
          queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
        );

        if (response.data is Map<String, dynamic>)
        {
          final responseData = response.data as Map<String, dynamic>;
          final List<dynamic>? productListJson = responseData['data'] as List<dynamic>? ?? responseData['results'] as List<dynamic>?;

          if (productListJson != null)
          {
            return productListJson.map((json) => Product.fromJson(json)).toList();
          }
          else
          {
            throw Exception('API response for my-products is missing the "data" or "results" list.');
          }
        }
        else if (response.data is List)
        {
          final productListJson = response.data as List;
          return productListJson.map((json) => Product.fromJson(json)).toList();
        }
        else
        {
          throw Exception('Unexpected API response format for my-products.');
        }
      }
      on DioException catch (e)
      {
        print('--- REPOSITORY ERROR: Failed to fetch my products ---');
        print('Status Code: ${e.response?.statusCode}');
        print('Response Data: ${e.response?.data}');
        throw Exception('An error occurred while fetching your products.');
      }
    }







    Future<void> deleteMyProduct(String productId) async
    {
        final String endpointPath = '/api/v1/my-product/$productId/';
        print('--- REPOSITORY: Deleting product with ID $productId from: $endpointPath ---');
        try
        {
            final response = await _dio.delete(endpointPath);
            if (response.statusCode != 204)
            {
                print('--- REPOSITORY WARNING: Expected 204 No Content, but got ${response.statusCode} ---');
            }
        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to delete product with ID $productId ---');
            print('Status Code: ${e.response?.statusCode}');
            print('Response Data: ${e.response?.data}');
            throw Exception('An error occurred while deleting the product.');
        }
    }
    /// Upload a product from "My Products" to "Marketplace"
    Future<void> uploadProductToMarketplace(String productId) async {
      final String endpointPath = '/api/v1/my-product/$productId/';
      print('--- REPOSITORY: Uploading product $productId to marketplace ---');

      try {
        final response = await _dio.patch(
          endpointPath,
          data: {
            'status': 'P',  // Set status to 'P' for Published
          },
        );

        print('--- REPOSITORY: Product uploaded successfully ---');
        print('Status Code: ${response.statusCode}');

      } on DioException catch (e) {
        print('--- REPOSITORY ERROR: Failed to upload product to marketplace ---');
        print('Status Code: ${e.response?.statusCode}');
        print('Response Data: ${e.response?.data}');
        throw Exception('Failed to upload product to marketplace: ${e.message}');
      }
    }





    /// Fetch published products from the marketplace
    Future<List<Product>> fetchMarketplaceProducts() async {
      const String endpointPath = '/api/v1/product/'; // or the marketplace-specific endpoint
      print('--- REPOSITORY: Fetching MARKETPLACE products from: $endpointPath ---');

      try {
        final response = await _dio.get(
          endpointPath,
          queryParameters: {'status': 'P'}, // Filter for published products only
        );

        final responseData = response.data as Map<String, dynamic>;
        final List<dynamic>? productListJson =
            responseData['data'] as List<dynamic>? ??
                responseData['results'] as List<dynamic>?;

        if (productListJson != null) {
          return productListJson.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception('API response is missing the "data" or "results" list.');
        }
      } on DioException catch (e) {
        print('--- REPOSITORY ERROR: Failed to fetch marketplace products ---');
        print('Status Code: ${e.response?.statusCode}');
        print('Response Data: ${e.response?.data}');
        throw Exception('An error occurred while fetching marketplace products.');
      }
    }
















}
