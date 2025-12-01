import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/primary_button.dart';
import 'package:totto/common/widgets/product_image_widget.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/data/models/product_model.dart';
import 'package:totto/data/models/user_profile_model.dart';
import 'package:totto/features/chat/create_chat_page.dart';
import 'package:totto/features/chat/individual_chat_page.dart';
import 'package:totto/features/chat/personal_message_page.dart';
import 'package:totto/features/chat/providers/group_provider.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:totto/features/marketplace/providers/product_providers.dart';
import 'package:totto/l10n/app_localizations.dart';
class ProductDetailPage extends ConsumerWidget
{
    const ProductDetailPage({super.key, required this.productId});
    final String productId;

    void _orderNow(BuildContext context, WidgetRef ref, Product product, AppLocalizations l10n) async
    {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.findingGroup)),
        );
        try
        {
            final allGroups = await ref.read(allGroupsProvider.future);
            final matchingGroups = allGroups.where((group)
                {
                    return group.createdBy == product.vendor && group.categoryId == product.categoryId;
                }
            ).toList();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (matchingGroups.length == 1)
            {
                final groupToJoin = matchingGroups.first;
                Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context)
                        {
                            final params = ChatConnectionParams(type: ChatType.group, id: groupToJoin.id);
                            return IndividualChatPage(group: groupToJoin, params: params);
                        }
                    ));
            }
            else if (matchingGroups.isEmpty)
            {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.noMatchingGroupFound)),
                );
            }
            else
            {
                _showGroupSelectionSheet(context, matchingGroups);
            }
        }
        catch (e)
        {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.errorFindingGroup(e.toString()))),
            );
        }
    }

    void _showGroupSelectionSheet(BuildContext context, List<Group> groups)
    {
        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context)
            {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                'Select a Group',
                                style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Flexible(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: groups.length,
                                    itemBuilder: (context, index)
                                    {
                                        final group = groups[index];
                                        return GroupListItem(group: group);
                                    },
                                ),
                            ),
                        ],
                    ),
                );
            },
        );
    }

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final l10n = AppLocalizations.of(context)!;
        final productAsyncValue = ref.watch(productDetailProvider(productId));
        return productAsyncValue.when(
            loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
            error: (err, stack) => Scaffold(
                appBar: AppBar(title: Text(l10n.productDetailErrorTitle)),
                body: Center(child: Text(l10n.failedToLoadProduct(err.toString()))),
            ),
            data: (product)
            {
                return Scaffold(
                    backgroundColor: Colors.white,
                    body: CustomScrollView(
                        slivers: [
                            _buildSliverAppBar(context, product),
                            SliverToBoxAdapter(
                                child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            _buildHeader(product, l10n),
                                            const SizedBox(height: 24),
                                            _buildActionButtons(context, product, l10n, ref),
                                            const SizedBox(height: 32),
                                            _buildDescription(product, l10n),
                                        ],
                                    ),
                                ),
                            ),
                        ],
                    ),
                );
            },
        );
    }

    SliverAppBar _buildSliverAppBar(BuildContext context, Product product)
    {
        return SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 1,
            leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                    ),
                ),
            ),
            flexibleSpace: FlexibleSpaceBar(
                background: ProductImageWidget(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    borderRadius: BorderRadius.zero,
                ),
            ),
        );
    }

    Widget _buildHeader(Product product, AppLocalizations l10n)
    {
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(l10n.vendorLabel(product.vendor), style: const TextStyle(color: Colors.grey, fontSize: 14)),
                        ]),
                ),
                const SizedBox(width: 16),
                Text('Rs.${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),
            ]);
    }

    Widget _buildActionButtons(BuildContext context, Product product, AppLocalizations l10n, WidgetRef ref)
    {
        return Row(children: [
                Expanded(
                    child: PrimaryButton(
                        text: l10n.orderNow,
                        onPressed: ()
                        {
                            _orderNow(context, ref, product, l10n);
                        },
                        borderRadius: 12.0,
                    ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: OutlinedButton.icon(
                        onPressed: ()
                        {
                            final sellerProfile = UserProfile(
                                id: product.sellerId.toString(),
                                name: product.vendor,
                                username: '',
                                profileImageUrl: '',
                                tier: '',
                                tottoPoints: 0,
                                email: '',
                                phone: '');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateChatPage(otherUser: sellerProfile),
                            ));
                        },
                        icon: const Icon(Icons.mail_outline, color: Colors.black54),
                        label: Text(l10n.chatSeller, style: const TextStyle(color: Colors.black)),
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: Colors.grey.shade300),
                        ),
                    ),
                ),
            ]);
    }

    Widget _buildDescription(Product product, AppLocalizations l10n)
    {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l10n.productDetailsOf(product.name), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(product.description, style: const TextStyle(color: Colors.black54, fontSize: 15, height: 1.5)),
            ]);
    }
}

class GroupListItem extends ConsumerWidget
{
    final Group group;
    const GroupListItem({super.key, required this.group});

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final isMember = ref.watch(isMemberOfProvider(group.id));
        final joinGroupState = ref.watch(joinGroupProvider(group.id));
        final joinGroupNotifier = ref.read(joinGroupProvider(group.id).notifier);

        ref.listen<JoinGroupState>(joinGroupProvider(group.id), (previous, next)
            {
                if (next.error != null)
                {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to join group: ${next.error}'), backgroundColor: Colors.red),
                    );
                }
            }
        );

        return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.group)),
            title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${group.memberCount} members'),
            trailing: isMember
                ? const Icon(Icons.check_circle, color: Colors.green)
                : SizedBox(
                    width: 100,
                    child: joinGroupState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : OutlinedButton(
                            onPressed: () async
                            {
                                await joinGroupNotifier.joinGroup(groupId: group.id);
                            },
                            child: const Text('Join'),
                        ),
                ),
            onTap: isMember ? ()
                {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)
                            {
                                final params = ChatConnectionParams(type: ChatType.group, id: group.id);
                                return IndividualChatPage(group: group, params: params);
                            }
                        ));
                }
                : null,
        );
    }
}
