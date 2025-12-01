import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/appbar/common_app_bar.dart';
import 'package:totto/common/custom_text_field.dart';
import 'package:totto/common/primary_button.dart';
import 'package:totto/data/models/business_category_model.dart';
import 'package:totto/features/chat/providers/create_group_provider.dart';
import 'package:totto/features/search/providers/search_providers.dart';
import 'package:totto/l10n/app_localizations.dart';

class CreateNewGroupPage extends ConsumerStatefulWidget
{
    const CreateNewGroupPage({super.key});

    @override
    ConsumerState<CreateNewGroupPage> createState() => _CreateNewGroupPageState();
}

class _CreateNewGroupPageState extends ConsumerState<CreateNewGroupPage>
{
    final _groupNameController = TextEditingController();
    final _rulesController = TextEditingController();
    String? _selectedTier;
    BusinessCategory? _selectedBusinessType;
    File? _groupIconFile;

    @override
    void dispose()
    {
        _groupNameController.dispose();
        _rulesController.dispose();
        super.dispose();
    }

    void _createGroup()
    {
        final l10n = AppLocalizations.of(context)!;
        if (_groupNameController.text.isEmpty || _selectedBusinessType == null)
        {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.groupCreationError)),
            );
            return;
        }

        ref.read(createGroupProvider.notifier).createGroup(
            name: _groupNameController.text,
            guidelines: _rulesController.text,
            categoryId: _selectedBusinessType!.id,
            roomType: 'F',
        );
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        ref.listen<CreateGroupState>(createGroupProvider, (previous, next)
            {
                if (next.isSuccess)
                {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.groupCreatedSuccess), backgroundColor: Colors.green),
                    );
                    Navigator.of(context).pop();
                }
                if (next.error != null)
                {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${next.error}'), backgroundColor: Colors.red),
                    );
                }
            }
        );

        final createGroupState = ref.watch(createGroupProvider);
        final businessCategoriesAsync = ref.watch(productCategoriesProvider);

        return Scaffold(
            backgroundColor: const Color(0xFFF1F2F6),
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: const Color(0xFFF1F2F6),
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(l10n.newGroupTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        _buildIconUploader(l10n),
                        const SizedBox(height: 24),

                        _buildSectionHeader(l10n.enterGroupName),
                        CustomTextField(controller: _groupNameController, hintText: l10n.enterGroupName),

                        _buildSectionHeader(l10n.groupRules),
                        TextFormField(
                            controller: _rulesController,
                            maxLines: 5,
                            decoration: InputDecoration(
                                fillColor: Colors.white, filled: true,
                                hintText: l10n.groupRulesHint,
                                border: const OutlineInputBorder(),
                            ),
                        ),

                        _buildSectionHeader(l10n.selectGroupTier),
                        _buildTierDropdown(l10n),

                        _buildSectionHeader(l10n.selectBusinessType),
                        businessCategoriesAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (err, stack) => Text(l10n.errorCouldNotLoadCategories(err.toString())),
                            data: (categories) => _buildBusinessTypeDropdown(categories, l10n),
                        ),

                        const SizedBox(height: 40),

                        PrimaryButton(
                            text: createGroupState.isLoading ? l10n.creatingGroup : l10n.createGroup,
                            onPressed: createGroupState.isLoading ? null : _createGroup,
                        ),
                        const SizedBox(height: 24),
                    ],
                ),
            ),
        );
    }

    DropdownButtonFormField<String> _buildTierDropdown(AppLocalizations l10n)
    {
        return DropdownButtonFormField<String>(
            value: _selectedTier,
            hint: Text(l10n.selectGroupTier),
            decoration: InputDecoration(
                fillColor: Colors.white, filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: [l10n.essentialTier, l10n.standardTier, l10n.premiumTier].map((item)
                {
                    return DropdownMenuItem<String>(value: item, child: Text(item));
                }
            ).toList(),
            onChanged: (val) => setState(() => _selectedTier = val),
        );
    }

    DropdownButtonFormField<BusinessCategory> _buildBusinessTypeDropdown(List<BusinessCategory> categories, AppLocalizations l10n)
    {
        return DropdownButtonFormField<BusinessCategory>(
            value: _selectedBusinessType,
            hint: Text(l10n.selectBusinessType),
            decoration: InputDecoration(
                fillColor: Colors.white, filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: categories.map((category)
                {
                    return DropdownMenuItem<BusinessCategory>(
                        value: category,
                        child: Text(category.name),
                    );
                }
            ).toList(),
            onChanged: (val) => setState(() => _selectedBusinessType = val),
        );
    }

    Widget _buildIconUploader(AppLocalizations l10n)
    {
        return Center(
            child: InkWell(
                onTap: ()
                {
                },
                child: Container(
                    width: 140,
                    height: 160,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.groups, size: 40, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(l10n.uploadIcon, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ]),
                ),
            ),
        );
    }

    Widget _buildSectionHeader(String title)
    {
        return Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        );
    }
}
