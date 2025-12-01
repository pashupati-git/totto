import 'package:dio/dio.dart';
import 'package:totto/config/api_client.dart';
import 'package:totto/data/models/group_model.dart';

class GroupRepository
{
    final Dio _dio = ApiClient().dio;

    Future<List<Group>> fetchGroups() async
    {
        const String endpointPath = '/api/v1/group/';
        try
        {
            final response = await _dio.get(endpointPath);
            final responseData = response.data;
            if (responseData is Map<String, dynamic>)
            {
                final List<dynamic>? groupListJson = responseData['results'] as List<dynamic>? ?? responseData['data'] as List<dynamic>?;
                if (groupListJson != null)
                {
                    return groupListJson.map((json) => Group.fromJson(json)).toList();
                }
                else
                {
                    throw Exception('API response is a Map but is missing the "results" or "data" list.');
                }
            }
            else if (responseData is List<dynamic>)
            {
                return responseData.map((json) => Group.fromJson(json)).toList();
            }
            else
            {
                throw Exception('Unexpected API response format for groups.');
            }
        }
        on DioException catch (e)
        {
            throw Exception('An error occurred while fetching groups: ${e.message}');
        }
    }

    Future<List<Group>> fetchMyGroups() async
    {
        const String endpointPath = '/api/v1/group/joined-groups/';
        try
        {
            final response = await _dio.get(endpointPath);
            final responseData = response.data;
            if (responseData is Map<String, dynamic>)
            {
                final List<dynamic>? groupListJson = responseData['results'] as List<dynamic>? ?? responseData['data'] as List<dynamic>?;
                if (groupListJson != null)
                {
                    return groupListJson.map((json) => Group.fromJson(json)).toList();
                }
                else
                {
                    throw Exception('API response is a Map but is missing the "results" or "data" list.');
                }
            }
            else if (responseData is List<dynamic>)
            {
                return responseData.map((json) => Group.fromJson(json)).toList();
            }
            else
            {
                throw Exception('Unexpected API response format for my groups.');
            }
        }
        on DioException catch (e)
        {
            throw Exception('An error occurred while fetching my groups: ${e.message}');
        }
    }

    Future<void> createGroup({
        required String name,
        required String guidelines,
        required int categoryId,
        required String roomType,
    }) async
    {
        const String endpointPath = '/api/v1/group/';
        final Map<String, dynamic> requestBody =
            {
                'name': name,
                'guidelines': guidelines,
                'category_id': categoryId,
                'room_type': roomType,
            };
        try
        {
            final response = await _dio.post(endpointPath, data: requestBody);
            if (response.statusCode != 201)
            {
                throw Exception('Failed to create group. Status code: ${response.statusCode}');
            }
        }
        on DioException catch (e)
        {
            throw Exception('An error occurred while creating the group: ${e.response?.data}');
        }
    }

    Future<void> joinGroup(String groupId) async
    {
        const String endpointPath = '/api/v1/groupmember/';
        print('--- REPOSITORY: Attempting to join group with ID: $groupId ---');

        try
        {
            final Map<String, String> requestBody =
                {
                    'group_id': groupId,
                    'role': 'M',
                };

            print('--- REPOSITORY: Sending POST to $endpointPath with data: $requestBody');
            await _dio.post(endpointPath, data: requestBody);

            print('--- REPOSITORY: Successfully joined group! ---');

        }
        on DioException catch (e)
        {
            print('--- REPOSITORY: FAILED to join group. ---');
            print('--- DIO ERROR RESPONSE ---');
            print(e.response?.data);
            print('--------------------------');

            final errorData = e.response?.data;
            String errorMessage = 'Status code: ${e.response?.statusCode}';
            if (errorData is Map && errorData.isNotEmpty)
            {
                errorMessage = errorData.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ');
            }

            throw Exception('Failed to join group. Server said: $errorMessage');
        }
    }

    Future<void> updateGroup(String groupId, {required String newName}) async
    {
        final String endpointPath = '/api/v1/group/$groupId/';
        print('--- REPOSITORY: Updating group $groupId with new name: $newName ---');
        try
        {
            await _dio.patch(endpointPath, data: {'name': newName});
            print('Group updated successfully.');
        }
        on DioException catch (e)
        {
            throw Exception('Failed to update group name: ${e.response?.data}');
        }
    }

    Future<void> leaveGroup(int groupMemberId) async
    {
        final String endpointPath = '/api/v1/groupmember/$groupMemberId/';
        print('--- REPOSITORY: Leaving group via member ID: $groupMemberId ---');
        try
        {
            await _dio.delete(endpointPath);
            print('Successfully left group.');
        }
        on DioException catch (e)
        {
            throw Exception('Failed to leave group: ${e.response?.data}');
        }
    }

    Future<void> deleteGroup(String groupId) async
    {
        final String endpointPath = '/api/v1/group/$groupId/';
        print('--- REPOSITORY: Deleting group: $groupId ---');
        try
        {
            await _dio.delete(endpointPath);
            print('Successfully deleted group.');
        }
        on DioException catch (e)
        {
            throw Exception('Failed to delete group: ${e.response?.data}');
        }
    }
    Future<Group> getOrCreatePersonalChat(String otherUserId) async {
        const String endpointPath = '/api/v1/group/start-personal-chat/';
        print('--- REPOSITORY: Starting personal chat with user ID: $otherUserId ---');

        try {
            final response = await _dio.get(
                endpointPath,
                data: {'user_id': otherUserId},
            );

            if (response.statusCode == 200 || response.statusCode == 201) {
                return Group.fromJson(response.data);
            } else {
                throw Exception('Failed to start personal chat. Status code: ${response.statusCode}');
            }
        } on DioException catch (e) {
            print('--- DIO ERROR on start-personal-chat ---');
            print(e.response?.data);
            print('------------------------------------');
            throw Exception('An error occurred while starting the personal chat: ${e.response?.data}');
        }
    }

    Future<Group> fetchGroupDetails(String groupId) async {
        final String endpointPath = '/api/v1/group/$groupId/';
        try {
            final response = await _dio.get(endpointPath);
            return Group.fromJson(response.data);
        } on DioException catch (e) {
            throw Exception('Failed to load group details for $groupId: ${e.response?.data ?? e.message}');
        }
    }
}
