import 'package:crypto_app/const/constants.dart';
import 'package:crypto_app/pages/home/home_page.dart';
import 'package:crypto_app/pages/navigationbar_page/wallet/wallet_page.dart';
import 'package:crypto_app/pages/search/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationBarView extends StatefulWidget {
  const NavigationBarView({super.key});

  @override
  State<NavigationBarView> createState() => _NavigationBarViewState();
}

class _NavigationBarViewState extends State<NavigationBarView> {
  int _selectedIndex = 0;

  // List of screens to navigate to
  List<Widget> _screens = [
    HomePage(), // Home Screen
    SearchPage(),
    WalletPage(),
    Center(child: Text("Settings")), // Settings Screen
    Center(child: Text("wallet")), // wallet Screen
  ];

  Constants myConstants = Constants();

  // Method to handle item taps in the BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: Container(
        height: 70,
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: _selectedIndex,
          // Set current index
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              activeIcon: Image.asset(
                "assets/image/navigation_image/active_home.png",
                color: CupertinoColors.systemIndigo,
                // Set color for active item
                width: 25,
                height: 24,
              ),
              icon: Image.asset(
                "assets/image/navigation_image/home.png",
                width: 25,
                height: 24,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Search',
              activeIcon: Image.asset(
                "assets/image/navigation_image/active_search.png",
                color: CupertinoColors.systemIndigo,
                width: 24,
                height: 24,
              ),
              icon: Image.asset(
                "assets/image/navigation_image/search.png",
                width: 25,
                height: 24,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Wallet',
              activeIcon: Image.asset(
                "assets/image/navigation_image/active_wallet.png",
                color: CupertinoColors.systemIndigo,
                // Set color for active item
                width: 22,
                height: 22,
              ),
              icon: Image.asset(
                "assets/image/navigation_image/wallet.png",
                width: 22,
                height: 22,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Wallet',
              activeIcon: Image.asset(
                "assets/image/navigation_image/active_settings.png",
                color: CupertinoColors.systemIndigo,
                // Set color for active item
                width: 22,
                height: 22,
              ),
              icon: Image.asset(
                "assets/image/navigation_image/settings.png",
                width: 22,
                height: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
