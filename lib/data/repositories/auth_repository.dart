import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_sign_in;
import 'package:totto/config/api_client.dart';
import 'package:totto/data/models/user_profile_model.dart';

import '../models/business_category_model.dart';

class AuthRepository
{
    final _authStateController = StreamController<UserProfile?>.broadcast();
    UserProfile? _currentUser;
    Stream<UserProfile?> get authStateChanges => _authStateController.stream;
    final Dio _dio = ApiClient().dio;
    // final _googleSignIn = google_sign_in.GoogleSignIn(


    // );

    final _storage = const FlutterSecureStorage();
    static const _authTokenKey = 'auth_token';

    AuthRepository()
    {

       /* google_sign_in.GoogleSignIn.instance.initialize(
            serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
        );*/
        tryAutoLogin();
    }

    Future<void> tryAutoLogin() async
    {
        final token = await _storage.read(key: _authTokenKey);

        if (token == null || token.isEmpty)
        {
            print('AuthRepository: No token found in storage. User is logged out.');
            _authStateController.add(null);
            return;
        }

        print('AuthRepository: Token found in storage. Attempting to validate...');
        ApiClient().setAuthToken(token);

        try
        {
            await fetchCurrentUser();
            print('AuthRepository: Auto-login successful.');
        }
        catch (e)
        {
            print('AuthRepository: Token validation failed. Logging out. Error: $e');
            await logout();
        }
    }

    Future<UserProfile> signInWithGoogle() async
    {
        try
        {
            // final google_sign_in.GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

            // if (googleUser == null)
            {
                throw Exception('Google sign-in was cancelled by the user.');
            }

            // final google_sign_in.GoogleSignInAuthentication googleAuth = await googleUser.authentication;
            // final String? idToken = googleAuth.idToken;

            // if (idToken == null)
            {
                throw Exception('Failed to retrieve Google ID token.');
            }

            final response = await _dio.post(
                '/auth/google-auth/',
                // data: { 'id_token': idToken },
            );

            if (response.statusCode == 200 || response.statusCode == 201)
            {
                final responseData = response.data as Map<String, dynamic>;
                final String apiToken = responseData['token'];
                final UserProfile user = UserProfile.fromJson(responseData['user']);

                await _storage.write(key: _authTokenKey, value: apiToken);
                ApiClient().setAuthToken(apiToken);

                _currentUser = user;
                _authStateController.add(_currentUser);
                print('Google Sign-In successful. Token saved. Broadcasting user state.');

                return user;
            }
            else
            {
                throw Exception('Backend authentication failed with status code: ${response.statusCode}');
            }
        }
        on DioException catch (e)
        {
            print('Google Auth DioError: ${e.response?.data}');
            throw Exception('An error occurred during Google sign-in. Please try again.');
        }
        catch (e)
        {
            print('Google Auth General Error: $e');
            rethrow;
        }
    }

    Future<bool> requestOtp(String phone) async
    {
        const String endpointPath = '/auth/login/';
        try
        {
            final response = await _dio.post(endpointPath, data: {'phone': phone});
            if (response.statusCode == 200)
            {
                final responseData = response.data as Map<String, dynamic>;
                if (responseData.containsKey('otp'))
                {
                    final devOtp = responseData['otp'];
                    print("====== OTP RECEIVED: $devOtp ======");
                }
                return true;
            }
            return false;
        }
        on DioException catch (e)
        {
            print('Error on requestOtp: ${e.response?.data}');
            return false;
        }
    }

    Future<UserProfile?> verifyOtpAndLogin(String otp) async
    {
        const String endpointPath = '/auth/verify-otp/';
        try
        {
            final response = await _dio.post(endpointPath, data: {'otp': otp});
            if (response.statusCode == 200)
            {
                final responseData = response.data as Map<String, dynamic>;
                if (responseData.containsKey('token'))
                {
                    final String token = responseData['token'];

                    ApiClient().setAuthToken(token);

                    await _storage.write(key: _authTokenKey, value: token);

                    final userJson = responseData['user'];
                    _currentUser = UserProfile.fromJson(userJson);
                    _authStateController.add(_currentUser);
                    print('OTP Login successful. Token saved. Broadcasting user state.');
                    return _currentUser;
                }
                else
                {
                    throw Exception("The 'token' key was not found in the API response.");
                }
            }
            else
            {
                return null;
            }
        }
        on DioException catch (e)
        {
            print('Error on verifyOtpAndLogin: ${e.response?.data}');
            return null;
        }
    }

