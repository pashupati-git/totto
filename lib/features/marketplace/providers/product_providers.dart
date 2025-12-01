// import 'dart:io';
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:totto/data/models/business_category_model.dart';
// import 'package:totto/data/models/product_model.dart';
// import 'package:totto/data/models/unit_model.dart';
// import 'package:totto/data/repositories/product_repository.dart';
// import 'package:totto/data/repositories/unit_repository.dart';
//
// final productRepositoryProvider = Provider<ProductRepository>((ref)
//     {
//         return ProductRepository();
//     }
// );
//
// final unitRepositoryProvider = Provider<UnitRepository>((ref)
//     {
//         return UnitRepository();
//     }
// );
//
// final myProductsProvider = FutureProvider.autoDispose<List<Product>>((ref)
//     {
//         print('--- PROVIDER: myProductsProvider is executing ---');
//         final productRepository = ref.watch(productRepositoryProvider);
//         return productRepository.fetchMyProducts();
//     }
// );
//
// final marketplaceProductsProvider = FutureProvider<List<Product>>((ref)
//     {
//         print('--- PROVIDER: marketplaceProductsProvider is executing ---');
//         final productRepository = ref.watch(productRepositoryProvider);
//         return productRepository.fetchProducts();
//     }
// );
//
// final productDetailProvider = FutureProvider.family<Product, String>((ref, productId)
//     {
//         print('--- PROVIDER: productDetailProvider is executing for ID: $productId ---');
//         final productRepository = ref.watch(productRepositoryProvider);
//         return productRepository.fetchProductById(productId);
//     }
// );
//
// final productCategoriesProvider = FutureProvider<List<BusinessCategory>>((ref)
//     {
//         print('--- PROVIDER: productCategoriesProvider is executing ---');
//         final productRepository = ref.watch(productRepositoryProvider);
//         return productRepository.fetchProductCategories();
//     }
// );
//
// final unitsProvider = FutureProvider<List<Unit>>((ref)
//     {
//         print('--- PROVIDER: unitsProvider is executing ---');
//         final unitRepository = ref.watch(unitRepositoryProvider);
//         return unitRepository.fetchUnits();
//     }
// );
//
// enum ProductSubmitStateValue
// {
//     initial, loading, success, error
// }
//
// class ProductSubmitState
// {
//     final ProductSubmitStateValue value;
//     final String? errorMessage;
//     const ProductSubmitState({this.value = ProductSubmitStateValue.initial, this.errorMessage});
// }
//
// class ProductSubmitNotifier extends StateNotifier<ProductSubmitState>
// {
//     final Ref _ref;
//     ProductSubmitNotifier(this._ref) : super(const ProductSubmitState());
//
//     Future<void> createProduct({
//         required String name,
//         required String description,
//         required String price,
//         required int unitId,
//         required int categoryId,
//         File? image,
//     }) async
//     {
//         state = const ProductSubmitState(value: ProductSubmitStateValue.loading);
//         try
//         {
//             await _ref.read(productRepositoryProvider).createProduct(
//                 name: name,
//                 description: description,
//                 price: price,
//                 unitId: unitId,
//                 categoryId: categoryId,
//                 image: image,
//             );
//             state = const ProductSubmitState(value: ProductSubmitStateValue.success);
//             _ref.invalidate(marketplaceProductsProvider);
//             _ref.invalidate(myProductsProvider);
//         }
//         catch (e)
//         {
//             state = ProductSubmitState(value: ProductSubmitStateValue.error, errorMessage: e.toString());
//         }
//     }
//
//     Future<void> updateProduct({
//         required String productId,
//         required String name,
//         required String description,
//         required String price,
//         required int unitId,
//         required int categoryId,
//         File? image,
//     }) async
//     {
//         state = const ProductSubmitState(value: ProductSubmitStateValue.loading);
//         try
//         {
//             await _ref.read(productRepositoryProvider).updateMyProduct(
//                 productId: productId,
//                 name: name,
//                 description: description,
//                 price: price,
//                 unitId: unitId,
//                 categoryId: categoryId,
//                 image: image,
//             );
//             state = const ProductSubmitState(value: ProductSubmitStateValue.success);
//             _ref.invalidate(marketplaceProductsProvider);
//             _ref.invalidate(myProductsProvider);
//         }
//         catch (e)
//         {
//             state = ProductSubmitState(value: ProductSubmitStateValue.error, errorMessage: e.toString());
//         }
//     }
// }
//
// final productSubmitProvider = StateNotifierProvider.autoDispose<ProductSubmitNotifier, ProductSubmitState>((ref)
//     {
//         return ProductSubmitNotifier(ref);
//     }
// );
//
// enum ProductActionStateValue
// {
//     initial, loading, success, error
// }
//
// class ProductActionState
// {
//     final ProductActionStateValue value;
//     final String? errorMessage;
//
//     const ProductActionState({
//         this.value = ProductActionStateValue.initial,
//         this.errorMessage,
//     });
// }
//
// class ProductActionNotifier extends StateNotifier<ProductActionState>
// {
//     final Ref _ref;
//     ProductActionNotifier(this._ref) : super(const ProductActionState());
//
//     Future<void> deleteProduct(String productId) async
//     {
//         state = const ProductActionState(value: ProductActionStateValue.loading);
//         try
//         {
//             await _ref.read(productRepositoryProvider).deleteMyProduct(productId);
//             state = const ProductActionState(value: ProductActionStateValue.success);
//             _ref.invalidate(myProductsProvider);
//             _ref.invalidate(marketplaceProductsProvider);
//         }
//         catch (e)
//         {
//             state = ProductActionState(value: ProductActionStateValue.error, errorMessage: e.toString());
//         }
//     }
// }
//
// final productActionProvider = StateNotifierProvider.autoDispose<ProductActionNotifier, ProductActionState>((ref)
//     {
//         return ProductActionNotifier(ref);
//     }
// );
//
// final myProductsSearchQueryProvider = StateProvider.autoDispose<String>((ref)
//     {
//         return '';
//     }
// );
//
// final myProductsCategoryFilterProvider = StateProvider.autoDispose<int?>((ref)
//     {
//         return null;
//     }
// );
//
// final filteredMyProductsProvider = Provider.autoDispose<AsyncValue<List<Product>>>((ref)
//     {
//         final myProductsAsync = ref.watch(myProductsProvider);
//         final searchQuery = ref.watch(myProductsSearchQueryProvider);
//         final selectedCategoryId = ref.watch(myProductsCategoryFilterProvider);
//
//         return myProductsAsync.whenData((products)
//             {
//                 var filteredList = products;
//
//                 if (searchQuery.trim().isNotEmpty)
//                 {
//                     filteredList = filteredList.where((product)
//                         {
//                             return product.name.toLowerCase().contains(searchQuery.trim().toLowerCase());
//                         }
//                     ).toList();
//                 }
//
//                 if (selectedCategoryId != null)
//                 {
//                     filteredList = filteredList.where((product)
//                         {
//                             return product.categoryId == selectedCategoryId;
//                         }
//                     ).toList();
//                 }
//
//                 return filteredList;
//             }
//         );
//     }
// );




