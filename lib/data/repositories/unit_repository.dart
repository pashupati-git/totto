import 'package:dio/dio.dart';
import 'package:totto/config/api_client.dart';
import 'package:totto/data/models/unit_model.dart';

class UnitRepository
{
    final Dio _dio = ApiClient().dio;

    Future<List<Unit>> fetchUnits() async
    {
        const String endpointPath = '/api/v1/unit/';
        try
        {
            final response = await _dio.get(endpointPath);
            final responseData = response.data as Map<String, dynamic>;

            final List<dynamic>? unitListJson = responseData['results'] as List<dynamic>?
                ?? responseData['data'] as List<dynamic>?;

            if (unitListJson != null)
            {
                return unitListJson.map((json) => Unit.fromJson(json)).toList();
            }
            else
            {
                throw Exception('API response is missing the "results" or "data" list.');
            }
        }
        on DioException catch (e)
        {
            throw Exception('An error occurred while fetching units: ${e.response?.data ?? e.message}');
        }
    }
}
