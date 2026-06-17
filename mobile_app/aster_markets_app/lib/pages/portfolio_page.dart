import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  Widget _assetItem(String name, String shares, String value, String change, bool positive) {
    return Card(
      color: const Color(0xFF171A2E),
      child: ListTile(
        title: Text(name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(shares, style: const TextStyle(color: Colors.grey)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: const TextStyle(color: Colors.white)),
            Text(
              change,
              style: TextStyle(
                color: positive ? const Color(0xFF22D39A) : const Color(0xFFFF5A76),
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
        title: const Text('Portfolio'),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF171A2E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Assets', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Text(
                    '€128,540.20',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '+€2,145.20 today',
                    style: TextStyle(
                      color: Color(0xFF22D39A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'My Holdings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _assetItem('ASML', '5 shares', '€4,562.00', '+2.46%', true),
            _assetItem('SAP', '8 shares', '€1,465.76', '+1.18%', true),
            _assetItem('LVMH', '2 shares', '€1,472.20', '-0.72%', false),
          ],
        ),
      ),
    );
  }
}