import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/data/models/business_category_model.dart';
import 'package:totto/data/models/product_model.dart';
import 'package:totto/data/models/unit_model.dart';
import 'package:totto/data/repositories/product_repository.dart';
import 'package:totto/data/repositories/unit_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref)
{
  return ProductRepository();
}
);

final unitRepositoryProvider = Provider<UnitRepository>((ref)
{
  return UnitRepository();
}
);

// final myProductsProvider = FutureProvider.autoDispose<List<Product>>((ref)
// {
//   print('--- PROVIDER: myProductsProvider is executing ---');
//   final productRepository = ref.watch(productRepositoryProvider);
//   return productRepository.fetchMyProducts();
// }
// );
//
// final marketplaceProductsProvider = FutureProvider<List<Product>>((ref)
// {
//   print('--- PROVIDER: marketplaceProductsProvider is executing ---');
//   final productRepository = ref.watch(productRepositoryProvider);
//   return productRepository.fetchMarketplaceProducts();  // ✅ CORRECT - fetches only published products
// }
// );


// Updated myProductsProvider - fetch only draft products (not published)
// final myProductsProvider = FutureProvider.autoDispose<List<Product>>((ref)
// {
//   print('--- PROVIDER: myProductsProvider is executing ---');
//   final productRepository = ref.watch(productRepositoryProvider);
//   // Fetch only draft products (status 'D') - exclude published ones
//   return productRepository.fetchMyProducts(status: 'D');
// }
// );


final myProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) async
{
  print('--- PROVIDER: myProductsProvider is executing ---');
  final productRepository = ref.watch(productRepositoryProvider);

  // Fetch all my products
  final allProducts = await productRepository.fetchMyProducts();

  // Filter out published products (keep only drafts)
  // Assuming your Product model has a 'status' field
  return allProducts.where((product) {
    // Keep products that are NOT published
    // Adjust this condition based on how status is stored in your Product model
    return product.status != 'P'; // Exclude published products
  }).toList();
});









// final myProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) async
// {
//   print('--- PROVIDER: myProductsProvider is executing ---');
//   final productRepository = ref.watch(productRepositoryProvider);
//
//   // Fetch all my products
//   final allProducts = await productRepository.fetchMyProducts();
//
//   // Filter out published products (keep only drafts)
//   // Assuming your Product model has a 'status' field
//   return allProducts.where((product) {
//     // Keep products that are NOT published
//     // Adjust this condition based on how status is stored in your Product model
//     return product.status != 'P'; // Exclude published products
//   }).toList();
// });














// OR if your backend doesn't support status filtering, use client-side filtering:
// final myProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) async
// {
//   print('--- PROVIDER: myProductsProvider is executing ---');
//   final productRepository = ref.watch(productRepositoryProvider);
//   final allProducts = await productRepository.fetchMyProducts();
//   // Filter out published products
//   return allProducts.where((product) => product.status != 'P').toList();
// }
// );

final marketplaceProductsProvider = FutureProvider<List<Product>>((ref)
{
  print('--- PROVIDER: marketplaceProductsProvider is executing ---');
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.fetchMarketplaceProducts();
}
);

















final productDetailProvider = FutureProvider.family<Product, String>((ref, productId)
{
  print('--- PROVIDER: productDetailProvider is executing for ID: $productId ---');
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.fetchProductById(productId);
}
);

final productCategoriesProvider = FutureProvider<List<BusinessCategory>>((ref)
{
  print('--- PROVIDER: productCategoriesProvider is executing ---');
  final productRepository = ref.watch(productRepositoryProvider);
  return productRepository.fetchProductCategories();
}
);

final unitsProvider = FutureProvider<List<Unit>>((ref)
{
  print('--- PROVIDER: unitsProvider is executing ---');
  final unitRepository = ref.watch(unitRepositoryProvider);
  return unitRepository.fetchUnits();
}
);

enum ProductSubmitStateValue
{
  initial, loading, success, error
}

class ProductSubmitState
{
  final ProductSubmitStateValue value;
  final String? errorMessage;
  const ProductSubmitState({this.value = ProductSubmitStateValue.initial, this.errorMessage});
}

class ProductSubmitNotifier extends StateNotifier<ProductSubmitState>
{
  final Ref _ref;
  ProductSubmitNotifier(this._ref) : super(const ProductSubmitState());

  Future<void> createProduct({
    required String name,
    required String description,
    required String price,
    required int unitId,
    required int categoryId,
    File? image,
  }) async
  {
    state = const ProductSubmitState(value: ProductSubmitStateValue.loading);
    try
    {
      await _ref.read(productRepositoryProvider).createProduct(
        name: name,
        description: description,
        price: price,
        unitId: unitId,
        categoryId: categoryId,
        image: image,
      );
      state = const ProductSubmitState(value: ProductSubmitStateValue.success);
      _ref.invalidate(marketplaceProductsProvider);
      _ref.invalidate(myProductsProvider);
    }
    catch (e)
    {
      state = ProductSubmitState(value: ProductSubmitStateValue.error, errorMessage: e.toString());
    }
  }

