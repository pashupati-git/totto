import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/appbar/common_app_bar.dart';
import 'package:totto/common/common_search_bar.dart';
import 'package:totto/common/constants/colors.dart';
import 'package:totto/common/widgets/product_image_widget.dart';
import 'package:totto/data/models/business_category_model.dart';
import 'package:totto/data/models/product_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/home/home_screen.dart';
import 'package:totto/features/marketplace/add_product_page.dart';
import 'package:totto/features/marketplace/product_detail_page.dart';
import 'package:totto/features/marketplace/providers/product_providers.dart';
import 'package:totto/features/search/search_page.dart';
import 'package:totto/l10n/app_localizations.dart';

final businessCategoriesProvider = FutureProvider<List<BusinessCategory>>((ref)
    {
        final authRepository = ref.watch(authRepositoryProvider);
        return authRepository.fetchBusinessCategories();
    }
);

final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final filteredMarketplaceProductsProvider = Provider<List<Product>>((ref)
    {
        final productsAsync = ref.watch(marketplaceProductsProvider);
        final selectedCategoryName = ref.watch(selectedCategoryProvider);

        if (!productsAsync.hasValue)
        {
            return [];
        }

        final products = productsAsync.value!;

        if (selectedCategoryName == null)
        {
            return products;
        }

        return products.where((product) => product.categoryName == selectedCategoryName).toList();
    }
);

class MarketplacePage extends ConsumerWidget
{
    const MarketplacePage({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final l10n = AppLocalizations.of(context)!;
        final productsAsyncValue = ref.watch(marketplaceProductsProvider);
        final filteredProducts = ref.watch(filteredMarketplaceProductsProvider);

        return Scaffold(
            backgroundColor: const Color(0xFFfafafa),
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: MainColors.appbarbackground,
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: ()
                    {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                    },
                ),
                actions: [
                    IconButton(
                        icon: Image.asset(
                            'assets/plus.png',
                            width: 30,
                            height: 30,
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
                title: Text(
                    l10n.marketplaceTitle,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    _buildSearchTapable(context),
                    _buildCategoryFilters(context, ref),

                    Expanded(
                        child: productsAsyncValue.when(
                            data: (products)
                            {
                                if (products.isNotEmpty && filteredProducts.isEmpty)
                                {
                                    return Center(child: Text(l10n.noProductsFound));
                                }
                                return GridView.builder(
                                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                    itemCount: filteredProducts.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 0.70,
                                    ),
                                    itemBuilder: (context, index)
                                    {
                                        final product = filteredProducts[index];
                                        return ProductTile(product: product);
                                    },
                                );
                            },
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, stack) =>
                            Center(child: Text(l10n.failedToLoadProducts(error.toString()))),
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildSearchTapable(BuildContext context)
    {
        return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchPage())),
                child: AbsorbPointer(
                    child: CommonSearchBar(
                        readOnly: true,
                    ),
                ),
            ),
        );
    }

    Widget _buildCategoryFilters(BuildContext context, WidgetRef ref)
    {
        final categoriesAsync = ref.watch(businessCategoriesProvider);
        final selectedCategoryName = ref.watch(selectedCategoryProvider);

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
                                            final isSelected = selectedCategoryName == null;
                                            return ChoiceChip(
                                                label: const Text('All'),
                                                selected: isSelected,
                                                onSelected: (_) => ref.read(selectedCategoryProvider.notifier).state = null,
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
                                        final isSelected = category.name == selectedCategoryName;
                                        return ChoiceChip(
                                            label: Text(category.name),
                                            selected: isSelected,
                                            onSelected: (_) => ref.read(selectedCategoryProvider.notifier).state = category.name,
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
                        builder: (context) => ProductDetailPage(productId: product.id),
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
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ProductImageWidget(
                                    imageUrl: product.imageUrl,
                                    borderRadius: BorderRadius.circular(12),
                                ),
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
