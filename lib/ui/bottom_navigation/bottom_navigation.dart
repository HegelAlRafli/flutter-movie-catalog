import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/services/providers/bottom_navigation_provider.dart';
import 'package:tmdb/ui/home/home.dart';

import '../../common/color_value.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final _tabs = [
    Home(),
    Home(),
    Home(),
  ];

  final _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_filled),
      activeIcon: Icon(Icons.home_filled),
      label: 'Beranda',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      activeIcon: Icon(Icons.favorite),
      label: 'Favorit',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      activeIcon: Icon(Icons.person),
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomNavigationProvider>(context);

    return Scaffold(
      body: _tabs[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: provider.currentIndex,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.withOpacity(0.7),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: TextStyle(
          color: ColorValue.greyColor,
          fontSize: 10,
        ),
        unselectedLabelStyle: TextStyle(
          color: ColorValue.greyColor,
          fontSize: 10,
        ),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        elevation: 5,
        onTap: (index) {
          provider.currentIndex = index;
        },
      ),
    );
  }
}