    Future<void> logout() async
    {
        // await _googleSignIn.signOut();
        print('Signed out from Google.');

        const String endpointPath = '/auth/logout/';
        try
        {
            await _dio.post(endpointPath);
        }
        catch (e)
        {
            print('Error during server logout: $e');
        }
        ApiClient().clearAuthToken();

        await _storage.delete(key: _authTokenKey);

        _currentUser = null;
        _authStateController.add(null);
        print('User logged out. Token deleted.');
    }

    Future<UserProfile> fetchCurrentUser() async
    {
        const String endpointPath = '/auth/users/me/';
        try
        {
            final response = await _dio.get(endpointPath);
            _currentUser = UserProfile.fromJson(response.data);
            _authStateController.add(_currentUser);
            return _currentUser!;
        }
        on DioException catch (e)
        {
            print('Failed to fetch user profile: ${e.response?.data}');
            throw Exception('Failed to fetch user profile.');
        }
    }

    Future<UserProfile> fetchUserProfileById(String userId) async
    {
        final String endpointPath = '/auth/users/$userId/';
        try
        {
            final response = await _dio.get(endpointPath);
            return UserProfile.fromJson(response.data);
        }
        on DioException catch (e)
        {
            print('Failed to fetch user profile for ID $userId: ${e.response?.data}');
            throw Exception('Failed to fetch user profile for ID $userId.');
        }
    }

    Future<List<BusinessCategory>> fetchBusinessCategories() async
    {
        const String endpointPath = '/api/v1/categories/';
        print('Fetching business categories from: $endpointPath');
        try
        {
            final response = await _dio.get(endpointPath);
            if (response.statusCode == 200)
            {
                final responseData = response.data as Map<String, dynamic>;
                if (responseData.containsKey('data') && responseData['data'] is List)
                {
                    final List<dynamic> categoryListJson = responseData['data'];
                    return categoryListJson
                        .map((json) => BusinessCategory.fromJson(json))
                        .toList();
                }
                else
                {
                    throw Exception('API response for categories is missing the "data" list.');
                }
            }
            else
            {
                throw Exception('Failed to load categories. Status code: ${response.statusCode}');
            }
        }
        on DioException catch (e)
        {
            print('Error fetching business categories: ${e.response?.data}');
            throw Exception('An error occurred while fetching business categories.');
        }
    }

    Future<UserProfile> updateUserProfile(Map<String, dynamic> profileData) async
    {
        const String endpointPath = '/auth/users/me/update/';
        print('Updating user profile with data: $profileData');
        try
        {
            final response = await _dio.patch(endpointPath, data: profileData);

            if (response.statusCode == 200)
            {
                print('User profile PATCH successful. Now fetching updated user...');
                return await fetchCurrentUser();
            }
            else
            {
                throw Exception('Failed to update profile. Status code: ${response.statusCode}');
            }
        }
        on DioException catch (e)
        {
            print('Error updating user profile: ${e.response?.data}');
            final errorDetail = (e.response?.data as Map<String, dynamic>?)?['detail'];
            throw Exception(errorDetail ?? 'An error occurred while updating the profile.');
        }
    }

    Future<UserProfile> updateUserProfilePicture(File imageFile) async
    {
        const String endpointPath = '/auth/users/me/update/';
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

            final response = await _dio.patch(endpointPath, data: formData);

            if (response.statusCode == 200)
            {
                print('Profile picture PATCH successful. Fetching updated user...');
                return await fetchCurrentUser();
            }
            else
            {
                throw Exception('Failed to update profile picture. Status code: ${response.statusCode}');
            }
        }
        on DioException catch (e)
        {
            print('Error updating profile picture: ${e.response?.data}');
            throw Exception('An error occurred while updating the profile picture.');
        }
    }

    Future<List<UserProfile>> fetchAllUsers() async
    {
        const String endpointPath = '/auth/users/';
        print('--- REPOSITORY: Fetching all users from: $endpointPath ---');
        try
        {
            final response = await _dio.get(endpointPath);

            if (response.data is Map<String, dynamic>)
            {
                final responseData = response.data as Map<String, dynamic>;
                final List<dynamic>? userListJson = responseData['data'] as List<dynamic>? ?? responseData['results'] as List<dynamic>?;
                if (userListJson != null)
                {
                    return userListJson.map((json) => UserProfile.fromJson(json as Map<String, dynamic>)).toList();
                }
            }

            print('fetchAllUsers: Warning - API response was not in the expected format.');
            return [];
        }
        on DioException catch (e)
        {
            print('Failed to fetch all users: ${e.response?.data}');
            throw Exception('Failed to fetch all users.');
        }
    }

    void dispose()
    {
        _authStateController.close();
    }
}
