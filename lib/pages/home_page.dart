import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/stock_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _marketBox(String title, String value, String change, bool positive) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171A2E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            change,
            style: TextStyle(
              color: positive ? const Color(0xFF22D39A) : const Color(0xFFFF5A76),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Icon(Icons.show_chart, color: Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aster Markets'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            const Text(
              'European market pulse',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Track market prices, news and your portfolio.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _marketBox('DAX', '18,497.32', '+0.82%', true),
                  const SizedBox(width: 12),
                  _marketBox('FTSE 100', '8,231.14', '-0.18%', false),
                  const SizedBox(width: 12),
                  _marketBox('CAC 40', '7,992.10', '+0.41%', true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Watchlist',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            StockCard(
              name: 'ASML Holding',
              symbol: 'ASML',
              price: '€912.40',
              change: '+2.46%',
              isPositive: true,
              onTap: () {
                Navigator.pushNamed(context, '/stock-detail');
              },
            ),
            StockCard(
              name: 'SAP',
              symbol: 'SAP',
              price: '€183.22',
              change: '+1.18%',
              isPositive: true,
              onTap: () {
                Navigator.pushNamed(context, '/stock-detail');
              },
            ),
            StockCard(
              name: 'LVMH',
              symbol: 'LVMH',
              price: '€736.10',
              change: '-0.72%',
              isPositive: false,
              onTap: () {
                Navigator.pushNamed(context, '/stock-detail');
              },
            ),
          ],
        ),
      ),
    );
  }
}