  Future<void> updateProduct({
    required String productId,
    required String name,
    required String description,
    required String price,
    required int unitId,
    required int categoryId,
    File? image,
  }) async
  {
    state = const ProductSubmitState(value: ProductSubmitStateValue.loading);
    try
    {
      await _ref.read(productRepositoryProvider).updateMyProduct(
        productId: productId,
        name: name,
        description: description,
        price: price,
        unitId: unitId,
        categoryId: categoryId,
        image: image,
      );
      state = const ProductSubmitState(value: ProductSubmitStateValue.success);
      _ref.invalidate(marketplaceProductsProvider);
      _ref.invalidate(myProductsProvider);
    }
    catch (e)
    {
      state = ProductSubmitState(value: ProductSubmitStateValue.error, errorMessage: e.toString());
    }
  }
}

final productSubmitProvider = StateNotifierProvider.autoDispose<ProductSubmitNotifier, ProductSubmitState>((ref)
{
  return ProductSubmitNotifier(ref);
}
);

enum ProductActionStateValue
{
  initial, loading, success, error
}

class ProductActionState
{
  final ProductActionStateValue value;
  final String? errorMessage;
  final String? actionType; // Added this field

  const ProductActionState({
    this.value = ProductActionStateValue.initial,
    this.errorMessage,
    this.actionType,
  });
}

class ProductActionNotifier extends StateNotifier<ProductActionState>
{
  final Ref _ref;
  ProductActionNotifier(this._ref) : super(const ProductActionState());

  Future<void> deleteProduct(String productId) async
  {
    state = const ProductActionState(value: ProductActionStateValue.loading);
    try
    {
      await _ref.read(productRepositoryProvider).deleteMyProduct(productId);
      state = const ProductActionState(
        value: ProductActionStateValue.success,
        actionType: 'delete',
      );
      _ref.invalidate(myProductsProvider);
      _ref.invalidate(marketplaceProductsProvider);
    }
    catch (e)
    {
      state = ProductActionState(
        value: ProductActionStateValue.error,
        errorMessage: e.toString(),
      );
    }
  }

  // NEW METHOD: Upload product to marketplace
  Future<void> uploadProductToMarketplace(String productId) async
  {
    state = const ProductActionState(value: ProductActionStateValue.loading);
    try
    {
      await _ref.read(productRepositoryProvider).uploadProductToMarketplace(productId);
      state = const ProductActionState(
        value: ProductActionStateValue.success,
        actionType: 'upload',
      );
      _ref.invalidate(myProductsProvider);
      _ref.invalidate(marketplaceProductsProvider);
    }
    catch (e)
    {
      state = ProductActionState(
        value: ProductActionStateValue.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final productActionProvider = StateNotifierProvider.autoDispose<ProductActionNotifier, ProductActionState>((ref)
{
  return ProductActionNotifier(ref);
}
);

final myProductsSearchQueryProvider = StateProvider.autoDispose<String>((ref)
{
  return '';
}
);

final myProductsCategoryFilterProvider = StateProvider.autoDispose<int?>((ref)
{
  return null;
}
);

final filteredMyProductsProvider = Provider.autoDispose<AsyncValue<List<Product>>>((ref)
{
  final myProductsAsync = ref.watch(myProductsProvider);
  final searchQuery = ref.watch(myProductsSearchQueryProvider);
  final selectedCategoryId = ref.watch(myProductsCategoryFilterProvider);

  return myProductsAsync.whenData((products)
  {
    var filteredList = products;

    if (searchQuery.trim().isNotEmpty)
    {
      filteredList = filteredList.where((product)
      {
        return product.name.toLowerCase().contains(searchQuery.trim().toLowerCase());
      }
      ).toList();
    }

    if (selectedCategoryId != null)
    {
      filteredList = filteredList.where((product)
      {
        return product.categoryId == selectedCategoryId;
      }
      ).toList();
    }

    return filteredList;
  }
  );
}
);