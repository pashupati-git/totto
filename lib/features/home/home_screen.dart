import 'package:flutter/material.dart';
import 'package:totto/features/notification/notification_page.dart';
import 'package:totto/features/profile/profiile_page.dart';

import '../../common/constants/colors.dart';
import '../../common/header_text_block.dart';
import '../../common/primary_button.dart';
import '../../l10n/app_localizations.dart';
import '../chat/chat_page.dart';
import '../marketplace/marketplace_page.dart';
import '../order/order_page.dart';

class HomeScreen extends StatefulWidget
{
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
    int _selectedIndex = 0;

    static const List<Widget> _widgetOptions = <Widget>[
        HomeContent(), // Index 0
        Material(child: ChatPage()), // Index 1
        Material(child: OrderPage()),     // Index 2
        Material(child: MarketplacePage()),// Index 3
        Material(child: ProfilePage()),   // Index 4
    ];

    void _onItemTapped(int index)
    {
        setState(()
            {
                _selectedIndex = index;
            }
        );
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
            backgroundColor: const Color(0xFFfafafa),

            appBar: (_selectedIndex == 0 || _selectedIndex == 1 ) ? _buildAppBar() : null,

            body: IndexedStack(
                index: _selectedIndex,
                children: _widgetOptions,
            ),

            bottomNavigationBar: _buildBottomNavBar(l10n),
        );
    }

    PreferredSizeWidget _buildAppBar()
    {
        return AppBar(
            toolbarHeight: 100.0,
            backgroundColor: MainColors.appbarbackground,
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.05),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            leadingWidth: 140,
            leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.asset('assets/logos/tottologo.png', fit: BoxFit.contain),
            ),
            actions: [
                IconButton(
                    icon: Image.asset('assets/logos/notification.png', width: 28, height: 28),
                    onPressed: ()
                    {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPage()),);
                    },
                ),
                const SizedBox(width: 8),
            ],
        );
    }

    Widget _buildBottomNavBar(AppLocalizations l10n)
    {
        return Container(
            height: 70,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))],
            ),
            child: SafeArea(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        _buildCustomNavItem(iconAsset: 'assets/logos/Home.png', label: l10n.navHome, index: 0),
                        _buildCustomNavItem(iconAsset: 'assets/logos/mark_email_unread.png', label: l10n.navChat, index: 1),
                        _buildCustomNavItem(iconAsset: 'assets/logos/Order.png', label: l10n.navOrder, index: 2),
                        _buildCustomNavItem(iconAsset: 'assets/logos/add_business.png', label: l10n.navMarketplace, index: 3),
                        _buildCustomNavItem(iconAsset: 'assets/logos/Profile.png', label: l10n.navProfile, index: 4),
                    ],
                ),
            ),
        );
    }

    Widget _buildCustomNavItem({
        required String iconAsset,
        required String label,
        required int index,
    })
    {
        final bool isSelected = _selectedIndex == index;
        return InkWell(
            onTap: () => _onItemTapped(index),
            borderRadius: BorderRadius.circular(30),
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: isSelected ? Colors.red.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                        ImageIcon(AssetImage(iconAsset),
                            color: isSelected ? const Color(0xFFDC143C) : Colors.grey.shade600),
                        if (isSelected)
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(label,
                                style: const TextStyle(
                                    color: Color(0xFFDC143C), fontWeight: FontWeight.bold)))
                    ])));
    }
}

class HomeContent extends StatelessWidget
{
    const HomeContent({super.key});

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        return SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    children: [
                        const SizedBox(height: 16),
                        const HeaderTextBlock(),
                        const SizedBox(height: 24),
                        Row(
                            children: [
                                Expanded(
                                    child: _buildActionCard(
                                        context,
                                        imagePath: 'assets/selling.png',
                                        backgroundImagePath: 'assets/startsellingbackground.png',
                                        title: l10n.startSelling,
                                        onPressed: () {
                                            print('Start Selling Tapped');

                                            Navigator.push(context,MaterialPageRoute(
                                              builder:(context) =>
                                              ChatPage()
                                            ,)
                                              ,);



                                           }




                                    ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                    child: _buildActionCard(
                                        context,
                                        imagePath: 'assets/buying.png',
                                        backgroundImagePath: 'assets/buyproductbackground.png',
                                        title: l10n.buyProducts,
                                        onPressed: () { print('Buy Products Tapped');
                                          Navigator.push(context,MaterialPageRoute(builder: (context)
                                          =>
                                     MarketplacePage()
                                          ,),);



                                        },
                                    ),
                                ),
                            ],
                        ),
                        const SizedBox(height: 24),
                        _buildDiscoverBanner(context),
                    ],
                ),
            ),
        );
    }

    Widget _buildActionCard(
        BuildContext context, {
            required String imagePath,
            required String title,
            required VoidCallback onPressed,
            required String backgroundImagePath,
        })
    {
        return Column(
            children: [
                Container(
                    height: 200,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                            colors: [Colors.red.shade100, Colors.red.shade50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                        ),
                    ),
                    child: Stack(
                        alignment: Alignment.center,
                        children: [
                            Image.asset(backgroundImagePath, width: double.infinity, height: double.infinity, fit: BoxFit.cover, color: Colors.white.withOpacity(0.8), colorBlendMode: BlendMode.dstATop),
                            Image.asset(imagePath, height: 180, errorBuilder: (c, e, s) => Icon(Icons.image, size: 50, color: Colors.red.shade200)),
                        ],
                    ),
                ),
                const SizedBox(height: 8),
                PrimaryButton(
                    text: title,
                    onPressed: onPressed,
                    borderRadius: 8.0,
                ),
            ],
        );
    }

    Widget _buildDiscoverBanner(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFFfafafa),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFFeeeeee),
                    width: 2,
                ),
            ),
            child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(l10n.discoverGroupsTitle, style: const TextStyle(color: Color(0xFFDC143C),
                                        fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(l10n.discoverGroupsSubtitle,
                                    style: const TextStyle(color: Colors.black54, fontSize: 12)),
                            ])),
                    const SizedBox(width: 16),
                    Container(decoration: const BoxDecoration(shape: BoxShape.circle,
                            color: Color(0xFFDC143C)), child: const Icon(Icons.arrow_forward, color: Colors.white)),
                ]));
    }
}
