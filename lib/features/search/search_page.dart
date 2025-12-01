import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/common_search_bar.dart';
import 'package:totto/common/custom_text_field.dart';
import 'package:totto/common/primary_button.dart';
import 'package:totto/features/chat/create_chat_page.dart';
import 'package:totto/features/chat/essential_tier_page.dart';
import 'package:totto/features/chat/individual_chat_page.dart';
import 'package:totto/features/chat/personal_message_page.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:totto/features/marketplace/product_detail_page.dart';
import 'package:totto/features/search/model/search_result_item.dart';
import 'package:totto/features/search/providers/search_providers.dart';
import 'package:totto/l10n/app_localizations.dart';

class SearchPage extends ConsumerStatefulWidget
{
    const SearchPage({super.key});

    @override
    ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
{
    bool _isShowingResults = false;

    final _searchBarController = TextEditingController();
    final _minPriceController = TextEditingController();
    final _maxPriceController = TextEditingController();

    @override
    void dispose()
    {
        _searchBarController.dispose();
        _minPriceController.dispose();
        _maxPriceController.dispose();
        super.dispose();
    }

    void _clearAllAndShowFilters()
    {
        ref.read(searchFilterProvider.notifier).clearFilters();
        _searchBarController.clear();
        _minPriceController.clear();
        _maxPriceController.clear();
        if (_isShowingResults)
        {
            setState(()
                {
                    _isShowingResults = false;
                }
            );
        }
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        final filterNotifier = ref.read(searchFilterProvider.notifier);

        return WillPopScope(
            onWillPop: () async
            {
                if (_isShowingResults)
                {
                    _clearAllAndShowFilters();
                    return false;
                }
                return true;
            },
            child: DefaultTabController(
                length: 4,
                child: Scaffold(
                    backgroundColor: const Color(0xFFF1F2F6),
                    appBar: AppBar(
                        backgroundColor: const Color(0xFFF1F2F6),
                        elevation: 0,
                        leading: IconButton(
                            onPressed: ()
                            {
                                if (_isShowingResults)
                                {
                                    _clearAllAndShowFilters();
                                }
                                else
                                {
                                    Navigator.of(context).pop();
                                }
                            },
                            icon: const Icon(Icons.arrow_back),
                        ),
                        title: Text(l10n.searchTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        centerTitle: true,
                        automaticallyImplyLeading: false,
                    ),
                    body: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                CommonSearchBar(
                                    controller: _searchBarController,
                                    onChanged: filterNotifier.updateSearchTerm,
                                ),
                                const SizedBox(height: 16),
                                TabBar(
                                    isScrollable: true,
                                    indicatorColor: Colors.red,
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.grey,
                                    onTap: (index)
                                    {
                                        const tabs = ['All', 'Group', 'Product', 'People'];
                                        filterNotifier.selectTab(tabs[index]);
                                    },
                                    tabs: [
                                        Tab(text: l10n.tabAll), Tab(text: l10n.tabGroup),
                                        Tab(text: l10n.tabProduct), Tab(text: l10n.tabPeople),
                                    ],
                                ),
                                const SizedBox(height: 24),
                                if (_isShowingResults)
                                _buildSearchResults(ref, l10n)
                                else
                                _buildFilterSection(l10n, filterNotifier),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }

    Widget _buildFilterSection(AppLocalizations l10n, SearchFilterNotifier filterNotifier)
    {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                _buildSectionHeader(l10n.location),
                CustomTextField(hintText: l10n.entireNepal),
                _buildSectionHeader(l10n.priceRange),
                _buildPriceRange(filterNotifier, l10n),
                _buildSectionHeader(l10n.category),
                _buildCategoryChips(ref),
                const SizedBox(height: 40),
                Row(
                    children: [
                        Expanded(
                            child: PrimaryButton(
                                text: l10n.searchTitle,
                                onPressed: ()
                                {
                                    setState(()
                                        {
                                            _isShowingResults = true;
                                        }
                                    );
                                },
                            ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                            onPressed: _clearAllAndShowFilters,
                            child: const Text('Clear'),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                            ),
                        ),
                    ],
                ),
                const SizedBox(height: 24),
            ],
        );
    }

    Widget _buildSearchResults(WidgetRef ref, AppLocalizations l10n)
    {
        final searchResults = ref.watch(searchResultsProvider);
        final selectedTab = ref.watch(searchFilterProvider).selectedTab;

        return searchResults.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text(l10n.errorOccurred(err.toString()))),
            data: (results)
            {
                final filteredResults = results.where((item)
                    {
                        if (selectedTab == 'All') return true;
                        if (selectedTab == 'Product' && item is ProductSearchResult) return true;
                        if (selectedTab == 'Group' && item is GroupSearchResult) return true;
                        if (selectedTab == 'People' && item is UserSearchResult) return true;
                        return false;
                    }
                ).toList();

                if (filteredResults.isEmpty)
                {
                    return const Center(child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text("No results found."),
                        ));
                }

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        _buildSectionHeader(l10n.results(filteredResults.length.toString())),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredResults.length,
                            itemBuilder: (context, index)
                            {
                                final item = filteredResults[index];
                                if (item is ProductSearchResult) return _buildProductTile(context, item);
                                if (item is GroupSearchResult) return _buildGroupTile(context, item);
                                if (item is UserSearchResult) return _buildUserTile(context, item);
                                return const SizedBox.shrink();
                            },
                        ),
                    ],
                );
            },
        );
    }

    Widget _buildSectionHeader(String title)
    {
        return Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        );
    }

    Widget _buildPriceRange(SearchFilterNotifier notifier, AppLocalizations l10n)
    {
        return Row(
            children: [
                Expanded(
                    child: TextFormField(
                        controller: _minPriceController,
                        onChanged: notifier.updateMinPrice,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            prefixText: 'Rs. ',
                            hintText: '10.00',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                    ),
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0), child: Text(l10n.priceRangeTo)),
                Expanded(
                    child: TextFormField(
                        controller: _maxPriceController,
                        onChanged: notifier.updateMaxPrice,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            prefixText: 'Rs. ',
                            hintText: '10.00',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                    ),
                ),
            ],
        );
    }

    Widget _buildCategoryChips(WidgetRef ref)
    {
        final filterState = ref.watch(searchFilterProvider);
        final filterNotifier = ref.read(searchFilterProvider.notifier);
        final categoriesAsync = ref.watch(productCategoriesProvider);

        return categoriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: An error occurred while fetching product categories.')),
            data: (categories)
            {
                return Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.start,
                    children: categories.map((category)
                        {
                            final bool isSelected = filterState.selectedCategories.contains(category.name);
                            return FilterChip(
                                label: Text(category.name),
                                selected: isSelected,
                                onSelected: (_) => filterNotifier.toggleCategory(category.name),
                                backgroundColor: Colors.white,
                                selectedColor: Colors.red.withOpacity(0.1),
                                checkmarkColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(color: isSelected ? Colors.red : Colors.grey.shade300),
                                ),
                            );
                        }
                    ).toList(),
                );
            },
        );
    }

    Widget _buildTypeChip(String label)
    {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
                label,
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                ),
            ),
        );
    }

    Widget _buildProductTile(BuildContext context, ProductSearchResult item)
    {
        final product = item.product;
        return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
                leading: (product.imageUrl.isNotEmpty)
                    ? Image.network(product.imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                    : Container(width: 60, height: 60, color: Colors.grey[200], child: const Icon(Icons.shopping_bag_outlined)),
                title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Rs. ${product.price}'),
                trailing: _buildTypeChip('Product'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDetailPage(productId: product.id),
                    )),
            ),
        );
    }

    Widget _buildGroupTile(BuildContext context, GroupSearchResult item)
    {
        final group = item.group;
        return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.group)),
                title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${group.memberCount} members'),
                trailing: _buildTypeChip('Group'),
                onTap: ()
                {
                    if (item.isJoined)
                    {
                        Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)
                                {
                                    final params = ChatConnectionParams(type: ChatType.group, id: group.id);
                                    return IndividualChatPage(group: group, params: params);
                                },
                            ));
                    }
                    else
                    {
                        Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const EssentialTierPage(),
                            ));
                    }
                },
            ),
        );
    }

    Widget _buildUserTile(BuildContext context, UserSearchResult item)
    {
        final user = item.user;
        return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
                leading: CircleAvatar(
                    backgroundImage: user.profileImageUrl.isNotEmpty ? NetworkImage(user.profileImageUrl) : null,
                    child: user.profileImageUrl.isEmpty ? const Icon(Icons.person) : null,
                ),
                title: Text(user.name),
                subtitle: Text('@${user.username}'),
                trailing: _buildTypeChip('People'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateChatPage(otherUser: user),
                )),
            ),
        );
    }
}
