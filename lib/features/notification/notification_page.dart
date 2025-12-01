import 'package:flutter/material.dart';
import 'package:totto/common/constants/colors.dart';

import '../../common/appbar/common_app_bar.dart';

enum NotificationType
{
    order, message, request
}

class NotificationItem
{
    final String id;
    final NotificationType type;
    final String content;
    final String timeAgo;

    const NotificationItem({
        required this.id,
        required this.type,
        required this.content,
        required this.timeAgo,
    });
}

class NotificationPage extends StatefulWidget
{
    const NotificationPage({super.key});

    @override
    State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
{

    bool _isLoading = true;
    List<NotificationItem> _notifications = [];

    @override
    void initState()
    {
        super.initState();
        _fetchNotifications();
    }

    Future<void> _fetchNotifications() async
    {
        await Future.delayed(const Duration(seconds: 2));

        // TODO: Replace this with your actual API call.
        // final apiNotifications = await yourApi.getNotifications();
        // For now, we'll use dummy data.
        final dummyNotifications = [
            const NotificationItem(id: '1', type: NotificationType.order, content: 'Order #1295 has been approved.', timeAgo: '2 mins ago'),
            const NotificationItem(id: '2', type: NotificationType.message, content: 'You received a new message from "Premium Foods Group"', timeAgo: '5 mins ago'),
            const NotificationItem(id: '3', type: NotificationType.request, content: 'Your request for "Custom Tool Kit" was marked as urgent.', timeAgo: '2 mins ago'),
        ];
        // To test the empty state, comment out the line above and uncomment this one:
        // final List<NotificationItem> dummyNotifications = [];
        if (mounted)
        {
            setState(()
                {
                    _notifications = dummyNotifications;
                    _isLoading = false;
                }
            );
        }
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            backgroundColor: MainColors.appbackground,
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: MainColors.appbarbackground,
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text(
                    'Notification',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                actions: const[SizedBox(width: 56)],
            ),

            body: _buildBody(),
        );
    }

    Widget _buildBody()
    {
        if (_isLoading)
        {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
        }

        if (_notifications.isEmpty)
        {
            return _buildEmptyState();
        }

        return _buildNotificationList();
    }

    Widget _buildEmptyState()
    {
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Image.asset('assets/emptynotification.png', height: 150),
                    const SizedBox(height: 24),
                    const Text(
                        'Nothing to see here',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        "We'll notify you when something happens.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                ],
            ),
        );
    }

    Widget _buildNotificationList()
    {
        return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
                const Text(
                    'Today',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._notifications.map((notification) => _NotificationTile(notification: notification)),
            ],
        );
    }
}

class _NotificationTile extends StatelessWidget
{
    const _NotificationTile({required this.notification});

    final NotificationItem notification;

    (IconData, Color) _getIconAndColor(NotificationType type)
    {
        switch (type)
        {
            case NotificationType.order:
                // TODO: Replace with custom icon asset
                return (Icons.inventory_2_outlined, Colors.red.shade100);
            case NotificationType.message:
                // TODO: Replace with custom icon asset
                return (Icons.chat_bubble_outline, Colors.blue.shade100);
            case NotificationType.request:
                // TODO: Replace with custom icon asset
                return (Icons.flag_outlined, Colors.orange.shade100);
        }
    }

    @override
    Widget build(BuildContext context)
    {
        final (iconData, color) = _getIconAndColor(notification.type);

        return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0.5,
            child: ListTile(
                onTap: ()
                {
                    print('Tapped on notification: ${notification.id}');
                    // TODO: Add navigation logic here based on the notification type
                },
                leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(iconData, color: Colors.black54),
                ),
                title: Text(
                    notification.content,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                    notification.timeAgo,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
            ),
        );
    }
}
