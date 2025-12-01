
import 'package:dio/dio.dart';
import 'package:totto/config/api_client.dart';
import 'package:totto/data/models/group_member_model.dart';

class GroupMemberRepository
{
    final Dio _dio = ApiClient().dio;

    Future<List<GroupMember>> fetchGroupMembers(String groupId) async
    {
        const String endpointPath = '/api/v1/groupmember/';
        try
        {
            final response = await _dio.get(endpointPath, queryParameters: {'group': groupId});
            final responseData = response.data as Map<String, dynamic>;
            final List<dynamic>? memberListJson = responseData['results'] as List<dynamic>?
                ?? responseData['data'] as List<dynamic>?;

            if (memberListJson != null)
            {
                return memberListJson.map((json) => GroupMember.fromJson(json)).toList();
            }
            else
            {
                return [];
            }
        }
        on DioException catch (e)
        {
            throw Exception('Failed to fetch group members: ${e.response?.data}');
        }
    }

    Future<void> updateMemberRole({required int memberId, required String newRole}) async
    {
        final String endpointPath = '/api/v1/groupmember/$memberId/';
        try
        {
            await _dio.patch(endpointPath, data: {'role': newRole});
        }
        on DioException catch (e)
        {
            throw Exception('Failed to update member role: ${e.response?.data}');
        }
    }

    Future<void> removeMember(int memberId) async
    {
        final String endpointPath = '/api/v1/groupmember/$memberId/';
        try
        {
            await _dio.delete(endpointPath);
        }
        on DioException catch (e)
        {
            throw Exception('Failed to remove member: ${e.response?.data}');
        }
    }

    Future<void> addMember({required String groupId, required String userId}) async
    {
        const String endpointPath = '/api/v1/groupmember/';
        try
        {
            final Map<String, String> requestBody =
                {
                    'group_id': groupId,
                    'role': 'M',
                };
            await _dio.post(endpointPath, data: requestBody);
            print('addMember successful!');
        }
        on DioException catch (e)
        {
            final errorData = e.response?.data;
            String errorMessage = 'Status code: ${e.response?.statusCode}';
            if (errorData is Map && errorData.isNotEmpty)
            {
                errorMessage = errorData.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ');
            }
            throw Exception('Failed to add member: $errorMessage');
        }
    }

    Future<void> joinGroup({required String groupId, required String userId}) async
    {
        const String endpointPath = '/api/v1/groupmember/';
        print('--- REPOSITORY: Joining group via POST at: $endpointPath ---');

        try
        {
            final Map<String, String> requestBody =
                {
                    'group_id': groupId,
                    'role': 'M',
                };

            await _dio.post(endpointPath, data: requestBody);
            print('--- REPOSITORY: Group joined successfully ---');
        }
        on DioException catch (e)
        {
            final errorMessage = e.response?.data?['detail'] ?? 'An error occurred while joining the group.';
            throw Exception(errorMessage);
        }
    }
}
