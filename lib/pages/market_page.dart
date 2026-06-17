import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/stock_card.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  Widget _newsCard(String title, String subtitle) {
    return Card(
      color: const Color(0xFF171A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.article, color: Color(0xFF1177FF)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market & News'),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            const Text(
              'Market Snapshot',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            StockCard(
              name: 'Apple Inc.',
              symbol: 'AAPL',
              price: '\$213.45',
              change: '+1.35%',
              isPositive: true,
              onTap: () {
                Navigator.pushNamed(context, '/stock-detail');
              },
            ),
            StockCard(
              name: 'Tesla',
              symbol: 'TSLA',
              price: '\$178.32',
              change: '-0.92%',
              isPositive: false,
              onTap: () {
                Navigator.pushNamed(context, '/stock-detail');
              },
            ),
            StockCard(
              name: 'Microsoft',
              symbol: 'MSFT',
              price: '\$420.10',
              change: '+0.67%',
              isPositive: true,
              onTap: () {
                Navigator.pushNamed(context, '/stock-detail');
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Latest Market News',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _newsCard(
              'European markets move higher',
              'Technology and banking sectors lead the recovery.',
            ),
            _newsCard(
              'AI infrastructure trade is broadening',
              'Investors watch semiconductor and cloud companies.',
            ),
            _newsCard(
              'Energy traders watch supply risks',
              'Oil and gas stocks remain volatile this week.',
            ),
          ],
        ),
      ),
    );
  }
}