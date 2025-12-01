import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/data/models/order_model.dart';
import 'package:totto/data/models/user_profile_model.dart';
import 'package:totto/features/chat/create_chat_page.dart';
import 'package:totto/features/chat/personal_message_page.dart';
import 'package:totto/features/order/providers/order_providers.dart';

class OrderDetailPage extends ConsumerWidget
{
    final int orderId;
    final bool isReceived;

    const OrderDetailPage({
        super.key,
        required this.orderId,
        required this.isReceived,
    });

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final param = (orderId: orderId, isReceived: isReceived);
        final orderDetailAsync = ref.watch(orderDetailProvider(param));

        return Scaffold(
            backgroundColor: const Color(0xFF495057),
            appBar: AppBar(
                title: const Text("Products Detail;s", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.3),
                        child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ),
                ),
            ),
            body: orderDetailAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))),
                data: (order)
                {
                    return Column(
                        children: [
                            SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: (order.imageUrl != null && order.imageUrl!.startsWith('http'))
                                    ? Image.network(
                                        order.imageUrl!,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => _buildImageError(),
                                    )
                                    : _buildImageError(),
                            ),
                            Expanded(
                                child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(24.0),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                        ),
                                    ),
                                    child: SingleChildScrollView(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                _buildHeader(order),
                                                const SizedBox(height: 8),
                                                Text('Vendor: ${order.vendor}', style: const TextStyle(color: Colors.grey, fontSize: 16)),
                                                const Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                                    child: Divider(color: Color(0xFFEEEEEE)),
                                                ),
                                                _buildOrderInfo(order),
                                                const SizedBox(height: 32),
                                                _buildChatButton(context, order),
                                            ],
                                        ),
                                    ),
                                ),
                            ),
                        ],
                    );
                },
            ),
        );
    }

    Widget _buildImageError()
    {
        return const Center(
            child: Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 80),
        );
    }

    Widget _buildHeader(Order order)
    {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Expanded(
                    child: Text(
                        order.productName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                ),
                const SizedBox(width: 16),
                Text(
                    order.price ?? 'N/A',
                    style: const TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
                ),
            ],
        );
    }

    Widget _buildOrderInfo(Order order)
    {
        return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text('Order ${order.orderNumber}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(order.formattedDate, style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8),
                            Text('Tier: ${order.tier ?? 'N/A'}', style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8),
                            Text('Urgency: ${order.urgency ?? 'N/A'}', style: const TextStyle(color: Colors.grey)),
                        ],
                    ),
                ),
                Text('Quantity: ${order.quantity} Units', style: const TextStyle(color: Colors.grey)),
            ],
        );
    }

    Widget _buildChatButton(BuildContext context, Order order)
    {
        if (order.seller == null)
        {
            return const SizedBox.shrink();
        }

        return SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
                onPressed: ()
                {
                    final sellerProfile = UserProfile(
                        id: order.seller.toString(),
                        name: order.sellerName ?? 'Seller',
                        username: '',
                        profileImageUrl: '',
                        tier: '',
                        tottoPoints: 0,
                        email: '',
                        phone: '',
                    );
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateChatPage(otherUser: sellerProfile),
                    ));
                },
                icon: const Icon(Icons.mail_outline),
                label: const Text('Go Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
            ),
        );
    }
}
