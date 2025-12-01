import 'package:flutter/foundation.dart';

@immutable
class SearchFilterState
{
    final String searchTerm;
    final String? minPrice;
    final String? maxPrice;
    final Set<String> selectedCategories;
    final String selectedTab;

    const SearchFilterState({
        this.searchTerm = '',
        this.minPrice,
        this.maxPrice,
        this.selectedCategories = const {},
        this.selectedTab = 'All',
    });

    SearchFilterState copyWith({
        String? searchTerm,
        String? minPrice,
        String? maxPrice,
        Set<String>? selectedCategories,
        String? selectedTab,
    })
    {
        return SearchFilterState(
            searchTerm: searchTerm ?? this.searchTerm,
            minPrice: minPrice ?? this.minPrice,
            maxPrice: maxPrice ?? this.maxPrice,
            selectedCategories: selectedCategories ?? this.selectedCategories,
            selectedTab: selectedTab ?? this.selectedTab,
        );
    }
}
