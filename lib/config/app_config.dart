// class ApiConfig
// {
//     static const String baseUrl = 'http://182.93.94.221:8000';
//     static const String webSocketLegacyHost = 'http://127.0.0.1:8000';
// }
// //ws://182.93.94.221:8000/ws/groupchat/{{groupId}}/?token={auth_token}


class ApiConfig
{
    static const String baseUrl = 'http://182.93.94.221:8000';
    static const String webSocketLegacyHost = 'http://127.0.0.1:8000'; // Keep for image URL replacement
    static const String webSocketBaseUrl = 'ws://182.93.94.221:8000';

    // Method to generate WebSocket URL for group chat
    static String getGroupChatWebSocketUrl(String groupId, String authToken) {
        return '$webSocketBaseUrl/ws/groupchat/$groupId/?token=$authToken';
    }
}