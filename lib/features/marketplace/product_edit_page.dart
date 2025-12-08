import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/primary_button.dart';
import 'package:totto/common/widgets/product_image_widget.dart';
import 'package:totto/data/models/product_model.dart';
import 'package:totto/features/marketplace/add_product_page.dart';
import 'package:totto/features/marketplace/providers/product_providers.dart';
import 'package:totto/l10n/app_localizations.dart';

class ProductEditPage extends ConsumerWidget
{
  const ProductEditPage({super.key, required this.product});

  final Product product;

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref, String productId, AppLocalizations l10n)
  {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext)
      {
        return AlertDialog(
          title: Text(l10n.deleteProductConfirmationTitle),
          content: Text(l10n.deleteProductConfirmationMessage),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancelButtonLabel),
              onPressed: ()
              {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.deleteButtonLabel),
              onPressed: ()
              {
                Navigator.of(dialogContext).pop();
                ref.read(productActionProvider.notifier).deleteProduct(productId);
              },
            ),
          ],
        );
      },
    );
  }

  void _showUploadConfirmationDialog(BuildContext context, WidgetRef ref, String productId, AppLocalizations l10n)
  {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext)
      {
        return AlertDialog(
          title: const Text('Upload to Marketplace'),
          content: Text('Are you sure you want to publish "${product.name}" to the marketplace?'),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancelButtonLabel),
              onPressed: ()
              {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text('Upload'),
              onPressed: ()
              {
                Navigator.of(dialogContext).pop();
                ref.read(productActionProvider.notifier).uploadProductToMarketplace(productId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref)
  {
    final l10n = AppLocalizations.of(context)!;
    final isPublished = product.status == 'P';

    ref.listen<ProductActionState>(productActionProvider, (previous, next)
    {
      if (next.value == ProductActionStateValue.success)
      {
        String message = l10n.productDeletedSuccessfully;

        // Check if it was an upload action
        if (next.actionType == 'upload')
        {
          message = 'Product uploaded to marketplace successfully!';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );

        // Close the edit page - go back to products list
        Navigator.of(context).pop();
      }
      else if (next.value == ProductActionStateValue.error)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? l10n.anErrorOccurred),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, product, isPublished),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(product, l10n, isPublished),
                  const SizedBox(height: 32),
                  _buildActionButtons(context, ref, product, l10n, isPublished),
                  const SizedBox(height: 32),
                  _buildDescription(product, l10n),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context, Product product, bool isPublished)
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
        background: Stack(
          children: [
            ProductImageWidget(
              imageUrl: product.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              borderRadius: BorderRadius.zero,
            ),
            // Published badge overlay
            if (isPublished)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Published',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Product product, AppLocalizations l10n, bool isPublished)
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                product.categoryName,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              if (isPublished)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Live on Marketplace',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Rs.${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, Product product, AppLocalizations l10n, bool isPublished)
  {
    final productActionState = ref.watch(productActionProvider);
    final isLoading = productActionState.value == ProductActionStateValue.loading;

    // If product is already published, show different UI
    if (isPublished)
    {
      return Column(
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This product is published on the marketplace. It cannot be edited or deleted.',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Draft product - show all action buttons
    return Column(
      children: [
        // Upload to Marketplace Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : ()
            {
              _showUploadConfirmationDialog(context, ref, product.id, l10n);
            },
            icon: isLoading
                ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white
                )
            )
                : const Icon(Icons.cloud_upload, color: Colors.white),
            label: const Text('Upload to Marketplace'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Edit Product Button
        PrimaryButton(
          text: l10n.editProduct,
          onPressed: isLoading ? null : ()
          {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddProductPage(productToEdit: product),
              ),
            );
          },
          borderRadius: 12.0,
        ),
        const SizedBox(height: 16),

        // Delete Product Button
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: isLoading ? null : ()
            {
              _showDeleteConfirmationDialog(context, ref, product.id, l10n);
            },
            icon: const Icon(Icons.delete_outline),
            label: Text(l10n.deleteProduct),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(Product product, AppLocalizations l10n)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.productDetailsOf(product.name),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          product.description,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}