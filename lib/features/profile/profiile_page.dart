import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:totto/common/appbar/common_app_bar.dart';
import 'package:totto/common/constants/colors.dart';
import 'package:totto/data/models/user_profile_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/home/home_screen.dart';
import 'package:totto/features/order/order_page.dart';
import 'package:totto/features/profile/app_settings_page.dart';
import 'package:totto/features/profile/kyc_form_page.dart';
import 'package:totto/features/profile/privacy_policy_page.dart';
import 'package:totto/features/profile/providers/kyc_provider.dart';
import 'package:totto/features/profile/terms_and_condition_page.dart';
import 'package:totto/features/profile/visibility_settings_page.dart';
import 'package:totto/l10n/app_localizations.dart';

import '../auth/auth_gate.dart';
import '../marketplace/my_products_page.dart';
import '../onboarding/profile_setup_page.dart';

class ProfilePage extends ConsumerWidget
{
    const ProfilePage({super.key});

    void _showProfileOptionsDialog(BuildContext context, WidgetRef ref, UserProfile currentUser)
    {
        final l10n = AppLocalizations.of(context)!;
        showDialog(
            context: context,
            builder: (BuildContext dialogContext)
            {
                return AlertDialog(
                    title: Text(l10n.updateProfile),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            ListTile(
                                leading: const Icon(Icons.edit_note),
                                title: Text(l10n.changeUserDetails),
                                onTap: ()
                                {
                                    Navigator.of(dialogContext).pop();
                                    Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => const ProfileSetupPage(),
                                            settings: RouteSettings(
                                                arguments: currentUser,
                                            ),
                                        ));
                                },
                            ),
                            ListTile(
                                leading: const Icon(Icons.camera_alt_outlined),
                                title: Text(l10n.changeAvatar),
                                onTap: ()
                                {
                                    Navigator.of(dialogContext).pop();
                                    _pickAndUploadImage(context, ref);
                                },
                            ),
                        ],
                    ),
                );
            },
        );
    }

    Future<void> _pickAndUploadImage(BuildContext context, WidgetRef ref) async
    {
        try
        {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

            if (image != null)
            {
                final imageFile = File(image.path);
                await ref.read(profileUpdateNotifierProvider.notifier).uploadImage(imageFile);
            }
        }
        catch (e)
        {
            if (context.mounted)
            {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to pick image: $e'), backgroundColor: Colors.red),
                );
            }
        }
    }

    void _onKycButtonPressed(BuildContext context, WidgetRef ref) async
    {
        final l10n = AppLocalizations.of(context)!;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        try
        {
            final kycModel = await ref.refresh(kycStatusProvider.future);

            Navigator.of(context, rootNavigator: true).pop();

            if (kycModel == null || kycModel.isRejected)
            {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const KycPageGate()));
            }
            else if (kycModel.isPending)
            {
                _showKycInfoDialog(
                    context,
                    title: l10n.kycSubmittedTitle,
                    content: l10n.kycSubmittedContent,
                );
            }
            else if (kycModel.isVerified)
            {
                _showKycInfoDialog(
                    context,
                    title: l10n.kycVerifiedTitle,
                    content: l10n.kycVerifiedContent,
                );
            }
        }
        catch (e)
        {
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.errorFetchingKyc(e.toString())), backgroundColor: Colors.red),
            );
        }
    }

    void _showKycInfoDialog(BuildContext context, {required String title, required String content})
    {
        final l10n = AppLocalizations.of(context)!;
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                    TextButton(
                        child: Text(l10n.okButton),
                        onPressed: () => Navigator.of(context).pop(),
                    ),
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final l10n = AppLocalizations.of(context)!;
        final authState = ref.watch(authStateChangesProvider);

        ref.listen<ProfileUpdateState>(profileUpdateNotifierProvider, (previous, next)
            {
                if (next == ProfileUpdateState.loading)
                {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(child: CircularProgressIndicator()),
                    );
                }
                else if (next == ProfileUpdateState.success)
                {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.avatarUpdatedSuccess), backgroundColor: Colors.green),
                    );
                }
                else if (next == ProfileUpdateState.error)
                {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.avatarUpdateFailed), backgroundColor: Colors.red),
                    );
                }
            }
        );

        ref.listen<AsyncValue<UserProfile?>>(authStateChangesProvider, (previous, next)
            {
                final wasLoggedIn = previous?.valueOrNull != null;
                final isLoggedOut = next.valueOrNull == null && next is AsyncData;

                if (wasLoggedIn && isLoggedOut)
                {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const AuthGate()),
                        (route) => false,
                    );
                }
            }
        );

        return Scaffold(
            backgroundColor: MainColors.appbackground,
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: MainColors.appbarbackground,
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                    ),
                ),
                title: Text(
                    l10n.profilePageTitle,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                actions: const[SizedBox(width: 56)],
            ),
            body: authState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text(l10n.errorLoadingProfile(err.toString()))),
                data: (user)
                {
                    if (user == null)
                    {
                        return Center(child: Text(l10n.userNotLoggedIn));
                    }
                    return SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                                children: [
                                    _buildProfileHeader(user, context, ref),
                                    const SizedBox(height: 24),
                                    _buildMenuGroup(context, [
                                            _buildProfileMenuItem(
                                                icon: const ImageIcon(AssetImage('assets/logos/Order.png'), color: Colors.black54),
                                                title: l10n.myOrders,
                                                subtitle: l10n.myOrdersSubtitle,
                                                onTap: ()
                                                {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => const OrderPage(),
                                                        ));
                                                },
                                            ),
                                            _buildProfileMenuItem(
                                                icon: const ImageIcon(AssetImage('assets/visibility.png')),
                                                title: l10n.profileVisibility,
                                                subtitle: l10n.profileVisibilitySubtitle,
                                                onTap: ()
                                                {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => const ProfileVisibilityPage(),
                                                        ));
                                                },
                                            ),
                                            _buildProfileMenuItem(
                                                icon: const ImageIcon(AssetImage('assets/specialitem.png')),
                                                title: l10n.mySpecialItemTitle,
                                                subtitle: l10n.mySpecialItemSubtitle,
                                                onTap: ()
                                                {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => const MyProductsPage(),
                                                        ));
                                                },
                                            ),
                                            _buildProfileMenuItem(
                                                icon: const ImageIcon(AssetImage('assets/kycdetail.png')),
                                                title: l10n.kycDetails,
                                                subtitle: l10n.kycDetailsSubtitle,
                                                onTap: () => _onKycButtonPressed(context, ref),
                                            ),
                                            _buildProfileMenuItem(
                                                icon: const ImageIcon(AssetImage('assets/appsettings.png')),
                                                title: l10n.appSettings,
                                                subtitle: l10n.appSettingsSubtitle,
                                                onTap: ()
                                                {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => const AppSettingsPage(),
                                                        ));
                                                },
                                            ),
                                        ]),
                                    const SizedBox(height: 16),
                                    _buildMenuGroup(context, [
                                            _buildProfileMenuItem(
                                                icon: const ImageIcon(AssetImage('assets/T&C.png')),
                                                title: l10n.termsAndConditions,
                                                subtitle: l10n.usagePolicySubtitle,
                                                onTap: ()
                                                {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => const TermsAndConditionsPage(),
                                                        ));
                                                },
                                            ),
                                            _buildProfileMenuItem(
                                                icon: const ImageIcon(AssetImage('assets/PP.png')),
                                                title: l10n.privacyPolicy,
                                                subtitle: l10n.dataUseInfoSubtitle,
                                                onTap: ()
                                                {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => const PrivacyPolicyPage(),
                                                        ));
                                                },
                                            ),
                                        ]),
                                    const SizedBox(height: 16),
                                    _buildMenuGroup(context, [
                                            _buildProfileMenuItem(
                                                icon: const Icon(Icons.logout, color: Colors.red),
                                                title: l10n.logout,
                                                onTap: () async
                                                {
                                                    final shouldLogout = await showDialog<bool>(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                            title: Text(l10n.logoutConfirmationTitle),
                                                            content: Text(l10n.logoutConfirmationBody),
                                                            actions: [
                                                                TextButton(
                                                                    onPressed: () => Navigator.pop(context, false),
                                                                    child: Text(l10n.cancel),
                                                                ),
                                                                TextButton(
                                                                    onPressed: () => Navigator.pop(context, true),
                                                                    child: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
                                                                ),
                                                            ],
                                                        ),
                                                    );

                                                    if (shouldLogout == true)
                                                    {
                                                        await ref.read(authRepositoryProvider).logout();
                                                    }
                                                },
                                                textColor: Colors.red,
                                                isLogout: true,
                                            ),
                                        ]),
                                    const SizedBox(height: 24),
                                ],
                            ),
                        ),
                    );
                },
            ),
        );
    }

    Widget _buildProfileHeader(UserProfile user, BuildContext context, WidgetRef ref)
    {
        final l10n = AppLocalizations.of(context)!;
        final imageUrl = user.profileImageUrl;

        return Column(
            children: [
                const SizedBox(height: 24),
                SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                            CustomPaint(
                                painter: ArcPainter(
                                    progress: 0.75,
                                    gradient: const SweepGradient(
                                        startAngle: -pi / 2,
                                        endAngle: pi * 1.5,
                                        colors: [Colors.red, Colors.pinkAccent],
                                    ),
                                ),
                            ),
                            Center(
                                child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () => _showProfileOptionsDialog(context, ref, user),
                                    child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.grey.shade300,
                                        backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                                        child: imageUrl.isEmpty ? const Icon(Icons.person, size: 60, color: Colors.white70) : null,
                                    ),
                                ),
                            ),
                            Positioned(
                                bottom: 10,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                        user.tier,
                                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                ),
                            ),
                            Positioned(
                                bottom: 15,
                                right: -5,
                                child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () => _showProfileOptionsDialog(context, ref, user),
                                    child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                        ),
                                        child: const Icon(Icons.edit, color: Colors.black54, size: 16),
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
                const SizedBox(height: 16),
                Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(user.username, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 24),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(l10n.tottoPointsTitle, style: const TextStyle(color: MainColors.buttonsbackgroundred, fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 2),
                                    Text(l10n.learnMore, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                            ),
                            Row(
                                children: [
                                    const Icon(Icons.emoji_events, color: Colors.black87),
                                    const SizedBox(width: 8),
                                    Text(user.tottoPoints.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                            ),
                        ],
                    ),
                ),
            ],
        );
    }

    Widget _buildMenuGroup(BuildContext context, List<Widget> items)
    {
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) => items[index],
                separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    indent: 56,
                    endIndent: 16,
                ),
            ),
        );
    }

    Widget _buildProfileMenuItem({
        required Widget icon,
        required String title,
        String? subtitle,
        required VoidCallback onTap,
        Color textColor = Colors.black,
        bool isLogout = false,
    })
    {
        return ListTile(
            onTap: onTap,
            leading: icon,
            title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
            subtitle: subtitle != null
                ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12))
                : null,
            trailing: isLogout
                ? null
                : const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        );
    }
}

class ArcPainter extends CustomPainter
{
    final double progress;
    final Gradient gradient;

    ArcPainter({required this.progress, required this.gradient});

    @override
    void paint(Canvas canvas, Size size)
    {
        const double strokeWidth = 10.0;
        final Rect rect = Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth);
        final Paint backgroundPaint = Paint()
            ..color = Colors.grey.shade200
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round;

        final Paint foregroundPaint = Paint()
            ..shader = gradient.createShader(rect)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round;

        canvas.drawArc(rect, -pi / 2, 2 * pi, false, backgroundPaint);
        canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, foregroundPaint);
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate)
    {
        return true;
    }
}
