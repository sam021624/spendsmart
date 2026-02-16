import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spendsmart/views/home/presentation/home_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();

    _pages = [HomeScreen(), HomeScreen(), HomeScreen(), HomeScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Ionicons.home_outline),
            selectedIcon: Icon(Ionicons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Ionicons.cash_outline),
            selectedIcon: Icon(Ionicons.cash),
            label: 'Balance',
          ),
          NavigationDestination(
            icon: Icon(Ionicons.analytics_outline),
            selectedIcon: Icon(Ionicons.analytics),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Ionicons.person_outline),
            selectedIcon: Icon(Ionicons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
