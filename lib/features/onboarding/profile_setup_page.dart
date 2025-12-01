
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/custom_text_field.dart';
import 'package:totto/common/primary_button.dart';
import 'package:totto/common/section_header.dart';
import 'package:totto/data/models/user_profile_model.dart';
import 'package:totto/features/home/home_screen.dart';
import 'package:totto/features/onboarding/provider/profile_setup_provider.dart';

class ProfileSetupPage extends ConsumerStatefulWidget
{
    const ProfileSetupPage({super.key});

    @override
    ConsumerState<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends ConsumerState<ProfileSetupPage>
{
    late final TextEditingController _fullNameController;
    UserProfile? _editingUser;

    @override
    void initState()
    {
        super.initState();
        _fullNameController = TextEditingController();
        WidgetsBinding.instance.addPostFrameCallback((_)
            {
                final user = ModalRoute.of(context)?.settings.arguments as UserProfile?;
                final notifier = ref.read(profileSetupProvider.notifier);

                if (user != null)
                {
                    setState(()
                        {
                            _editingUser = user;
                            _fullNameController.text = user.name;
                        }
                    );

                    notifier.onFullNameChanged(user.name);
                    // Can add similar notifier calls for other pre-filled fields
                    // For example:
                    // notifier.onMemberCategoryChanged(user.memberCategory);
                    // notifier.onTradingFrequencyChanged(user.tradingFrequency);
                    // notifier.onBusinessCategoryChanged(user.businessCategory);
                }
            }
        );
    }

    @override
    void dispose()
    {
        _fullNameController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        final state = ref.watch(profileSetupProvider);
        final notifier = ref.read(profileSetupProvider.notifier);

        ref.listen(profileSetupProvider, (previous, next)
            {
                if (next.errorMessage != null && (previous?.errorMessage != next.errorMessage))
                {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(next.errorMessage!),
                            backgroundColor: Colors.red,
                        ),
                    );
                }
            }
        );

        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text(_editingUser == null ? 'User Profile Setup' : 'Update Profile'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 1,
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const SectionHeader(title: 'Full Name*'),
                        CustomTextField(
                            controller: _fullNameController,
                            hintText: 'Full Name',
                            onChanged: notifier.onFullNameChanged,
                        ),

                        const SectionHeader(title: 'Choose Member Category*'),
                        DropdownButtonFormField<String>(
                            value: state.memberCategory,
                            hint: const Text('Choose Member Category*'),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            items: ['Buyer', 'Seller(Vendor)', 'Both'].map((String category)
                                {
                                    return DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(category),
                                    );
                                }
                            ).toList(),
                            onChanged: notifier.onMemberCategoryChanged,
                        ),

                        const SectionHeader(title: 'Business/Product Category'),
                        state.businessCategories.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (e, s) => Center(child: Text('Could not load categories: $e')),
                            data: (categories)
                            {
                                return Container(
                                    width: double.infinity,
                                    child: Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        alignment: WrapAlignment.start,
                                        children: categories.map((category)
                                            {
                                                final isSelected = state.selectedBusinessCategory?.id == category.id;
                                                return ChoiceChip(
                                                    label: Text(category.name),
                                                    labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces tap area size

                                                    selected: isSelected,
                                                    onSelected: (selected)
                                                    {
                                                        if (selected)
                                                        {
                                                            notifier.onBusinessCategoryChanged(category);
                                                        }
                                                    },
                                                    selectedColor: const Color(0xFFDC143C).withOpacity(0.1),
                                                    checkmarkColor: const Color(0xFFDC143C),
                                                    labelStyle: TextStyle(
                                                        color: isSelected ? const Color(0xFFDC143C) : Colors.black54,
                                                    ),
                                                );
                                            }
                                        ).toList(),
                                    ),
                                );
                            },
                        ),

                        const SectionHeader(title: 'How often do you trade?'),
                        DropdownButtonFormField<String>(
                            value: state.tradingFrequency,
                            hint: const Text('Trading Frequency'),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            items: ['Frequently / Daily', 'Occasionally', 'Monthly'].map((String frequency)
                                {
                                    return DropdownMenuItem<String>(
                                        value: frequency,
                                        child: Text(frequency),
                                    );
                                }
                            ).toList(),
                            onChanged: notifier.onTradingFrequencyChanged,
                        ),

                        const SizedBox(height: 40),

                        PrimaryButton(
                            text: _editingUser == null ? 'Continue to Home' : 'Save Changes',
                            isLoading: state.isLoading,
                            onPressed: state.isFormValid ? () async
                                {

                                    final success = await notifier.submitProfile();
                                    if (success && context.mounted)
                                    {
                                        if (_editingUser != null)
                                        {
                                            Navigator.of(context).pop();
                                        }
                                        else
                                        {
                                            Navigator.of(context).pushAndRemoveUntil(
                                                MaterialPageRoute(builder: (context) => const HomeScreen()),
                                                (Route<dynamic> route) => false,
                                            );
                                        }
                                    }
                                }
                                : null,
                        ),

                        const SizedBox(height: 12),

                    ],
                ),
            ),
        );
    }
}
