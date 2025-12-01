import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:totto/data/models/business_category_model.dart';
import 'package:totto/data/models/product_model.dart';
import 'package:totto/data/models/unit_model.dart';
import 'package:totto/features/marketplace/providers/product_providers.dart';

import '../../common/appbar/common_app_bar.dart';
import '../../common/primary_button.dart';
import '../../l10n/app_localizations.dart';

class AddProductPage extends ConsumerStatefulWidget
{
    const AddProductPage({super.key, this.productToEdit});
    final Product? productToEdit;

    @override
    ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage>
{
    final _nameController = TextEditingController();
    final _priceController = TextEditingController();
    final _remarksController = TextEditingController();

    final ImagePicker _picker = ImagePicker();
    XFile? _productImage;
    String? _existingImageUrl;

    Unit? _selectedUnit;
    BusinessCategory? _selectedCategory;

    bool get isEditMode => widget.productToEdit != null;

    @override
    void initState()
    {
        super.initState();
        if (isEditMode)
        {
            _nameController.text = widget.productToEdit!.name;
            _priceController.text = widget.productToEdit!.price.toStringAsFixed(2);
            _remarksController.text = widget.productToEdit!.description;
            _existingImageUrl = widget.productToEdit!.imageUrl;

            WidgetsBinding.instance.addPostFrameCallback((_)
                {
                    if (!mounted) return;
                    _preselectDropdowns();
                }
            );
        }
    }

    void _preselectDropdowns()
    {
        final categories = ref.read(productCategoriesProvider).asData?.value;
        if (categories != null)
        {
            try
            {
                final categoryToSelect = categories.firstWhere((c) => c.id == widget.productToEdit!.categoryId);
                setState(() => _selectedCategory = categoryToSelect);
            }
            catch (e)
            {
                print("Error finding category: ${widget.productToEdit!.categoryId}");
            }
        }
        final units = ref.read(unitsProvider).asData?.value;
        if (units != null)
        {
            try
            {
                final unitToSelect = units.firstWhere((u) => u.id == widget.productToEdit!.unitId);
                setState(() => _selectedUnit = unitToSelect);
            }
            catch (e)
            {
                print("Error finding unit: ${widget.productToEdit!.unitId}");
            }
        }
    }

    @override
    void dispose()
    {
        _nameController.dispose();
        _priceController.dispose();
        _remarksController.dispose();
        super.dispose();
    }

    Future<void> _pickImage() async
    {
        try
        {
            final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
            if (pickedFile != null)
            {
                setState(()
                    {
                        _productImage = pickedFile;
                        _existingImageUrl = null;
                    }
                );
            }
        }
        catch (e)
        {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
        }
    }

    void _submitProduct()
    {
        final l10n = AppLocalizations.of(context)!;

        if (_nameController.text.trim().isEmpty)
        {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.productNameCannotBeEmpty)));
            return;
        }
        if (_priceController.text.trim().isEmpty)
        {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.priceCannotBeEmpty)));
            return;
        }
        if (_selectedUnit == null)
        {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectAUnit)));
            return;
        }
        if (_selectedCategory == null)
        {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectACategory)));
            return;
        }

        if (isEditMode)
        {
            ref.read(productSubmitProvider.notifier).updateProduct(
                productId: widget.productToEdit!.id,
                name: _nameController.text.trim(),
                price: _priceController.text.trim(),
                description: _remarksController.text.trim(),
                unitId: _selectedUnit!.id,
                categoryId: _selectedCategory!.id,
                image: _productImage != null ? File(_productImage!.path) : null,
            );
        }
        else
        {
            ref.read(productSubmitProvider.notifier).createProduct(
                name: _nameController.text.trim(),
                price: _priceController.text.trim(),
                description: _remarksController.text.trim(),
                unitId: _selectedUnit!.id,
                categoryId: _selectedCategory!.id,
                image: _productImage != null ? File(_productImage!.path) : null,
            );
        }
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        final submitState = ref.watch(productSubmitProvider);
        final unitsAsync = ref.watch(unitsProvider);
        final categoriesAsync = ref.watch(productCategoriesProvider);

        ref.listen<ProductSubmitState>(productSubmitProvider, (previous, next)
            {
                if (next.value == ProductSubmitStateValue.success)
                {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isEditMode ? 'Product updated successfully!' : 'Product added successfully!'), backgroundColor: Colors.green),
                    );
                    Navigator.of(context)..pop()..pop();
                }
                if (next.value == ProductSubmitStateValue.error)
                {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${next.errorMessage}'), backgroundColor: Colors.red),
                    );
                }
            }
        );

        return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                    isEditMode ? "Edit Product" : l10n.addToMarket,
                    style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)
                ),
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        _buildTextField(label: l10n.enterProductName, hint: l10n.productName, controller: _nameController),
                        const SizedBox(height: 24),
                        categoriesAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (err, stack) => Text(l10n.errorCouldNotLoadCategories(err.toString())),
                            data: (categories) => _buildCategoryDropdown(l10n, categories),
                        ),
                        const SizedBox(height: 24),
                        _buildFileUploadField(
                            label: l10n.uploadProductCatalogs,
                            hint: l10n.clickToUploadCatalogs,
                            onTap: ()
                            {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Catalog upload is not yet supported.')),
                                );
                            }
                        ),
                        const SizedBox(height: 24),
                        _buildImagePickerField(label: l10n.uploadProductImages, hint: l10n.clickToUploadImages),
                        const SizedBox(height: 24),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Expanded(
                                    flex: 2,
                                    child: _buildTextField(label: l10n.price, hint: l10n.priceExample, controller: _priceController, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                    flex: 3,
                                    child: unitsAsync.when(
                                        loading: () => const Padding(padding: EdgeInsets.only(top: 32.0), child: Center(child: CircularProgressIndicator())),
                                        error: (err, stack) => Text('Could not load units: $err'),
                                        data: (units) => _buildUnitDropdown(l10n, units),
                                    ),
                                ),
                            ],
                        ),
                        const SizedBox(height: 24),
                        _buildTextField(label: l10n.remarks, hint: l10n.writeSomething, controller: _remarksController),
                        const SizedBox(height: 48),
                        PrimaryButton(
                            text: submitState.value == ProductSubmitStateValue.loading
                                ? (isEditMode ? "Updating..." : "Adding...")
                                : (isEditMode ? "Update Product" : l10n.addProduct),
                            isLoading: submitState.value == ProductSubmitStateValue.loading,
                            icon: Image.asset('assets/logos/Order.png', width: 20, height: 20, color: Colors.white),
                            onPressed: _submitProduct,
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _buildTextField({required String label, required String hint, required TextEditingController controller, TextInputType keyboardType = TextInputType.text})
    {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                const SizedBox(height: 8),
                TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 1)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black54, width: 1.5)),
                    ),
                ),
            ],
        );
    }

    Widget _buildFileUploadField({required String label, required String hint, required VoidCallback onTap})
    {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                const SizedBox(height: 8),
                InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300, width: 1)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(hint, style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
                                Icon(Icons.image_outlined, color: Colors.grey.shade600),
                            ],
                        ),
                    ),
                ),
            ],
        );
    }

    Widget _buildUnitDropdown(AppLocalizations l10n, List<Unit> units)
    {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(l10n.unit, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                const SizedBox(height: 8),
                DropdownButtonFormField<Unit>(
                    value: _selectedUnit,
                    hint: Text(l10n.select, style: TextStyle(color: Colors.grey.shade400)),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 1)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black54, width: 1.5)),
                    ),
                    items: units.map((unit)
                        {
                            return DropdownMenuItem<Unit>(
                                value: unit,
                                child: Text(unit.name),
                            );
                        }
                    ).toList(),
                    onChanged: (val) => setState(() => _selectedUnit = val),
                ),
            ],
        );
    }

    Widget _buildCategoryDropdown(AppLocalizations l10n, List<BusinessCategory> categories)
    {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(l10n.category, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                const SizedBox(height: 8),
                DropdownButtonFormField<BusinessCategory>(
                    value: _selectedCategory,
                    hint: Text(l10n.select, style: TextStyle(color: Colors.grey.shade400)),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 1)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black54, width: 1.5)),
                    ),
                    items: categories.map((category)
                        {
                            return DropdownMenuItem<BusinessCategory>(
                                value: category,
                                child: Text(category.name),
                            );
                        }
                    ).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                ),
            ],
        );
    }

    Widget _buildImagePickerField({required String label, required String hint})
    {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
                const SizedBox(height: 8),
                if (_productImage == null && _existingImageUrl == null)
                InkWell(
                    onTap: _pickImage,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300, width: 1)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(hint, style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
                                Icon(Icons.image_outlined, color: Colors.grey.shade600),
                            ],
                        ),
                    ),
                ),
                if (_productImage != null || _existingImageUrl != null)
                SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                        children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: _productImage != null
                                    ? Image.file(File(_productImage!.path), width: 100, height: 100, fit: BoxFit.cover)
                                    : Image.network(_existingImageUrl!, width: 100, height: 100, fit: BoxFit.cover),
                            ),
                            Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                    onTap: () => setState(()
                                        {
                                            _productImage = null;
                                            _existingImageUrl = null;
                                        }
                                    ),
                                    child: Container(decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle), child: const Icon(Icons.close, color: Colors.white, size: 16)),
                                ),
                            ),
                        ],
                    ),
                ),
            ],
        );
    }
}
