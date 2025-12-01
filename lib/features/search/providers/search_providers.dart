
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/data/models/business_category_model.dart';
import 'package:totto/data/models/user_profile_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/providers/group_provider.dart';
import 'package:totto/features/marketplace/providers/product_providers.dart';
import 'package:totto/features/search/model/search_result_item.dart';

import 'search_filter_state.dart';

final productCategoriesProvider = FutureProvider.autoDispose<List<BusinessCategory>>((ref)
    {
        final repository = ref.watch(productRepositoryProvider);
        return repository.fetchProductCategories();
    }
);

final allUsersProvider = FutureProvider.autoDispose<List<UserProfile>>((ref)
    {
        final authRepository = ref.watch(authRepositoryProvider);
        return authRepository.fetchAllUsers();
    }
);

class SearchFilterNotifier extends StateNotifier<SearchFilterState>
{
    SearchFilterNotifier() : super(const SearchFilterState());

    void updateSearchTerm(String term) => state = state.copyWith(searchTerm: term);
    void updateMinPrice(String price) => state = state.copyWith(minPrice: price);
    void updateMaxPrice(String price) => state = state.copyWith(maxPrice: price);
    void selectTab(String tab) => state = state.copyWith(selectedTab: tab);

    void toggleCategory(String category)
    {
        final newCategories = Set<String>.from(state.selectedCategories);
        if (newCategories.contains(category))
        {
            newCategories.remove(category);
        }
        else
        {
            newCategories.add(category);
        }
        state = state.copyWith(selectedCategories: newCategories);
    }

    void clearFilters()
    {
        state = const SearchFilterState();
    }
}

final searchFilterProvider =
    StateNotifierProvider.autoDispose<SearchFilterNotifier, SearchFilterState>((ref)
        {
            return SearchFilterNotifier();
        }
    );

final searchResultsProvider = FutureProvider.autoDispose<List<SearchResultItem>>((ref) async
    {
        final filters = ref.watch(searchFilterProvider);
        final searchTerm = filters.searchTerm.toLowerCase();
        final selectedCategories = filters.selectedCategories;

        final minPrice = filters.minPrice != null && filters.minPrice!.isNotEmpty ? double.tryParse(filters.minPrice!) : null;
        final maxPrice = filters.maxPrice != null && filters.maxPrice!.isNotEmpty ? double.tryParse(filters.maxPrice!) : null;

        final bool hasActiveFilters = searchTerm.isNotEmpty ||
            selectedCategories.isNotEmpty ||
            minPrice != null ||
            maxPrice != null;

        if (!hasActiveFilters)
        {
            return [];
        }

        final products = await ref.watch(marketplaceProductsProvider.future);
        final allGroups = await ref.watch(allGroupsProvider.future);
        final users = await ref.watch(allUsersProvider.future);
        final myGroups = await ref.watch(myGroupsProvider.future);

        final List<SearchResultItem> allResults = [];

        allResults.addAll(products.where((p)
                {
                    final nameMatch = searchTerm.isEmpty || p.name.toLowerCase().contains(searchTerm);
                    final categoryMatch = selectedCategories.isEmpty || selectedCategories.contains(p.categoryName);
                    final price = p.price;
                    final minPriceMatch = minPrice == null || price >= minPrice;
                    final maxPriceMatch = maxPrice == null || price <= maxPrice;
                    return nameMatch && categoryMatch && minPriceMatch && maxPriceMatch;
                }
            ).map((p) => ProductSearchResult(p)));

        allResults.addAll(allGroups.where((g)
                {
                    return searchTerm.isEmpty || g.name.toLowerCase().contains(searchTerm);
                }
            ).map((g)
                    {
                        final isJoined = myGroups.any((jg) => jg.id == g.id);
                        return GroupSearchResult(g, isJoined: isJoined);
                    }
                ));

        allResults.addAll(users.where((u)
                {
                    if (searchTerm.isEmpty) return false;
                    final nameMatch = u.name.toLowerCase().contains(searchTerm);
                    final usernameMatch = u.username.toLowerCase().contains(searchTerm);
                    return nameMatch || usernameMatch;
                }
            ).map((u) => UserSearchResult(u)));

        return allResults;
    }
);
