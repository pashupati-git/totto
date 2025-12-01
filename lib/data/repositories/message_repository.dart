import 'dart:io';
import 'package:dio/dio.dart';
import 'package:totto/config/api_client.dart';
import 'package:totto/config/app_config.dart';
import 'package:totto/data/models/message_model.dart';

class MessageRepository
{
    final Dio _dio = ApiClient().dio;

    Future<List<Message>> fetchMessagesForGroup(String groupId) async
    {
        final String endpointPath = '/api/v1/message/group/$groupId/';
        try
        {
            final response = await _dio.get(endpointPath);
            final List<dynamic> messageListJson = response.data as List<dynamic>;
            final messages = messageListJson.map((json) => Message.fromJson(json)).toList();
            messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
            return messages;
        }
        on DioException catch (e)
        {
            throw Exception('Failed to fetch messages: ${e.response?.data}');
        }
    }



    Future<void> postMessage({
        required String content,
        required String groupId,
        int? replyToId,
    }) async
    {
        const String endpointPath = '/api/v1/message/';
        print('--- REPOSITORY: Posting message to: $endpointPath ---');
        try
        {
            final Map<String, dynamic> requestData =
                {
                    'content': content,
                    'group': groupId,
                    'urgency': 'NORMAL',
                    if (replyToId != null) 'reply_to': replyToId,
                };

            final FormData formData = FormData.fromMap(requestData);

            await _dio.post(endpointPath, data: formData);

        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to post message: ${e.response?.data}');
            throw Exception('Failed to send message.');
        }
    }

    Future<String> uploadChatImage(File imageFile) async
    {
        const String endpointPath = '/api/v1/upload-image/';
        print('--- REPOSITORY: Uploading image to: $endpointPath ---');

        try
        {
            String fileName = imageFile.path.split('/').last;

            FormData formData = FormData.fromMap(
            {
                'image': await MultipartFile.fromFile(
                    imageFile.path,
                    filename: fileName,
                ),
            }
            );

            final response = await _dio.post(endpointPath, data: formData);

            if (response.statusCode == 201 || response.statusCode == 200) 
            {
                final imagePath = response.data['image'];
                if (imagePath != null) 
                {
                    print('--- REPOSITORY: Got relative image path: $imagePath ---');
                    return imagePath;
                }
                else 
                {
                    throw Exception("API response did not contain an 'image' key.");
                }
            }
            else 
            {
                throw Exception('Image upload failed with status code: ${response.statusCode}');
            }

        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to upload image: ${e.response?.data}');
            throw Exception('Failed to upload image.');
        }
    }

    Future<void> deleteMessage(int messageId) async
    {
        final String endpointPath = '/api/v1/message/$messageId/';
        try
        {
            await _dio.delete(endpointPath);
            print('--- REPOSITORY: Deleted message with ID: $messageId ---');
        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to delete message: ${e.response?.data}');
            throw Exception('Failed to delete message.');
        }
    }

    Future<Message> editMessage(int messageId, String newContent) async
    {
        final String endpointPath = '/api/v1/message/$messageId/';
        try
        {

            final FormData formData = FormData.fromMap(
            {
                'content': newContent,
            }
            );

            final response = await _dio.patch(
                endpointPath,
                data: formData,
            );

            return Message.fromJson(response.data);
        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to edit message: ${e.response?.data}');
            throw Exception('Failed to edit message.');
        }
    }
    Future<void> postImageMessage({
        required File imageFile,
        required String groupId,
        String? content,
        int? replyToId,
    }) async
    {
        const String endpointPath = '/api/v1/message/';
        print('--- REPOSITORY: Posting image message to: $endpointPath ---');
        try
        {
            String fileName = imageFile.path.split('/').last;

            final Map<String, dynamic> requestData = 
            {
                'group': groupId,
                'urgency': 'NORMAL',
                if (content != null && content.isNotEmpty) 'content': content,
                if (replyToId != null) 'reply_to': replyToId,
                'image': await MultipartFile.fromFile(
                    imageFile.path,
                    filename: fileName,
                ),
            };

            final FormData formData = FormData.fromMap(requestData);

            await _dio.post(endpointPath, data: formData);

        }
        on DioException catch (e)
        {
            print('--- REPOSITORY ERROR: Failed to post image message: ${e.response?.data}');
            throw Exception('Failed to send image message.');
        }
    }
}

