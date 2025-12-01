import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:totto/data/models/order_model.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:totto/features/chat/websocket/providers/chat_controller.dart';
import 'package:totto/features/order/providers/order_providers.dart';
import 'package:totto/l10n/app_localizations.dart';

import '../../common/appbar/common_app_bar.dart';
import '../../common/custom_text_field.dart';
import '../../common/primary_button.dart';

class OrderPlacementPage extends ConsumerStatefulWidget
{
    final String groupId;
    final Order? orderToUpdate;
    final String? initialProductName;

    const OrderPlacementPage({
        super.key,
        required this.groupId,
        this.orderToUpdate,
        this.initialProductName,
    });

    @override
    ConsumerState<OrderPlacementPage> createState() => _OrderPlacementPageState();
}

class _OrderPlacementPageState extends ConsumerState<OrderPlacementPage>
{
    final _productNameController = TextEditingController();
    final _quantityController = TextEditingController();
    final _minPriceController = TextEditingController();
    final _maxPriceController = TextEditingController();
    final _remarksController = TextEditingController();
    bool _requestForQuotation = true;
    bool _isNegotiable = false;
    bool _isUpdateMode = false;
    String? _selectedUrgency;
    final List<String> _urgencyOptions = const['NORMAL', 'HIGH', 'URGENT'];

    final List<File> _selectedImages = [];
    final List<File> _selectedCatalogs = [];
    final ImagePicker _picker = ImagePicker();

    @override
    void initState() 
    {
        super.initState();
        if (widget.initialProductName != null) 
        {
            _productNameController.text = widget.initialProductName!;
        }
        if (widget.orderToUpdate != null) 
        {
            _isUpdateMode = true;
            final order = widget.orderToUpdate!;
            _productNameController.text = order.productName;
            _quantityController.text = order.quantity.toString();
            _remarksController.text = order.remarks ?? '';
            _selectedUrgency = widget.orderToUpdate!.urgency;
        }
    }

    @override
    void dispose() 
    {
        _productNameController.dispose();
        _quantityController.dispose();
        _minPriceController.dispose();
        _maxPriceController.dispose();
        _remarksController.dispose();
        super.dispose();
    }

    Future<void> _pickImages() async {
        final List<XFile> pickedFiles = await _picker.pickMultiImage(
            imageQuality: 80,
        );
        if (pickedFiles.isNotEmpty) {
            setState(() {
                _selectedImages.addAll(pickedFiles.map((xfile) => File(xfile.path)));
            });
        }
    }

    Future<void> _pickCatalogs() async {
        final List<XFile> pickedFiles = await _picker.pickMultiImage();
        if (pickedFiles.isNotEmpty) {
            setState(() {
                _selectedCatalogs.addAll(pickedFiles.map((xfile) => File(xfile.path)));
            });
        }
    }

