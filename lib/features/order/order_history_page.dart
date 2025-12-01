import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/appbar/common_app_bar.dart';
import 'package:totto/common/cards/order_history_card.dart';
import 'package:totto/data/models/group_member_model.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/data/models/order_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/providers/group_provider.dart';
import 'package:totto/features/order/order_detail_page.dart';
import 'package:totto/features/order/providers/order_providers.dart';
import 'package:totto/l10n/app_localizations.dart';

class OrderHistoryPage extends ConsumerStatefulWidget {
    final String? groupId;

    const OrderHistoryPage({
        super.key,
        this.groupId,
    });

    @override
    ConsumerState<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends ConsumerState<OrderHistoryPage>
    with SingleTickerProviderStateMixin {
    late final TabController _tabController;

    @override
    void initState() {
        super.initState();
        _tabController = TabController(length: 3, vsync: this);
    }

    @override
    void dispose() {
        _tabController.dispose();
        super.dispose();
    }

    void _showStatusUpdateDialog(BuildContext context, Order order) {
        showDialog(
            context: context,
            builder: (dialogContext) {
                return AlertDialog(
                    title: const Text('Update Order Status'),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            _buildStatusOption(dialogContext, 'Confirm', 'C', order),
                            _buildStatusOption(dialogContext, 'Ship', 'S', order),
                            _buildStatusOption(dialogContext, 'Deliver', 'D', order),
                        ],
                    ),
                    actions: [
                        TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: const Text('Cancel'),
                        ),
                    ],
                );
            },
        );
    }

    Widget _buildStatusOption(BuildContext context, String title, String statusKey, Order order) {
        return ListTile(
            title: Text(title),
            onTap: () {
                ref.read(orderStatusUpdaterProvider.notifier).updateStatus(
                    orderId: order.id,
                    newStatus: statusKey,
                    groupId: widget.groupId,
                );
                Navigator.of(context).pop();
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        final l10n = AppLocalizations.of(context)!;

        final ordersAsync = ref.watch(filteredOrdersProvider(widget.groupId));

        final AsyncValue<Group?> groupAsync = widget.groupId != null
            ? ref.watch(groupDetailProvider(widget.groupId!))
            : const AsyncData(null);

        ref.listen<OrderStatusUpdateState>(orderStatusUpdaterProvider, (previous, next) {
            if (next.value == OrderStatusUpdateStateValue.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Update Failed: ${next.errorMessage}'),
                        backgroundColor: Colors.red,
                    ),
                );
            } else if (next.value == OrderStatusUpdateStateValue.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Status updated successfully!'),
                        backgroundColor: Colors.green,
                    ),
                );
            }
        });



        return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            appBar: CommonAppBar(
                leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                ),
                title: Text(widget.groupId != null ? 'Group Orders' : 'Orders History'),
                backgroundColor: Colors.white,
                elevation: 1,
            ),
            body: Column(
                children: [
                    Container(
                        color: Colors.white,
                        child: TabBar(
                            controller: _tabController,
                            indicatorColor: Colors.black,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey.shade500,
                            tabs: const [
                                Tab(text: 'Active'),
                                Tab(text: 'Completed'),
                                Tab(text: 'Expired'),
                            ],
                        ),
                    ),
                    Expanded(
                        child: TabBarView(
                            controller: _tabController,
                            children: [
                                _buildOrderList(ordersAsync, groupAsync, l10n),
                                const Center(child: Text("No completed orders.")),
                                const Center(child: Text("No expired orders.")),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildOrderList(
        AsyncValue<List<Order>> ordersAsync,
        AsyncValue<Group?> groupAsync,
        AppLocalizations l10n,
        ) {
        final currentUser = ref.watch(authStateChangesProvider).value;

        return groupAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error loading group details: $err')),
            data: (group) {
                final adminMember = group?.members.firstWhere(
                        (m) => m.role == 'A',
                    orElse: () => GroupMember.empty(),
                );
                final isAdmin = currentUser?.id.toString() == adminMember?.user.id.toString();

                return ordersAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error loading orders: $err')),
                    data: (orders) {
                        if (orders.isEmpty) {
                            return Center(child: Text(l10n.noOrdersFound));
                        }
                        return ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                                final order = orders[index];
                                return OrderHistoryCard(
                                    cardColor: _getColorForUrgency(order.urgency ?? 'NORMAL'),
                                    productName: order.productName,
                                    quantity: 'Qty: ${order.quantity}',
                                    price: order.displayPrice,
                                    imageUrl: order.imageUrl ?? '',
                                    buttonText: 'View Details',
                                    onButtonPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => OrderDetailPage(
                                                orderId: order.id,
                                                isReceived: false,
                                            ),
                                        ));
                                    },
                                    statusDisplay: order.statusDisplay,
                                    isAdmin: isAdmin,
                                    onStatusPressed: () => _showStatusUpdateDialog(context, order),
                                );
                            },
                        );
                    },
                );
            },
        );
    }

    Color _getColorForUrgency(String urgency) {
        switch (urgency.toUpperCase()) {
            case 'URGENT':
                return const Color(0xFFEF4444); // Red
            case 'HIGH':
                return const Color(0xFF22C55E); // Green
            case 'NORMAL':
            default:
                return const Color(0xFF3B82F6); // Blue
        }
    }
}