import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  Widget _navIcon(String assetPath, bool isSelected) {
    return SvgPicture.asset(
      assetPath,
      width: 25,
      height: 25,
      colorFilter: ColorFilter.mode(
        isSelected ? const Color(0xFF146CFF) : Colors.grey,
        BlendMode.srcIn,
      ),
    );
  }

  void _goToPage(BuildContext context, int index) {
    if (index == currentIndex) return;

    String routeName;

    switch (index) {
      case 0:
        routeName = '/home';
        break;
      case 1:
        routeName = '/market';
        break;
      case 2:
        routeName = '/portfolio';
        break;
      case 3:
        routeName = '/pro';
        break;
      default:
        routeName = '/home';
    }

    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _goToPage(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF171A2E),
      selectedItemColor: const Color(0xFF146CFF),
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: _navIcon('assets/tabs/tab_home.svg', currentIndex == 0),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _navIcon('assets/tabs/tab_news.svg', currentIndex == 1),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: _navIcon('assets/tabs/tab_assets.svg', currentIndex == 2),
          label: 'Assets',
        ),
        BottomNavigationBarItem(
          icon: _navIcon('assets/tabs/tab_pro.svg', currentIndex == 3),
          label: 'Pro',
        ),
      ],
    );
  }
}