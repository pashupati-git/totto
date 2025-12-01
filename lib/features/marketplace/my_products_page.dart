import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/appbar/common_app_bar.dart';
import 'package:totto/common/constants/colors.dart';
import 'package:totto/common/widgets/product_image_widget.dart';
import 'package:totto/data/models/product_model.dart';
import 'package:totto/features/marketplace/product_edit_page.dart';
import 'package:totto/features/marketplace/providers/product_providers.dart';
import 'package:totto/l10n/app_localizations.dart';

import 'add_product_page.dart';

class MyProductsPage extends ConsumerWidget
{
    const MyProductsPage({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        return Scaffold(
            backgroundColor: const Color(0xFFfafafa),
            appBar: CommonAppBar(
                leading: IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(Icons.arrow_back),
                ),
                actions: [
                    IconButton(
                        padding: const EdgeInsets.only(right: 15),
                        icon: Image.asset(
                            'assets/plus.png',
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,

                        ),
                        onPressed: ()
                        {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const AddProductPage(),
                                ),
                            );
                        },
                    )
                ],
                title: const Text('My Products'),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    _buildSearchField(),
                    _buildCategoryFilters(),
                    const Expanded(
                        child: _ProductGrid(),
                    ),
                ],
            ),
        );
    }
}

class _buildSearchField extends ConsumerStatefulWidget
{
    const _buildSearchField();

    @override
    ConsumerState<_buildSearchField> createState() => __buildSearchFieldState();
}

class __buildSearchFieldState extends ConsumerState<_buildSearchField>
{
    final _searchController = TextEditingController();

    @override
    void dispose()
    {
        _searchController.dispose();
        super.dispose();
    }

    void _performSearch()
    {
        ref.read(myProductsSearchQueryProvider.notifier).state = _searchController.text;
        FocusScope.of(context).unfocus();
    }

    @override
    Widget build(BuildContext context)
    {
        return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Row(
                children: [
                    Expanded(
                        child: TextField(
                            controller: _searchController,
                            onSubmitted: (_) => _performSearch(),
                            onChanged: (query)
                            {
                                if (query.isEmpty)
                                {
                                    _performSearch();
                                }
                            },
                            decoration: InputDecoration(
                                hintText: 'Search your products...',
                                hintStyle: TextStyle(color: Colors.grey.shade500),
                                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.red),
                                ),
                            ),
                        ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: _performSearch,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MainColors.buttonsbackgroundred,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                        ),
                        child: const Text('Search'),
                    )

                ],
            ),
        );
    }
}

class _buildCategoryFilters extends ConsumerWidget
{
    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final categoriesAsync = ref.watch(productCategoriesProvider);
        final selectedCategoryId = ref.watch(myProductsCategoryFilterProvider);

        return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const Text(
                        "Category",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    categoriesAsync.when(
                        loading: () => const SizedBox(height: 35, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                        error: (err, stack) => SizedBox(height: 35, child: Center(child: Text('Could not load categories.'))),
                        data: (categories)
                        {
                            return SizedBox(
                                height: 35,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categories.length + 1,
                                    itemBuilder: (context, index)
                                    {
                                        if (index == 0)
                                        {
                                            final isSelected = selectedCategoryId == null;
                                            return ChoiceChip(
                                                label: const Text('All'),
                                                selected: isSelected,
                                                onSelected: (_) => ref.read(myProductsCategoryFilterProvider.notifier).state = null,
                                                selectedColor: Colors.white,
                                                labelStyle: TextStyle(color: isSelected ? Colors.red : Colors.black),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                    side: BorderSide(color: isSelected ? Colors.red : Colors.grey.shade300),
                                                ),
                                                backgroundColor: Colors.white,
                                                showCheckmark: false,
                                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                            );
                                        }
                                        final category = categories[index - 1];
                                        final isSelected = category.id == selectedCategoryId;
                                        return ChoiceChip(
                                            label: Text(category.name),
                                            selected: isSelected,
                                            onSelected: (_) => ref.read(myProductsCategoryFilterProvider.notifier).state = category.id,
                                            selectedColor: Colors.white,
                                            labelStyle: TextStyle(color: isSelected ? Colors.red : Colors.black),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                side: BorderSide(color: isSelected ? Colors.red : Colors.grey.shade300),
                                            ),
                                            backgroundColor: Colors.white,
                                            showCheckmark: false,
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                        );
                                    },
                                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                                ),
                            );
                        },
                    ),
                ],
            ),
        );
    }
}

class _ProductGrid extends ConsumerWidget
{
    const _ProductGrid();

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final filteredProductsAsync = ref.watch(filteredMyProductsProvider);

        return filteredProductsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (products)
            {
                if (products.isEmpty)
                {
                    return const Center(
                        child: Text(
                            'No products found matching your criteria.',
                            textAlign: TextAlign.center,
                        ),
                    );
                }
                return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.70,
                    ),
                    itemBuilder: (context, index)
                    {
                        final product = products[index];
                        return ProductTile(product: product);
                    },
                );
            },
        );
    }
}

class ProductTile extends StatelessWidget
{
    const ProductTile({super.key, required this.product});
    final Product product;

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;

        return GestureDetector(
            onTap: ()
            {
                Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductEditPage(product: product),
                    ));
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Expanded(
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                            ),
                            child: ProductImageWidget(
                                imageUrl: product.imageUrl,
                                borderRadius: BorderRadius.circular(12),
                            ),
                        ),
                    ),

                    const SizedBox(height: 8),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                        ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            'Rs.${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                        ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                            l10n.vendorLabel(product.vendor),
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                        ),
                    ),
                ],
            ),
        );
    }
}
