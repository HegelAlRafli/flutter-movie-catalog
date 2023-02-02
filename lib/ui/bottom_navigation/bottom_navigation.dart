import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb/ui/home/home.dart';
import 'package:tmdb/ui/profile/profile.dart';

import '../../common/color_value.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;

  const BottomNavigation({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final _tabs = [
    Home(),
    Home(),
    Profile(),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
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
          _currentIndex = index;
        },
      ),
    );
  }
}
