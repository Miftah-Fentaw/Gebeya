import 'package:gebeya/constants/Colors.dart';
import 'package:gebeya/pages/Browse/browse_page.dart';
import 'package:gebeya/pages/Cart/cart_page.dart';
import 'package:gebeya/pages/Orders/Orders.dart';
import 'package:gebeya/pages/Seettings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:gebeya/pages/Home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:gebeya/providers/cart-provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  final List<Widget> _screens = [
    HomePage(),
    BrowsePage(),
    CartPage(),
    Orders(),
    SettingsPage(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home,color: black),
        title: "Home",
       activeColorSecondary: black,
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopify,color: black),
        title: "Browse",
        activeColorSecondary: black,
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: grey,
      ),
      PersistentBottomNavBarItem(
        icon: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            final itemCount = cartProvider.totalItems;
            return Stack(
              children: [
                Icon(Icons.shopping_cart, color: black),
                if (itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$itemCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        title: "Cart",
        activeColorSecondary: black,
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.local_mall_outlined,color: black),
        title: "orders",
        activeColorSecondary: black,
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings,color: black),
        title: "Settings",
        activeColorSecondary: black,
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _screens,
      items: _navBarsItems(),
      decoration: NavBarDecoration(
        gradient: LinearGradient(
          colors: [gradient_start, gradient_end],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      navBarStyle: NavBarStyle.style7,
    );
  }
}












