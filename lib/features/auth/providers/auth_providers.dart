import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:totto/data/repositories/auth_repository.dart';

import 'package:totto/data/models/user_profile_model.dart';
final authRepositoryProvider = Provider<AuthRepository>((ref)
    {
        final repository = AuthRepository();
        ref.onDispose(() => repository.dispose());
        return repository;
    }
);

final authStateChangesProvider = StreamProvider<UserProfile?>((ref)
    {
        final authRepository = ref.watch(authRepositoryProvider);
        return authRepository.authStateChanges;
    }
);

final allUsersProvider = FutureProvider<List<UserProfile>>((ref)
    {
        final authRepository = ref.watch(authRepositoryProvider);
        return authRepository.fetchAllUsers();
    }
);

final userProfileProvider = FutureProvider.family<UserProfile, String>((ref, userId)
    {
        final authRepository = ref.watch(authRepositoryProvider);
        return authRepository.fetchUserProfileById(userId);
    }
);

enum ProfileUpdateState
{
    initial, loading, success, error
}

class ProfileUpdateNotifier extends StateNotifier<ProfileUpdateState>
{
    final Ref _ref;

    ProfileUpdateNotifier(this._ref) : super(ProfileUpdateState.initial);

    Future<void> uploadImage(File imageFile) async
    {
        state = ProfileUpdateState.loading;
        try
        {
            final authRepository = _ref.read(authRepositoryProvider);
            await authRepository.updateUserProfilePicture(imageFile);
            state = ProfileUpdateState.success;
        }
        catch (e)
        {
            state = ProfileUpdateState.error;
        }
        await Future.delayed(const Duration(seconds: 1));
        state = ProfileUpdateState.initial;
    }

}

final profileUpdateNotifierProvider =
    StateNotifierProvider<ProfileUpdateNotifier, ProfileUpdateState>((ref)
        {
            return ProfileUpdateNotifier(ref);
        }
    );

enum GoogleSignInState
{
    initial, loading, success, error
}

class GoogleSignInNotifier extends StateNotifier<GoogleSignInState>
{
    final AuthRepository _authRepository;

    GoogleSignInNotifier(this._authRepository) : super(GoogleSignInState.initial);

    Future<void> signInWithGoogle() async
    {
        state = GoogleSignInState.loading;
        try
        {
            await _authRepository.signInWithGoogle();
            state = GoogleSignInState.success;
        }
        catch (e)
        {
            print("GoogleSignInNotifier Error: $e");
            state = GoogleSignInState.error;
        }
    }
}

final googleSignInNotifierProvider =
    StateNotifierProvider<GoogleSignInNotifier, GoogleSignInState>((ref)
        {
            final authRepository = ref.watch(authRepositoryProvider);
            return GoogleSignInNotifier(authRepository);
        }
    );

final secureStorageProvider = Provider<FlutterSecureStorage>((ref)
    {
        return const FlutterSecureStorage();
    }
);

final authTokenProvider = FutureProvider<String?>((ref)
    {
        final storage = ref.watch(secureStorageProvider);
        return storage.read(key: 'auth_token');
    }
);

