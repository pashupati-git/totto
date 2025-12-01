import '../../config/app_config.dart';

class UserProfile
{
    final String id;
    final String name;
    final String username;
    final String profileImageUrl;
    final String tier;
    final int tottoPoints;
    final String email;
    final String phone;

    const UserProfile({
        required this.id,
        required this.name,
        required this.username,
        required this.profileImageUrl,
        required this.tier,
        required this.tottoPoints,
        required this.email,
        required this.phone,
    });

    bool get isProfileComplete => name.isNotEmpty && name != 'No Name';

    factory UserProfile.empty() {
        return const UserProfile(
            id: '0',
            name: '',
            username: '',
            profileImageUrl: '',
            tier: '',
            tottoPoints: 0,
            email: '',
            phone: '',
        );
    }

    factory UserProfile.fromJson(Map<String, dynamic> json)
    {
        String imageUrl = json['image'] as String? ?? '';
        if (imageUrl.isNotEmpty && !imageUrl.startsWith('http'))
        {
            imageUrl = '${ApiConfig.baseUrl}$imageUrl';
        }

        String idStr = '';
        if (json['id'] != null)
        {
            idStr = json['id'].toString();
        }

        return UserProfile(
            id: idStr,
            name: json['full_name'] as String? ?? '',
            username: json['username'] as String? ?? '@username',
            email: json['email'] as String? ?? '',
            phone: json['phone'] as String? ?? '',
            profileImageUrl: imageUrl,
            tier: 'Tier 01',
            tottoPoints: 0,
        );
    }
}
