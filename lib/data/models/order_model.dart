import 'package:intl/intl.dart';

enum OrderStatus
{
    Confirmed, // C
    Pending,   // P
    Requested, // R
    Shipped,   // S
    Delivered,

    Received,
    Unknown
}

class Order
{
    final String orderNumber;
    final String productName;
    final String vendor;
    final OrderStatus status;
    final int quantity;
    final DateTime date;
    final String buyerName;
    final String orderType;
    final String statusDisplay;
    final int id;
    final String groupId;
    final String? remarks;
    final int? seller;
    final String? sellerName;
    final String? price;
    final String? tier;
    final String? urgency;
    final String? imageUrl;
    final bool? requestQuotation;
    final String? productUrgency;
    final String? priceRangeMin;
    final String? priceRangeMax;
    final String? priceRangeDisplay;

    String get formattedDate => DateFormat('MMMM d, yyyy').format(date);

    String get displayPrice {
        if (priceRangeDisplay != null && priceRangeDisplay!.isNotEmpty) {
            return priceRangeDisplay!.replaceAll('\$', 'Rs.');
        }
        if (price != null && price!.isNotEmpty) {
            return 'Rs.${price!}';
        }
        if (priceRangeMin != null && priceRangeMin!.isNotEmpty) {
            return 'Rs.${priceRangeMin!}';
        }
        return 'N/A';
    }

    const Order({
        required this.orderNumber,
        required this.productName,
        required this.vendor,
        required this.status,
        required this.quantity,
        required this.date,
        required this.buyerName,
        required this.orderType,
        required this.statusDisplay,
        required this.id,
        required this.groupId,
        this.remarks,
        this.seller,
        this.sellerName,
        this.price,
        this.tier,
        this.urgency,
        this.imageUrl,
        this.requestQuotation,
        this.productUrgency,
        this.priceRangeMin,
        this.priceRangeMax,
        this.priceRangeDisplay,
    });

    Order copyWith({
        String? orderNumber,
        String? productName,
        String? vendor,
        OrderStatus? status,
        int? quantity,
        DateTime? date,
        String? buyerName,
        String? orderType,
        String? statusDisplay,
        int? id,
        String? groupId,
        String? remarks,
        int? seller,
        String? sellerName,
        String? price,
        String? tier,
        String? urgency,
        String? imageUrl,
        bool? requestQuotation,
        String? productUrgency,
        String? priceRangeMin,
        String? priceRangeMax,
        String? priceRangeDisplay,
    }) 
    {
        return Order(
            orderNumber: orderNumber ?? this.orderNumber,
            productName: productName ?? this.productName,
            vendor: vendor ?? this.vendor,
            status: status ?? this.status,
            quantity: quantity ?? this.quantity,
            date: date ?? this.date,
            buyerName: buyerName ?? this.buyerName,
            orderType: orderType ?? this.orderType,
            statusDisplay: statusDisplay ?? this.statusDisplay,
            id: id ?? this.id,
            groupId: groupId ?? this.groupId,
            remarks: remarks ?? this.remarks,
            seller: seller ?? this.seller,
            sellerName: sellerName ?? this.sellerName,
            price: price ?? this.price,
            tier: tier ?? this.tier,
            urgency: urgency ?? this.urgency,
            imageUrl: imageUrl ?? this.imageUrl,
            requestQuotation: requestQuotation ?? this.requestQuotation,
            productUrgency: productUrgency ?? this.productUrgency,
            priceRangeMin: priceRangeMin ?? this.priceRangeMin,
            priceRangeMax: priceRangeMax ?? this.priceRangeMax,
            priceRangeDisplay: priceRangeDisplay ?? this.priceRangeDisplay,
        );
    }

    static OrderStatus _mapStatus(String statusChar) 
    {
        switch (statusChar.toUpperCase())
        {
            case 'C':
                return OrderStatus.Confirmed;
            case 'P':
                return OrderStatus.Pending;
            case 'R':
                return OrderStatus.Requested;
            case 'S':
                return OrderStatus.Shipped;
            default:
            return OrderStatus.Unknown;
        }
    }

    factory Order.fromJson(Map<String, dynamic> json)
    {
        String productName = 'N/A';
        String? price;
        int? seller;
        String? sellerName;
        String? imageUrl;

        final productInfo = json['product_info'];

        if (productInfo is Map<String, dynamic>) 
        {
            productName = productInfo['name'] as String? ?? 'N/A';
            price = productInfo['price'] as String?;
            sellerName = productInfo['seller_name'] as String?;
            imageUrl = productInfo['image'] as String?;
        }
        else if (productInfo is String) 
        {
            productName = productInfo;
        }
        else if (json['product_name'] is String) 
        {
            productName = json['product_name'];
        }


        final quantityString = json['quantity'].toString();
        final quantity = double.tryParse(quantityString)?.toInt() ?? 0;

        final id = json['id'] as int? ?? 0;

        return Order(
            id: id,
            groupId: json['group'] as String? ?? json['group_name'] as String? ?? '',
            orderNumber: id != 0 ? '#$id' : 'New',
            productName: productName,
            vendor: json['group_name'] as String? ?? json['buyer_name'] as String? ?? 'Unknown',
            quantity: quantity,
            date: json.containsKey('created_at') && json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : DateTime.now(),
            status: _mapStatus(json['status'] as String? ?? 'R'),
            buyerName: json['buyer_name'] as String? ?? '',
            orderType: json['order_type'] as String? ?? 'product_request',
            statusDisplay: json['status_display'] as String? ?? 'Requested',
            seller: seller ?? json['seller'] as int?,
            sellerName: sellerName ?? json['seller_name'] as String?,
            price: price,
            remarks: json['remarks'] as String?,
            requestQuotation: json['request_quotation'] as bool?,
            productUrgency: json['product_urgency'] as String?,
            priceRangeMin: json['price_range_min'] as String?,
            priceRangeMax: json['price_range_max'] as String?,
            priceRangeDisplay: json['price_range_display'] as String?,
            tier: json['tier'] as String? ?? 'Essential',
            urgency: json['product_urgency'] as String?,
            imageUrl: imageUrl,
        );
    }
}
