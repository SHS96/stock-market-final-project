import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/market_page.dart';
import 'pages/stock_detail_page.dart';
import 'pages/portfolio_page.dart';
import 'pages/pro_page.dart';

void main() {
  runApp(const AsterMarketsApp());
}

class AsterMarketsApp extends StatelessWidget {
  const AsterMarketsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aster Markets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0E1020),
        primaryColor: const Color(0xFF1177FF),
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0E1020),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF171A2E),
          selectedItemColor: Color(0xFF1177FF),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/market': (context) => const MarketPage(),
        '/stock-detail': (context) => const StockDetailPage(),
        '/portfolio': (context) => const PortfolioPage(),
        '/pro': (context) => const ProPage(),
      },
    );
  }
}