    void _placeOrUpdateOrder() 
    {
        final l10n = AppLocalizations.of(context)!;
        if (_productNameController.text.trim().isEmpty) 
        {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.productNameCannotBeEmpty)),
            );
            return;
        }
        if (_quantityController.text.trim().isEmpty) 
        {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.quantityCannotBeEmpty)),
            );
            return;
        }

        final quantityString = _quantityController.text.trim();

        final notifier = ref.read(orderPlacementProvider.notifier);
        if (_isUpdateMode) 
        {
            notifier.updateOrder(
                orderId: widget.orderToUpdate!.id,
                groupId: widget.groupId,
                productName: _productNameController.text.trim(),
                catalogs: _selectedCatalogs,
                images: _selectedImages,
                quantity: quantityString,
                minPrice: _minPriceController.text.trim(),
                maxPrice: _isNegotiable ? _maxPriceController.text.trim() : null,
                remarks: _remarksController.text.trim(),
            );
        }
        else 
        {
            notifier.createProductRequest(
                groupId: widget.groupId,
                productName: _productNameController.text.trim(),
                catalogs: _selectedCatalogs,
                images: _selectedImages,
                quantity: quantityString,
                requestQuotation: _requestForQuotation,
                isNegotiable: _isNegotiable,
                minPrice: _minPriceController.text.trim(),
                maxPrice: _maxPriceController.text.trim(),
                productUrgency: _selectedUrgency ?? 'NORMAL',
                remarks: _remarksController.text.trim(),
            );
        }
    }

    @override
    Widget build(BuildContext context) 
    {
        final l10n = AppLocalizations.of(context)!;

        ref.listen<OrderPlacementState>(orderPlacementProvider, (previous, next)
            {
                if (previous?.value == OrderPlacementStateValue.loading) 
                {
                    if (Navigator.of(context, rootNavigator: true).canPop()) 
                    {
                        Navigator.of(context, rootNavigator: true).pop();
                    }
                }

                if (next.value == OrderPlacementStateValue.loading) 
                {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                        const Center(child: CircularProgressIndicator(color: Colors.red)),
                    );
                }
                else if (next.value == OrderPlacementStateValue.success) 
                {
                    if (!_isUpdateMode && next.createdOrder != null) 
                    {
                        final newOrder = next.createdOrder!;
                        final chatParams = ChatConnectionParams(
                            id: newOrder.groupId,
                            type: ChatType.group,
                        );
                        ref.read(chatControllerProvider(chatParams).notifier).sendOrderMessage(
                            order: newOrder,
                            urgency: newOrder.urgency ?? 'NORMAL',
                            params: chatParams,
                        );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(_isUpdateMode
                                    ? l10n.orderUpdatedSuccess
                                    : l10n.orderPlacedSuccess),
                            backgroundColor: Colors.green,
                        ),
                    );

                    if (Navigator.of(context).canPop()) 
                    {
                        Navigator.of(context).pop(true);
                    }

                }
                else if (next.value == OrderPlacementStateValue.error) 
                {
                    if (previous?.value == OrderPlacementStateValue.loading && Navigator.of(context).canPop()) 
                    {
                    }
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            title: Text(_isUpdateMode
                                    ? l10n.errorUpdatingOrder
                                    : l10n.errorPlacingOrder),
                            content: Text(next.errorMessage ?? l10n.unknownError),
                            actions: [
                                TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text(l10n.okButton)),
                            ],
                        ),
                    );
                }
            }
        );

        return Scaffold(
            backgroundColor: const Color(0xFFF1F2F6),
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: const Color(0xFFF1F2F6),
                elevation: 0,
                shape: const Border(),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                    _isUpdateMode ? l10n.updateOrderTitle : l10n.orderPlacementTitle,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                actions: const[SizedBox(width: 56)],
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        _buildSectionHeader(l10n.enterProductName),
                        CustomTextField(
                            controller: _productNameController,
                            hintText: l10n.productName),
                        _buildSectionHeader(l10n.uploadProductCatalogs),
                        _buildFileUploadField(
                            hint: _selectedCatalogs.isEmpty
                                ? l10n.clickToUploadCatalogs
                                : '${_selectedCatalogs.length} file(s) selected',
                            onTap: _pickCatalogs,
                            onClear: () => setState(() => _selectedCatalogs.clear()),
                            hasFiles: _selectedCatalogs.isNotEmpty,
                        ),
                        _buildSectionHeader(l10n.uploadProductImages),
                        _buildFileUploadField(
                            hint: _selectedImages.isEmpty
                                ? l10n.clickToUploadImages
                                : '${_selectedImages.length} image(s) selected',
                            onTap: _pickImages,
                            onClear: () => setState(() => _selectedImages.clear()),
                            hasFiles: _selectedImages.isNotEmpty,
                        ),
                        CheckboxListTile(
                            title: Text(l10n.requestForQuotation),
                            value: _requestForQuotation,
                            onChanged: (val) =>
                            setState(() => _requestForQuotation = val ?? false),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            activeColor: Colors.red,
                        ),
                        _buildSectionHeader(l10n.enterQuantity),
                        CustomTextField(
                            controller: _quantityController,
                            hintText: '10.0',
                            keyboardType: TextInputType.number,
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.grey),
                                onPressed: () => _quantityController.clear(),
                            ),
                        ),
                        const SizedBox(height: 8),
                        _buildQuantityChips(),
                        _buildSectionHeader(l10n.priceRange),
                        _buildPriceRange(l10n),
                        CheckboxListTile(
                            title: Text(l10n.priceIsNegotiable),
                            value: _isNegotiable,
                            onChanged: (newValue)
                            {
                                setState(()
                                    {
                                        _isNegotiable = newValue ?? false;
                                    }
                                );
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            activeColor: Colors.red,
                        ),
                        _buildSectionHeader(l10n.productUrgency),
                        DropdownButtonFormField<String>(
                            value: _selectedUrgency,
                            hint: Text(l10n.selectUrgency),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            items: _urgencyOptions.map((String value)
                                {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                    );
                                }
                            ).toList(),
                            onChanged: (String? newValue)
                            {
                                setState(()
                                    {
                                        _selectedUrgency = newValue;
                                    }
                                );
                            },
                        ),
                        _buildSectionHeader(l10n.remarks),
                        CustomTextField(
                            controller: _remarksController,
                            hintText: l10n.writeSomething),
                        const SizedBox(height: 40),
                        PrimaryButton(
                            text: _isUpdateMode
                                ? l10n.updateOrderTitle
                                : l10n.orderPlacementTitle,
                            onPressed: _placeOrUpdateOrder,
                            icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                    ],
                ),
            ),
        );
    }

    Widget _buildSectionHeader(String title) 
    {
        return Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
            child:
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        );
    }

    Widget _buildFileUploadField({
        required String hint,
        required VoidCallback onTap,
        required VoidCallback onClear,
        required bool hasFiles,
    }) {
        return TextFormField(
            readOnly: true,
            onTap: onTap,
            style: hasFiles ? const TextStyle(color: Colors.black, fontWeight: FontWeight.w500) : null,
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: const OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: hasFiles
                        ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: onClear,
                    )
                        : const Icon(Icons.image_outlined, color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
        );
    }

    Widget _buildQuantityChips() 
    {
        final quantities = ['10.0', '20.0', '30.0', '50.0', '100.0'];
        return Wrap(
            spacing: 8.0,
            children: quantities.map((qty)
                {
                    return ActionChip(
                        label: Text(qty),
                        onPressed: ()
                        {
                            setState(()
                                {
                                    _quantityController.text = qty;
                                }
                            );
                        },
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.red.shade200),
                        ),
                    );
                }
            ).toList(),
        );
    }

    Widget _buildPriceRange(AppLocalizations l10n) 
    {
        return Row(
            children: [
                Expanded(
                    child: CustomTextField(
                        controller: _minPriceController,
                        hintText: '10.00',
                        keyboardType: TextInputType.number),
                ),
                if (_isNegotiable)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(l10n.priceRangeTo),
                ),
                if (_isNegotiable)
                Expanded(
                    child: CustomTextField(
                        controller: _maxPriceController,
                        hintText: '10.00',
                        keyboardType: TextInputType.number),
                ),
            ],
        );
    }
}
