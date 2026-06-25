import 'package:flutter/material.dart';

import '../services/stock_api_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/stock_card.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  static const List<StockQuote> _marketSnapshot = [
    StockQuote(
      symbol: 'AAPL',
      close: 195.32,
      open: 193.10,
      high: 196.20,
      low: 192.80,
      date: '2026-06-20T00:00:00+0000',
    ),
    StockQuote(
      symbol: 'MSFT',
      close: 420.10,
      open: 417.50,
      high: 422.40,
      low: 416.80,
      date: '2026-06-20T00:00:00+0000',
    ),
    StockQuote(
      symbol: 'NVDA',
      close: 138.25,
      open: 140.10,
      high: 141.30,
      low: 137.90,
      date: '2026-06-20T00:00:00+0000',
    ),
  ];

  String _companyName(String symbol) {
    switch (symbol) {
      case 'AAPL':
        return 'Apple';
      case 'MSFT':
        return 'Microsoft';
      case 'NVDA':
        return 'NVIDIA';
      default:
        return symbol;
    }
  }

  Widget _newsCard(
      BuildContext context, {
        required String category,
        required String title,
        required String description,
        required IconData icon,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening news preview: $title'),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF171A2E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF1177FF).withOpacity(0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF1177FF),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF1177FF),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'Market Snapshot',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select a stock to view detailed price information and charts.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 18),

          ..._marketSnapshot.map((quote) {
            final sign = quote.percentChange >= 0 ? '+' : '';

            return StockCard(
              name: _companyName(quote.symbol),
              symbol: quote.symbol,
              price: '\$${quote.close.toStringAsFixed(2)}',
              change: '$sign${quote.percentChange.toStringAsFixed(2)}%',
              isPositive: quote.isPositive,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/stock-detail',
                  arguments: quote,
                );
              },
            );
          }),

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
            context,
            category: 'Europe',
            title: 'European markets remain active as investors review earnings.',
            description:
            'Technology, banking and industrial companies remain in focus.',
            icon: Icons.public,
          ),

          _newsCard(
            context,
            category: 'Technology',
            title: 'AI-related stocks continue to attract market attention.',
            description:
            'Investors are monitoring major technology companies closely.',
            icon: Icons.memory_outlined,
          ),

          _newsCard(
            context,
            category: 'Portfolio',
            title: 'Diversification remains important during market volatility.',
            description:
            'Balanced portfolios can help manage short-term price changes.',
            icon: Icons.account_balance_wallet_outlined,
          ),
        ],
      ),
    );
  }
}