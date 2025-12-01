import '../../config/app_config.dart';

class Product
{
    final String id;
    final String name;
    final double price;
    final String imageUrl;
    final String vendor;
    final String sellerId;
    final String description;
    final String categoryName;
    final int categoryId;
    final int unitId;
    final String status;


    const Product({
        required this.id,
        required this.name,
        required this.price,
        required this.imageUrl,
        required this.vendor,
        required this.sellerId,
        required this.description,
        required this.categoryName,
        required this.categoryId,
        required this.unitId,
      required this.status
    });

    factory Product.fromJson(Map<String, dynamic> json)
    {
        String imageUrl = json['image'] as String? ?? '';
        if (imageUrl.isNotEmpty && !imageUrl.startsWith('http'))
        {
            imageUrl = '${ApiConfig.baseUrl}$imageUrl';
        }

        return Product(
            id: (json['id'] as int? ?? 0).toString(),
            name: json['name'] as String? ?? 'No Name',
            price: double.tryParse(json['price'] as String? ?? '0.0') ?? 0.0,
            vendor: json['seller_name'] as String? ?? 'Unknown Seller',
            sellerId: (json['seller'] as int? ?? 0).toString(),
            imageUrl: imageUrl,
            description: json['description'] as String? ?? 'No description available.',
            categoryName: json['category_name'] as String? ?? 'Uncategorized',
            categoryId: json['category'] as int? ?? 0,
            unitId: json['unit'] as int? ?? 0,
          status: json['status'] ?? 'D',

        );
    }
}
