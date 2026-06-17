import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class ProPage extends StatelessWidget {
  const ProPage({super.key});

  Widget _feature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF22D39A)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional'),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            const Icon(
              Icons.workspace_premium,
              color: Color(0xFFECCB78),
              size: 70,
            ),

            const SizedBox(height: 16),

            const Text(
              'Unlock institutional-grade data',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'One step ahead with advanced charts, unlimited watchlist and market signals.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF171A2E),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  const Text(
                    '€19.99 / month',
                    style: TextStyle(
                      color: Color(0xFFECCB78),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _feature('Advanced technical indicators'),
                  _feature('Unlimited watchlist'),
                  _feature('Real-time market alerts'),
                  _feature('Professional portfolio insights'),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFECCB78),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: const Text('Start Pro Plan'),
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
}